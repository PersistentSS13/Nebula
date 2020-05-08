/obj/machinery/cryopod/chargen/proc/send_to_outpost()
	if(!istype(occupant))
		return

	for(var/turf/T in GLOB.latejoin_cryo)
		if(locate(/mob) in T)
			continue
		occupant.forceMove(T)

/obj/machinery/cryopod/chargen/check_occupant_allowed(mob/M)
	var/allowed = M.mind.finished_chargen
	if(!allowed)
		to_chat(M, SPAN_NOTICE("The [src] beeps: Please finished your dossier on the terminal before proceeding to cryostasis."))
	return allowed

/obj/machinery/cryopod/chargen/set_occupant(var/mob/living/carbon/occupant, var/silent)
	. = ..()
	to_chat(occupant, SPAN_NOTICE("The [src] beeps: Launch procedure initiated. Please wait..."))
	addtimer(CALLBACK(src, /obj/machinery/cryopod/chargen/proc/send_to_outpost), 5 SECONDS)