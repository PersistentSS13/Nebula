/datum/controller/subsystem/mapping


/datum/controller/subsystem/mapping/Initialize(timeofday)
	. = ..()

	// Load our maps dynamically.
	for(var/z in global.using_map.default_levels)
		var/map_file = global.using_map.default_levels[z]
		if(SSpersistence.SaveExists() && (text2num(z) in SSpersistence.saved_levels))
			// Load a default map instead.
			INCREMENT_WORLD_Z_SIZE
			continue
		maploader.load_map(file(map_file), 1, 1, text2num(z), no_changeturf = TRUE)
		CHECK_TICK

	// Build the list of static persisted levels from our map.
#ifdef UNIT_TEST
	report_progress("Unit testing, so not loading saved map")
#else
	report_progress("Loading world save.")
	
	SSpersistence.LoadWorld()
#endif

/datum/controller/subsystem/mapping/proc/Save()
	SSpersistence.SaveWorld()

/datum/map
	var/list/default_levels
	var/overmap_seed = "overmapseed"