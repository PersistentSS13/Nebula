/**
	Specialized spawnpoint for joining a chargen room before spawning in the world.
 */
/decl/spawnpoint/chargen
	uid = "spawn_chargen"

/decl/spawnpoint/chargen/after_join(mob/victim)
	var/turf/myturf    = get_turf(victim.loc)
	var/area/chargen/A = get_area(myturf)
	if(istype(A))
		SSchargen.assign_spawn_pod(A, victim) //Mark the pod area as reserved
	else
		var/mess = "'[victim]' (CKEY: [victim.ckey]) spawned outside chargen for some reasons."
		log_warning(mess)
		message_staff(mess)
		to_chat(victim, log_warning("Something went wrong during spawn. Please contact the server staff!"))

///////////////////////////////////////////////////////////////////////////
// Chargen Room Spawn Position extension
///////////////////////////////////////////////////////////////////////////

// /datum/extension/spawn_position/chargen
// 	expected_type = /obj/abstract/landmark/chargen_spawn
// 	provider      = /decl/spawnpoint/chargen

// /datum/extension/spawn_position/chargen/is_busy()
// 	return SSchargen.is_chargen_room_busy(get_area(holder))

///////////////////////////////////////////////////////////////////////////
// Spawnpoint Landmark for Chargen Rooms
///////////////////////////////////////////////////////////////////////////

/**
	Landmark for spawning into a chargen room.
 */
/obj/abstract/landmark/chargen_spawn
	delete_me = FALSE //Currently re-used to keep track of the spawn position
	var/spawn_decl = /decl/spawnpoint/chargen

INITIALIZE_IMMEDIATE(/obj/abstract/landmark/chargen_spawn)
/obj/abstract/landmark/chargen_spawn/Initialize(mapload)
	var/area/chargen/A = get_area(src)
	if(!istype(A))
		log_warning("[src] is outside of a '/area/chargen' area!! Only place '/obj/abstract/landmark/chargen_spawn' inside a '/area/chargen'!!")
		return INITIALIZE_HINT_QDEL
	//set_extension(src, /datum/extension/spawn_position/chargen, spawn_decl)
	var/decl/spawnpoint/SP = GET_DECL(spawn_decl)
	var/turf/T = get_turf(src)
	if(T)
		SP.add_spawn_turf(T)
	events_repository.register(/decl/observ/moved, src, src, /obj/abstract/landmark/chargen_spawn/proc/on_moved)
	. = ..()

/obj/abstract/landmark/chargen_spawn/Destroy()
	events_repository.unregister(/decl/observ/moved, src, src, /obj/abstract/landmark/chargen_spawn/proc/on_moved)
	var/decl/spawnpoint/SP = GET_DECL(spawn_decl)
	var/turf/T = get_turf(src)
	if(T)
		SP.remove_spawn_turf(T)
	. = ..()

/obj/abstract/landmark/chargen_spawn/proc/on_moved(atom/movable/moving_instance, atom/old_loc, atom/new_loc)
	log_warning("[log_info_line(src)] was moved to [log_info_line(new_loc)] when it should remain where it was created!")
