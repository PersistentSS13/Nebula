/datum/shuttle/autodock/overmap/New(var/_name, var/obj/effect/shuttle_landmark/start_waypoint, var/list/initial_areas)
	if(LAZYLEN(initial_areas)) // Shuttle is being created during runtime.
		shuttle_area = list()  // Stops assignment of shuttle_area to list(null)
		. = ..(_name, start_waypoint)
		shuttle_area = initial_areas
		SSshuttle.shuttle_areas += shuttle_area
		return
	. = ..(_name, start_waypoint)