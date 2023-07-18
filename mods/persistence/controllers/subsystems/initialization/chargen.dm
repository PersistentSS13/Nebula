var/global/list/chargen_areas = list() //List of pod areas, and a number of times assigned was called on a given area for debugging purpose
var/global/list/chargen_landmarks = list() //List of all the chargen landmarks available for spawn.
#define MAX_NB_CHAR_GEN_PODS 20

SUBSYSTEM_DEF(chargen)
	name = "Chargen"
	init_order = SS_INIT_MAPPING
	flags = SS_NO_FIRE
	var/map_z			// What z-level is being used for the pods.

	var/obj/abstract/limbo_holder

/datum/controller/subsystem/chargen/Initialize()
	SSmapping.increment_world_z_size(/datum/level_data/chargen)
	map_z = world.maxz

	report_progress("Loading chargen map data.")
	var/datum/map_load_metadata/M = maploader.load_map(file("maps/chargen/chargen.dmm"), 1, 1, map_z)
	if (M)
		var/width = M.bounds[4]
		var/height = M.bounds[5]

		report_progress("Created chargen away site at [M.bounds[3]].")
		var/chargen_pod_counter = 1
		for(var/x in 1 to FLOOR(world.maxx / width))
			for(var/y in 1 to FLOOR(world.maxy / height))
				// We already loaded the first one at (1, 1) so skip it
				if(x == 1 && y == 1)
					continue
				if(chargen_pod_counter >= MAX_NB_CHAR_GEN_PODS)
					break
				chargen_pod_counter++
				maploader.load_map(file("maps/chargen/chargen.dmm"), ((x - 1) * width) + 1, ((y - 1) * height) + 1, map_z, no_changeturf = TRUE)
				CHECK_TICK

	limbo_holder = new(locate(world.maxx / 2, world.maxy / 2, map_z))

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
	log_debug("SSChargen: Unassaigned area '[pod]' with '[chargen_areas[pod]]' assigned users currently!")

//Landmark
/obj/abstract/landmark/chargen_spawn
	delete_me = FALSE //Currently re-used to keep track of the spawn position

/obj/abstract/landmark/chargen_spawn/Initialize()
	var/area/chargen/A = get_area(src)
	if(!istype(A))
		log_warning("[src] is outside of a '/area/chargen' area!! Only place '/obj/abstract/landmark/chargen_spawn' inside a '/area/chargen'!!")
	A.chargen_landmark = src //Cache the landmark to save some time
	chargen_areas[A] = 0 //Set the area to free
	global.chargen_landmarks |= src
	return ..()

/obj/abstract/landmark/chargen_spawn/Destroy()
	var/area/chargen/A = get_area(src)
	if(istype(A) && A.chargen_landmark == src)
		A.chargen_landmark = null
	global.chargen_landmarks -= src
	return ..()

//Annoying stuff
/mob/living/carbon/human/Destroy()
	var/area/chargen/A = get_area(src)
	if(istype(A) && SSchargen)
		SSchargen.release_spawn_pod(A)
	return ..()

/datum/level_data/chargen
	name        = "chargen"
	level_id    = "chargen_pods"
	level_flags = ZLEVEL_SEALED | ZLEVEL_ADMIN

//Chargen spawnpoint
/decl/spawnpoint/chargen/Initialize()
	. = ..()
	LAZYINITLIST(turfs)
	for(var/obj/abstract/landmark/chargen_spawn/C in global.chargen_landmarks)
		turfs |= get_turf(C)

/decl/spawnpoint/chargen/after_join(mob/victim)
	var/turf/myturf = get_turf(victim.loc)
	var/area/chargen/A = get_area(myturf)
	if(istype(A))
		SSchargen.assign_spawn_pod(A) //Mark the pod area as reserved
	else
		var/mess = "'[victim]' (CKEY: [victim.ckey]) spawned outside chargen for some reasons."
		log_warning(mess)
		message_staff(mess)

/datum/job/colonist/get_roundstart_spawnpoint()
	CRASH("!!!!! datum/job/colonist/get_roundstart_spawnpoint() was called! !!!!!")

#undef MAX_NB_CHAR_GEN_PODS