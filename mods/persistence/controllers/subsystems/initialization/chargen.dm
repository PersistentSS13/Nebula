var/global/list/chargen_spawns = list()

SUBSYSTEM_DEF(chargen)
	name = "Chargen"
	init_order = SS_INIT_MAPPING
	flags = SS_NO_FIRE

	var/map_z			// What z-level is being used for the pods.


/datum/controller/subsystem/chargen/Initialize()
	INCREMENT_WORLD_Z_SIZE
	map_z = world.maxz

	report_progress("Loading chargen map data.")
	var/datum/map_load_metadata/M = maploader.load_map(file("maps/chargen/chargen.dmm"), 1, 1, map_z)
	if (M)
		var/width = M.bounds[4]
		var/height = M.bounds[5]

		report_progress("Created chargen away site at [M.bounds[3]].")
		for(var/x in 1 to FLOOR(world.maxx / width))
			for(var/y in 1 to FLOOR(world.maxy / height))
				// We already loaded the first one at (1, 1) so skip it 
				if(x == 1 && y == 1)
					continue
				maploader.load_map(file("maps/chargen/chargen.dmm"), ((x - 1) * width) + 1, ((y - 1) * height) + 1, map_z, no_changeturf = TRUE)
				CHECK_TICK

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
