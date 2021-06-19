/obj/effect/overmap/visitable
	should_save = TRUE 		 // Overmap sectors move themselves from the overmap to either a z-level or an area for landable ships on save.TRUE
					  		 // If the area or z-level is saved, the overmap effect will be saved.
	var/atom/old_loc	 	 // Where the ship was prior to saving. Used to relocate the ship following saving, not on load.

/obj/effect/overmap/visitable/Initialize()
	. = ..()
	events_repository.register(/decl/observ/world_saving_start_event, SSpersistence, src, .proc/on_saving_start)
	events_repository.register(/decl/observ/world_saving_finish_event, SSpersistence, src, .proc/on_saving_end)

/obj/effect/overmap/visitable/Destroy()
	. = ..()
	events_repository.unregister(/decl/observ/world_saving_start_event, SSpersistence, src)
	events_repository.unregister(/decl/observ/world_saving_finish_event, SSpersistence, src)

/obj/effect/overmap/visitable/proc/on_saving_start()
	// Record where to replace the sector upon reinitialization
	start_x = x
	start_y = y

	old_loc = loc 

	// Force move the sector to its z level(s) so that it can properly reinitialize.
	forceMove(locate(world.maxx/2, world.maxy/2, map_z[1]))

/obj/effect/overmap/visitable/proc/on_saving_end()
	forceMove(old_loc)