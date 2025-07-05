/mob/living/carbon/human/Logout()
	..()
	if(species) species.handle_logout_special(src)

	//#TODO: Is the whole sleep cryo thing even still relevant?
	addtimer(CALLBACK(src, /mob/living/carbon/human/proc/goto_sleep), 5 MINUTES)
	var/obj/bed = locate(/obj/structure/bed) in get_turf(src)
	var/obj/cryopod = locate(/obj/machinery/cryopod) in get_turf(src)
	if(istype(bed))
		// We logged out in a bed or cryopod. Set this as home_spawn.
		home_spawn = bed
	if(istype(cryopod))
		// We logged out in a bed or cryopod. Set this as home_spawn.
		home_spawn = cryopod
