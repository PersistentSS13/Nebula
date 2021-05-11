// This mob generically just holds a mind to show that it's
// still floating around .. somewhere.
/mob/living/limbo
	use_me = 0
	//icon = 'icons/obj/surgery.dmi'
	//icon_state = "cortical-stack"

/mob/living/limbo/Initialize()
	. = ..()
	verbs |= /mob/proc/resleeve
	verbs |= /mob/proc/death_give_up