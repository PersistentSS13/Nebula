/obj/structure/window/attackby(obj/item/W, mob/user)
	// The user is trying to deconstruct the window, so check for permissions.
	if(istype(W, /obj/item/gun/energy/plasmacutter) || isCrowbar(W) || isScrewdriver(W) || isWrench(W))
		if(!check_area_protection(user))
			to_chat(user, SPAN_DANGER("A magnetic force repels your attempt to deconstruct \the [src]!"))
			return FALSE

	. = ..()