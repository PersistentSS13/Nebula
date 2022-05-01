// var/global/list/chargen_spawns = list()
var/global/list/chargen_areas = list() //List of pod areas, and a number of times assigned was called on a given area for debugging purpose
var/global/list/chargen_landmarks //List of all the chargen landmarks available for spawn.

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
	//Grab first free pod
	for(var/area/chargen/A in chargen_areas)
		if(chargen_areas[A] > 0)
			continue
		var/obj/abstract/landmark/chargen_spawn/L = locate(/obj/abstract/landmark/chargen_spawn) in A
		var/turf/spawnturf = L? get_turf(L) : null
		if(!L)
			log_warning("Area '[log_info_line(A)]' contains no '/obj/abstract/landmark/chargen_spawn' for spawning characters..")
			spawnturf = locate(/turf/unsimulated/floor) in A
		return spawnturf

	var/chargen_warning = "SSChargen: Warning, the system is currently out of spawn pods to spawn new players in!"
	message_staff(chargen_warning)
	log_warning(chargen_warning)
	return null

/datum/controller/subsystem/chargen/proc/assign_spawn_pod(var/area/chargen/pod)
	chargen_areas[pod] += 1

	//Remove it from the list of landmarks
	if(!pod.chargen_landmark)
		log_warning("Chargen pod '[pod]' has not landmark set!")
		return
	
	//Because spawnpoints don't have a proc to return turfs and instead just share their turf var to grab the available turfs, we gotta change the spawnpoint :D
	var/decl/spawnpoint/chargen/C = GET_DECL(/decl/spawnpoint/chargen)
	if(C)
		LAZYREMOVE(C.turfs, get_turf(pod.chargen_landmark))
	log_debug("SSChargen: Assigned area '[pod]' with '[chargen_areas[pod]]' assigned users currently!")

/datum/controller/subsystem/chargen/proc/release_spawn_pod(var/area/chargen/pod)
	chargen_areas[pod] -= 1

	//Add it to the list of landmarks
	if(!pod.chargen_landmark)
		log_warning("Chargen pod '[pod]' has not landmark set!")
		return

	//Because spawnpoints don't have a proc to return turfs and instead just share their turf var to grab the available turfs, we gotta change the spawnpoint :D
	var/decl/spawnpoint/chargen/C = GET_DECL(/decl/spawnpoint/chargen)
	if(C)
		LAZYDISTINCTADD(C.turfs, get_turf(pod.chargen_landmark))

	//Remove trash from the room
	pod.run_chargen_cleanup()
	log_debug("SSChargen: Un-assaigned area '[pod]' with '[chargen_areas[pod]]' assigned users currently!")

//Landmark
/obj/abstract/landmark/chargen_spawn
	delete_me = FALSE //Currently re-used to keep track of the spawn position

/obj/abstract/landmark/chargen_spawn/Initialize()
	var/area/chargen/A = get_area(src)
	if(!istype(A))
		log_warning("[src] is outside of a '/area/chargen' area!! Only place '/obj/abstract/landmark/chargen_spawn' inside a '/area/chargen'!!")
	A.chargen_landmark = src //Cache the landmark to save some time
	chargen_areas[A] = 0 //Set the area to free
	LAZYDISTINCTADD(chargen_landmarks, src)
	. = ..()

/obj/abstract/landmark/chargen_spawn/Destroy()
	var/area/chargen/A = get_area(src)
	if(istype(A) && A.chargen_landmark == src)
		A.chargen_landmark = null
	LAZYREMOVE(chargen_landmarks, src)
	return ..()

//Annoying stuff
/mob/living/carbon/human/Destroy()
	var/area/chargen/A = get_area(src)
	if(istype(A) && SSchargen)
		SSchargen.release_spawn_pod(A)
	. = ..()
