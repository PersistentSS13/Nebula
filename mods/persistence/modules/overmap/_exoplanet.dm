/obj/effect/overmap/visitable/sector/exoplanet/on_saving_start()
	start_x = x
	start_y = y

	old_loc = loc 

	// Force move the sector to its z level(s) so that it can properly reinitialize.
	forceMove(locate(world.maxx/2, world.maxy/2, map_z[1]))

/obj/effect/overmap/visitable/sector/exoplanet/on_saving_end()
	forceMove(old_loc)