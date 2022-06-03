/obj/effect/overmap/visitable/sector/exoplanet/on_saving_start()
	start_x = x
	start_y = y

	old_loc = loc 

	// Force move the sector to its z level(s) so that it can properly reinitialize.
	forceMove(locate(world.maxx/2, world.maxy/2, map_z[1]))

/obj/effect/overmap/visitable/sector/exoplanet/on_saving_end()
	forceMove(old_loc)

/turf/Initialize(mapload, ...)
	. = ..()
	if(persistent_id)
		//A bit of a fix for planetary areas being generally shit
		var/obj/effect/overmap/visitable/sector/exoplanet/EXO = LAZYACCESS(global.overmap_sectors, "[z]")
		if(istype(EXO) && EXO.planetary_area && istype(loc, world.area))
			ChangeArea(src, EXO.planetary_area)