/obj/effect/overmap/visitable/ship/landable
	// We forego the use of visitor landmarks, and use free landing instead.
	free_landing = TRUE
	restricted_area = 20

	// Keep track of the landable ship areas and landmark to rebuild the shuttle on load.
	var/list/saved_areas = list()
	var/obj/effect/shuttle_landmark/saved_landmark

// Rebuild the shuttle on load.
/obj/effect/overmap/visitable/ship/landable/Initialize()
	if(!SSshuttle.shuttles[shuttle] && persistent_id)
		if(saved_areas)
			if(!get_turf(saved_landmark)) // The landmark was not saved in place, move it.
				saved_landmark.forceMove(get_turf(src))
			var/list/shuttle_args = list(saved_landmark, saved_areas.Copy(), shuttle)
			SSshuttle.initialize_shuttle(/datum/shuttle/autodock/overmap/created, null, shuttle_args)
		else
			log_warning("Landable ship [src] could not rebuild shuttle!")
	saved_landmark = null
	saved_areas.Cut()
	. = ..()

/obj/effect/overmap/visitable/ship/landable/move_to_starting_location()
	var/datum/overmap/overmap = global.overmaps_by_name[overmap_id]
	if(start_x && start_y)
		forceMove(locate(start_x, start_y, overmap.assigned_z))
		return
	..()

/obj/effect/overmap/visitable/ship/landable/on_saving_start()
	// In case the ship is landed in a sector, save where the sector is located.
	start_x = loc.x
	start_y = loc.y
	CUSTOM_SV("old_loc", loc)

	// Find where the ship currently is. If the ship is landed, its home z-level won't be saved unless something else is saving it.
	var/datum/shuttle/ship_shuttle = SSshuttle.shuttles[shuttle]
	if(!ship_shuttle || !ship_shuttle.current_location)
		log_error("Could not move the landable ship [src] into its current location!")
		return
	var/turf/shuttle_turf // Locate a safe turf to place the landable ship where it will save.
	if(check_rent())
		if(ship_shuttle.current_location == landmark)
			use_mapped_z_levels = TRUE
			for(var/ship_z in map_z)
				SSpersistence.AddSavedLevel(ship_z)

			shuttle_turf = get_turf(ship_shuttle.current_location) // If the entire z-level is saving, the landmark of the shuttle certainly will as well.
		else
			for(var/area/A in ship_shuttle.shuttle_area)
				SSpersistence.AddSavedArea(A)
				if(!shuttle_turf)
					// This is somewhat slow, but it's a safe way to ensure the ship is saved.
					shuttle_turf = locate(/turf) in A
		saved_areas = ship_shuttle.shuttle_area.Copy()
		saved_landmark = ship_shuttle.current_location

	forceMove(shuttle_turf)

/obj/effect/overmap/visitable/ship/landable/on_saving_end()
	use_mapped_z_levels = initial(use_mapped_z_levels)
	saved_areas.Cut()
	saved_landmark = null
	var/datum/shuttle/ship_shuttle = SSshuttle.shuttles[shuttle]
	if(ship_shuttle)
		if(ship_shuttle.current_location == landmark)
			for(var/ship_z in map_z)
				SSpersistence.RemoveSavedLevel(ship_z)
		else
			for(var/area/A in ship_shuttle.shuttle_area)
				SSpersistence.RemoveSavedArea(A)
	forceMove(LOAD_CUSTOM_SV("old_loc"))
	CLEAR_SV("old_loc")

// The landable ship contains a reference to its landmark, so only save if the ship is in its z-level.
/obj/effect/shuttle_landmark/ship/should_save()
	var/datum/shuttle/S = SSshuttle.shuttles[shuttle_name]
	if(S && S.current_location && S.current_location == src)
		return TRUE
	return FALSE

/obj/effect/shuttle_landmark/ship/Initialize(mapload, shuttle_name)
	if(SSpersistence.in_loaded_world && src.shuttle_name != initial(src.shuttle_name))
		. = ..(mapload, src.shuttle_name) // Used the loaded shuttle_name for tagging and shuttle restriction.
	else
		. = ..()

SAVED_VAR(/obj/effect/overmap/visitable/ship, moving_state)
SAVED_VAR(/obj/effect/overmap/visitable/ship, vessel_size)
SAVED_VAR(/obj/effect/overmap/visitable/ship, burn_delay)
SAVED_VAR(/obj/effect/overmap/visitable/ship, fore_dir)
SAVED_VAR(/obj/effect/overmap/visitable/ship, engines)
SAVED_VAR(/obj/effect/overmap/visitable/ship, skill_needed)
SAVED_VAR(/obj/effect/overmap/visitable/ship, operator_skill)

SAVED_VAR(/obj/effect/overmap/visitable/ship/landable, shuttle)
SAVED_VAR(/obj/effect/overmap/visitable/ship/landable, landmark)
SAVED_VAR(/obj/effect/overmap/visitable/ship/landable, multiz)
SAVED_VAR(/obj/effect/overmap/visitable/ship/landable, status)
SAVED_VAR(/obj/effect/overmap/visitable/ship/landable, saved_landmark)
SAVED_VAR(/obj/effect/overmap/visitable/ship/landable, saved_areas)
SAVED_VAR(/obj/effect/overmap/visitable/ship/landable, use_mapped_z_levels)
