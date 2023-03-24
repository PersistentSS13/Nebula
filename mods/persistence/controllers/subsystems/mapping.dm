/datum/controller/subsystem/mapping
	/// List of z-levels that are marked to be saved
	var/list/saved_levels =  list()
	/// List of z-levels that regenerates mining turfs periodically
	var/list/mining_levels =  list()

	var/tmp/loaded_maps = FALSE

/datum/controller/subsystem/mapping/Initialize(timeofday)
	. = ..()
#ifndef UNIT_TEST
	var/save_exists = SSpersistence.SaveExists()
	if(save_exists)
		report_progress_serializer("Existing save found.")
	else
		report_progress_serializer("No existing save found.")
#endif
	// Load our maps dynamically.
	for(var/z in global.using_map.default_levels)
		var/map_file = global.using_map.default_levels[z]
#ifndef UNIT_TEST
		if(save_exists && (text2num(z) in SSpersistence.saved_levels)) //#FIXME: DANGER This should use level_ids not level z!!!!!
			// Load a default map instead.
			SSmapping.increment_world_z_size(/obj/abstract/level_data/space)
			continue
#endif
		maploader.load_map(file(map_file), 1, 1, text2num(z), no_changeturf = TRUE)
		CHECK_TICK

	// Persistence overmaps use premapped overmaps at the moment, so we override here to delay building the overmaps until appropriate.
	loaded_maps = TRUE
	// Build the list of static persisted levels from our map.
#ifdef UNIT_TEST
	report_progress_serializer("Unit testing, so not loading saved map")
#else
	if(save_exists)
		report_progress_serializer("Loading world save.")
		SSpersistence.LoadWorld()
#endif

/datum/controller/subsystem/mapping/proc/Save()
	SSpersistence.SaveWorld()

/datum/map
	var/list/default_levels