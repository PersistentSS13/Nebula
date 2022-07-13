/turf/simulated/floor/attackby(var/obj/item/C, var/mob/user)
	// The user is trying to deconstruct the floor, so check for permissions.
	if(IS_WELDER(C) || istype(C, /obj/item/gun/energy/plasmacutter) || (!flooring && IS_CROWBAR(C)))
		if(!check_area_protection(user))
			to_chat(user, SPAN_DANGER("A magnetic force repels your attempt to deconstruct \the [src]!"))
			return FALSE

	. = ..()