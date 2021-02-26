/mob/living/carbon/human/proc/ignore_persistent_spawn()
#ifdef UNIT_TEST
	return TRUE
#else
	return FALSE
#endif

/mob/living/carbon/human/dummy/ignore_persistent_spawn()
	return TRUE

/mob/living/carbon/human/quantum/ignore_persistent_spawn()
	return TRUE

/mob/living/carbon/human/Initialize()
	. = ..()

	if(ignore_persistent_spawn())
		return

	// Safety check. If a character spawned outside of a saved area, we want to move them to their last spawn.
	if(!(z in SSpersistence.saved_levels))
		if(istype(home_spawn))
			if(locate(/mob) in get_turf(home_spawn))
				// Someone or something was in your bed/cryopod.
				forceMove(get_spawn_turf())
			else
				forceMove(get_turf(home_spawn)) // Welcome home!
		else
			forceMove(get_spawn_turf()) // Sorry man. Your bed/cryopod was not set.

	// Check if humans are asleep on startup.
	if(!istype(client))
		goto_sleep()
		
/mob/living/carbon/human/proc/get_spawn_turf()
	var/spawn_turf
	for(var/obj/machinery/cryopod/C in SSmachines.machinery)
		spawn_turf = locate(C.x, C.y, C.z)
	if(!spawn_turf)
		spawn_turf = locate(100,100,1)
	return spawn_turf

/mob/living/carbon/human/Logout()
	. = ..()
	addtimer(CALLBACK(src, /mob/living/carbon/human/proc/goto_sleep), 5 MINUTES)

	var/obj/bed = locate(/obj/structure/bed) in get_turf(src)
	var/obj/cryopod = locate(/obj/machinery/cryopod) in get_turf(src)
	if(istype(bed))
		// We logged out in a bed or cryopod. Set this as home_spawn.
		home_spawn = bed
	if(istype(cryopod))
		// We logged out in a bed or cryopod. Set this as home_spawn.
		home_spawn = cryopod

/mob/living/carbon/human/proc/goto_sleep()
	if(istype(client))
		// We have a client, so we're awake.
		return

	if(locate(/obj/structure/bed) in get_turf(src))
		SetStasis(20, STASIS_SLEEP) // beds are better.
		return

	//Apply sleeping stasis.
	SetStasis(10, STASIS_SLEEP)