/obj/effect/overmap/visitable/ship/landable
	// Redundant with the normal shuttle var, but necessary in order to ensure there's a reference to the shuttle as long as the ship exists.
	// For consistency, the SSshuttle.shuttles[shuttle] pattern should be used for any other references to the shuttle.
	var/datum/shuttle/autodock/overmap/saved_shuttle

/obj/effect/overmap/visitable/ship/landable/Initialize(var/mapload, var/custom_name)
	if(custom_name)
		shuttle = custom_name
		name = custom_name

	saved_shuttle = SSshuttle.shuttles[shuttle]
	. = ..(mapload)

/obj/effect/overmap/visitable/ship/landable/Destroy()
	. = ..()
	saved_shuttle = null // TODO: General clean up of shuttles upon destruction of landable ships.

/obj/effect/overmap/visitable/ship/landable/on_saving_start()
	start_x = x
	start_y = y
	// Find where the ship currently is. If the ship is landed, its home z-level won't be saved unless something else is saving it.
	var/datum/shuttle/ship_shuttle = SSshuttle.shuttles[shuttle]
	if(!ship_shuttle || !ship_shuttle.current_location)
		log_error("Could not move the landable ship [src] into its current location!")
	forceMove(get_turf(ship_shuttle.current_location))

/obj/effect/overmap/visitable/ship/landable/find_z_levels()
	// The ship has had its sector saved.
	if(landmark)
		map_z = GetConnectedZlevels(landmark.z)
	else // Otherwise, the ship has likely landed elsewhere, and needs to reconstruct its space z-level.
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