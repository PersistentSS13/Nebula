/obj/effect/overmap/visitable/ship/landable/on_saving_start()
	// In case the ship is landed in a sector, save where the sector is located.
	start_x = loc.x
	start_y = loc.y

	old_loc = loc
	
	// Find where the ship currently is. If the ship is landed, its home z-level won't be saved unless something else is saving it.
	var/datum/shuttle/ship_shuttle = SSshuttle.shuttles[shuttle]
	if(!ship_shuttle || !ship_shuttle.current_location)
		log_error("Could not move the landable ship [src] into its current location!")
	forceMove(get_turf(ship_shuttle.current_location))

/obj/effect/overmap/visitable/ship/landable/find_z_levels()
	// The ship has had its sector saved.
	if(landmark)
		if(landmark.z) // Check to make sure there isn't a floating reference to the landmark that saved it instead.
			map_z += landmark.z
			return
	// Otherwise, the ship has likely landed elsewhere, and needs to reconstruct its space z-level.
	qdel(landmark)
	. = ..()

// The landable ship contains a reference to its landmark, so only save if the ship is in its z-level.
/obj/effect/shuttle_landmark/ship/should_save()
	var/datum/shuttle/S = SSshuttle.shuttles[shuttle_name]
	if(S && S.current_location && S.current_location == src)
		return TRUE
	return FALSE

/obj/effect/shuttle_landmark/ship/Initialize(mapload, shuttle_name)
	if(SSpersistence.in_loaded_world && shuttle_name != initial(shuttle_name))
		. = ..(mapload, src.shuttle_name) // Used the loaded shuttle_name for tagging and shuttle restriction.
	else
		. = ..()

/obj/effect/shuttle_landmark/visiting_shuttle
	should_save = FALSE // Visiting shuttle landmarks will be replaced with a revised landing system.

/obj/effect/overmap/visitable/ship/landable/created
	should_save = FALSE  // Created landable ships are set to save manually by their stellar anchors to ensure that they do not persist when the anchor is destroyed or deactivated.

/obj/effect/overmap/visitable/ship/landable/created/Initialize(var/mapload, var/custom_name, var/ship_color)
	if(custom_name)
		shuttle = custom_name
		name = custom_name
	if(ship_color) color = ship_color

	. = ..(mapload)
