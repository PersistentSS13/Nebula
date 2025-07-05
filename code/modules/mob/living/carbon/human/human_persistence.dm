
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

//#TODO: This shouldn't be done by the mob here. Handling it here like that we make it harder to come up with sane fallbacks.
/mob/living/carbon/human/proc/get_spawn_turf()
	var/spawn_turf
	for(var/obj/machinery/cryopod/C in SSmachines.machinery)
		spawn_turf = locate(C.x, C.y, C.z)
	if(!spawn_turf)
		spawn_turf = locate(100,100,3)
	return spawn_turf

//#TODO: Check if still relevant?
/mob/living/carbon/human/proc/goto_sleep()
	if(istype(client))
		// We have a client, so we're awake.
		return

	if(locate(/obj/structure/bed) in get_turf(src))
		set_stasis(20, STASIS_SLEEP) // beds are better.
		return

	//Apply sleeping stasis.
	set_stasis(10, STASIS_SLEEP)