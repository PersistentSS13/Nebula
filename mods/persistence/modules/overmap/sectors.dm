/obj/effect/overmap/visitable
	should_save = TRUE 		 // Overmap sectors move themselves from the overmap to either a z-level or an area for landable ships on save.TRUE
					  		 // If the area or z-level is saved, the overmap effect will be saved.
	var/atom/old_loc	 	 // Where the ship was prior to saving. Used to relocate the ship following saving, not on load.

	var/rent_amount = 15000	  // The amount of rent per period.
	var/paid_rent = 0		  // The rent paid so far.
	var/rent_period = 14 DAYS // Time between rent payments.
	var/last_due			  // The last time the rent was due.

/obj/effect/overmap/visitable/Initialize()
	. = ..()
	events_repository.register(/decl/observ/world_saving_start_event, SSpersistence, src, .proc/on_saving_start)
	events_repository.register(/decl/observ/world_saving_finish_event, SSpersistence, src, .proc/on_saving_end)
	if(!last_due)
		last_due = world.realtime

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

	if(check_rent())
		for(var/sector_z in map_z)
			SSpersistence.AddSavedLevel(sector_z)

/obj/effect/overmap/visitable/proc/on_saving_end()
	for(var/sector_z in map_z)
		SSpersistence.RemoveSavedLevel(sector_z)
	forceMove(old_loc)

/obj/effect/overmap/visitable/proc/check_rent()
	if(!SSpersistence.rent_enabled || (world.realtime < last_due + rent_period))
		return TRUE
	if(paid_rent - rent_amount >= 0)
		paid_rent -= rent_amount
		last_due = world.realtime
		return TRUE
	return FALSE

// This is terrible, but because of when they are generated, there's no good way to override the creation of visiting_shuttle landmarks without
// a ridiculous amount of copypasta.
/obj/effect/overmap/visitable/add_landmark(obj/effect/shuttle_landmark/landmark, shuttle_restricted_type)
	if(istype(landmark, /obj/effect/shuttle_landmark/visiting_shuttle))
		qdel(landmark)
		return
	. = ..()