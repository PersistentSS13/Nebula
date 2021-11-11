// Most of these variables won't exist until loading is complete i.e. after New() is called, so we do most of the New() code in after_deserialize()
/datum/shuttle/autodock/New(map_hash, obj/effect/shuttle_landmark/start_waypoint)
	if(SSpersistence.loading_world)
		return
	. = ..()

/datum/shuttle/autodock/after_deserialize()
	. = ..()
	//Initial dock
	active_docking_controller = current_location.docking_controller
	update_docking_target(current_location)
	if(active_docking_controller)
		set_docking_codes(active_docking_controller.docking_codes)
	else
		var/obj/effect/overmap/visitable/location = global.overmap_sectors["[current_location.z]"]
		if(location && location.docking_codes)
			set_docking_codes(location.docking_codes)
	dock()

	//Optional transition area
	if(landmark_transition)
		landmark_transition = SSshuttle.get_landmark(landmark_transition)