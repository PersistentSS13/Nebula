var/list/chargen_spawns = list()

SUBSYSTEM_DEF(chargen)
	name = "Chargen"
	init_order = SS_INIT_MAPPING
	flags = SS_NO_FIRE

	var/map_z			// What z-level is being used for the pods.


/datum/controller/subsystem/chargen/Initialize()
	map_z = world.maxz++

	report_progress("Loading chargen map data.")
	var/datum/map_load_metadata/M = maploader.load_map(file('maps/persistence/chargen/chargen.dmm'), 1, 1, map_z)
	var/list/atoms_to_initialise = list()
	if (M)
		var/width = M.bounds[4]
		var/height = M.bounds[5]

		report_progress("Created chargen away site at [M.bounds[3]].")
		for(var/x in 1 to Floor(world.maxx / width))
			for(var/y in 1 to Floor(world.maxy / height))
				M = maploader.load_map(file('maps/persistence/chargen/chargen.dmm'), ((x - 1) * width) + 1, ((y - 1) * height) + 1, map_z, no_changeturf = TRUE)
				atoms_to_initialise += M.atoms_to_initialise
				CHECK_TICK
		init_atoms(M.atoms_to_initialise)

/datum/controller/subsystem/chargen/proc/init_atoms(var/list/atoms)
	if (SSatoms.atom_init_stage == INITIALIZATION_INSSATOMS)
		return // let proper initialisation handle it later

	var/list/turf/turfs = list()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/obj/machinery/machines = list()
	var/list/obj/structure/cable/cables = list()

	for(var/atom/A in atoms)
		if(istype(A, /turf))
			turfs += A
		if(istype(A, /obj/structure/cable))
			cables += A
		if(istype(A, /obj/machinery/atmospherics))
			atmos_machines += A
		if(istype(A, /obj/machinery))
			machines += A

	var/notsuspended
	if(!SSmachines.suspended)
		SSmachines.suspend()
		notsuspended = TRUE

	SSatoms.InitializeAtoms() // The atoms should have been getting queued there. This flushes the queue.

	SSmachines.setup_powernets_for_cables(cables)
	SSmachines.setup_atmos_machinery(atmos_machines)
	if(notsuspended)
		SSmachines.wake()

	for (var/i in machines)
		var/obj/machinery/machine = i
		machine.power_change()

	for (var/i in turfs)
		var/turf/T = i
		T.post_change()
		if(istype(T,/turf/simulated))
			var/turf/simulated/sim = T
			sim.update_air_properties()

/datum/controller/subsystem/chargen/proc/get_spawn_turf()
	return pick(chargen_spawns)

/datum/controller/subsystem/chargen/proc/assign_spawn_pod(var/mob/user, var/turf/location)
	var/area/chargen/A = get_area(location)
	A.assigned_to = user
	chargen_spawns -= location

/obj/effect/landmark/chargen_spawn
	delete_me = TRUE

/obj/effect/landmark/chargen_spawn/Initialize()
	chargen_spawns += loc
	. = ..()