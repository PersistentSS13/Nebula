/turf/simulated/wall/attackby(var/obj/item/W, var/mob/user, click_params)
	// The user is trying to deconstruct the wall, so check for permissions.
	if(isWelder(W) || isWirecutter(W) || isCrowbar(W) || W.is_special_cutting_tool() || istype(W,/obj/item/pickaxe) || istype(W,/obj/item/rcd))
		if(!check_area_protection(user))
			to_chat(user, SPAN_DANGER("A magnetic force repels your attempt to deconstruct \the [src]!"))
			return FALSE

	. = ..()