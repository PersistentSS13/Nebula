/mob/living/carbon/Login()
	..()
	SetStasis(0, STASIS_SLEEP)

/mob/living/carbon/human/Login()
	. = ..()
	// Blacklist some mobs
	if(ignore_persistent_spawn())
		return

	if(mind && !mind.finished_chargen)
		var/area/chargen/A = get_area(src)
		if(istype(A))
			// We're already in a chargen area. Is it the right one?
			if(A.assigned_to == src)
				// It is. Do nothing.
				return
		
		// Move this puppy a new spawn pod.
		loc = SSchargen.get_spawn_turf()
		SSchargen.assign_spawn_pod(src, loc)