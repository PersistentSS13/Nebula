
/obj/abstract/turbolift_spawner/outreach
	name = "outreach base elevator placeholder"
	depth = 4
	lift_size_x = 4
	lift_size_y = 4
	areas_to_use = list(
		/area/turbolift/outreach/b2,
		/area/turbolift/outreach/b1,
		/area/turbolift/outreach/ground_floor,
		/area/turbolift/outreach/f1,
	)
	door_type  = /obj/machinery/door/airlock/lift
	panel_type = /obj/structure/lift/panel/outreach

/obj/structure/lift/panel/outreach
	var/tmp/datum/sound_token/muzak

/obj/structure/lift/panel/outreach/Initialize(mapload, datum/turbolift/_lift)
	. = ..()
	muzak = play_looping_sound(src, "elevator_muzak", 'sound/music/elevatormusic.ogg', 20, 10, 1, prefer_mute = TRUE, streaming = TRUE)

/obj/structure/lift/panel/outreach/Destroy()
	QDEL_NULL(muzak)
	return ..()