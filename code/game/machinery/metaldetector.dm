/obj/machinery/metal_detector
	name = "metal detector"
	desc = "A advanced metal detector used to detect weapons."
	icon_state = "metal_detector"
	icon = 'icons/obj/structures/barricade.dmi'
	layer = ABOVE_HUMAN_LAYER
	anchored = 1

	var/list/banned_objects=list(/obj/item/gun/projectile/,
								)

/obj/machinery/metal_detector/Crossed(var/atom/A)
//	if(istype(A, /mob/living))

	check_items(recursive_content_check(src.loc, sight_check = FALSE, include_mobs = FALSE, recursion_limit = 4))
	..()

/obj/machinery/metal_detector/proc/check_items(var/list/L)
	for(var/O in banned_objects)
		for(var/A in L)
			if(istype(A, O))
				flick("metal_detector_anim",src)
				visible_message("<span class='danger'>\The [src] sends off an alarm!</span>")
				playsound(src, 'sound/ambience/alarm4.ogg', 60, 1)
				return