// Shuttles created during run-time need to have their initialization changed when loaded.
/datum/shuttle/autodock/overmap/created/New(var/_name, var/obj/effect/shuttle_landmark/initial_location, var/list/initial_areas)
	if(LAZYLEN(initial_areas)) // Shuttle is being created during runtime.
		shuttle_area = list()  // Stops assignment of shuttle_area to list(null)
		. = ..(_name, initial_location)
		shuttle_area = initial_areas
		SSshuttle.shuttle_areas += shuttle_area
		return

/datum/shuttle/autodock/overmap/created/after_deserialize()
	. = ..()
	SSshuttle.shuttle_areas += shuttle_area

	SSshuttle.shuttles[src.name] = src
	if(flags & SHUTTLE_FLAGS_PROCESS)
		SSshuttle.process_shuttles += src