/obj/effect/overmap/visitable/sector/planetoid/Initialize(mapload)
	. = ..()
	if(persistent_id)
		var/datum/planetoid_data/PD = get_planetoid_data()
		PD.set_overmap_marker(src)

/obj/effect/overmap/visitable/sector/planetoid/on_saving_start()
	start_x = x
	start_y = y

	CUSTOM_SV("old_loc", loc)

	// Force move the sector to its z level(s) so that it can properly reinitialize.
	forceMove(locate(world.maxx/2, world.maxy/2, max(map_z))) //Levels are loaded from bottom to top, so this should be fine

/obj/effect/overmap/visitable/sector/planetoid/on_saving_end()
	forceMove(LOAD_CUSTOM_SV("old_loc"))
	CLEAR_SV("old_loc")

/obj/effect/overmap/visitable/sector/planetoid/check_rent()
	return

