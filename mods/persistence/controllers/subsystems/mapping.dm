/datum/controller/subsystem/mapping
	var/loaded_maps = FALSE

/datum/controller/subsystem/mapping/Initialize(timeofday)
	. = ..()
#ifndef UNIT_TEST
	var/save_exists = SSpersistence.SaveExists()
	if(save_exists)
		report_progress("Existing save found.")
	else 
		report_progress("No existing save found.")
#endif
	// Load our maps dynamically.
	for(var/z in global.using_map.default_levels)
		var/map_file = global.using_map.default_levels[z]
#ifndef UNIT_TEST
		if(save_exists && (text2num(z) in SSpersistence.saved_levels))
			// Load a default map instead.
			INCREMENT_WORLD_Z_SIZE
			continue
#endif
		maploader.load_map(file(map_file), 1, 1, text2num(z), no_changeturf = TRUE)
		CHECK_TICK
	
	// Persistence overmaps use premapped overmaps at the moment, so we override here to delay building the overmaps until appropriate.
	loaded_maps = TRUE
	if(!length(global.overmaps_by_name))
		global.using_map.create_overmaps()
	// Build the list of static persisted levels from our map.
#ifdef UNIT_TEST
	report_progress("Unit testing, so not loading saved map")
#else
	if(save_exists)
		report_progress("Loading world save.")
		SSpersistence.LoadWorld()
#endif

/datum/controller/subsystem/mapping/proc/Save()
	SSpersistence.SaveWorld()

/datum/map
	var/list/default_levels