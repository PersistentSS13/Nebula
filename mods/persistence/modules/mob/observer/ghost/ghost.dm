/mob/living/Initialize()
	. = ..()
	verbs -= /mob/living/verb/ghost

//Only admins can ghost
/mob/ghostize(var/_can_reenter_corpse = CORPSE_CAN_REENTER)
	if(!check_rights(R_ADMIN, 0, src))
		return
	return ..()

/datum/movement_handler/mob/death/DoMove()
	return // no ghosting.