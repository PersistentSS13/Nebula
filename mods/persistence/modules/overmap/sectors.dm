/obj/effect/overmap/visitable
	should_save = TRUE 		 // Overmap sectors move themselves from the overmap to either a z-level or an area for landable ships on save.TRUE
					  		 // If the area or z-level is saved, the overmap effect will be saved.
	var/atom/old_loc	 	 // Where the ship was prior to saving. Used to relocate the ship following saving, not on load.

/obj/effect/overmap/visitable/Initialize()
	. = ..()
	GLOB.world_saving_start_event.register(SSpersistence, src, /obj/effect/overmap/visitable/proc/on_saving_start)
	GLOB.world_saving_finish_event.register(SSpersistence, src, /obj/effect/overmap/visitable/proc/on_saving_end)

/obj/effect/overmap/visitable/Destroy()
	. = ..()
	GLOB.world_saving_start_event.unregister(SSpersistence, src)
	GLOB.world_saving_finish_event.unregister(SSpersistence, src)

/obj/effect/overmap/visitable/proc/on_saving_start()
	// Record where to replace the sector upon reinitialization
	start_x = x
	start_y = y

	old_loc = loc 

	// Force move the sector to its z level(s) so that it can properly reinitialize.
	forceMove(pick(get_area_turfs(locate(/area/outreach/outpost/sleeproom))))

/obj/effect/overmap/visitable/proc/on_saving_end()
	forceMove(old_loc)