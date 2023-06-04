/datum/controller/subsystem/mapping
	/// List of z-levels that regenerates mining turfs periodically
	var/list/mining_levels =  list()

/datum/controller/subsystem/mapping/Initialize(timeofday)
	. = ..()
#ifndef UNIT_TEST
	if(SSpersistence.SaveExists())
		report_progress_serializer("Existing save found. Loading save...")
		SSpersistence.LoadWorld()
		report_progress_serializer("Finished loading save!")
	else
		report_progress_serializer("No existing save found. Loading from map files..")
#else
	report_progress_serializer("Unit testing, so not loading saved data.")
#endif
	/**
		// Populate overmap.
	if(length(global.using_map.overmap_ids))
		for(var/overmap_id in global.using_map.overmap_ids)
			var/overmap_type = global.using_map.overmap_ids[overmap_id] || /datum/overmap
			new overmap_type(overmap_id)
	// This needs to be non-null even if the overmap isn't created for this map.
	overmap_event_handler = GET_DECL(/decl/overmap_event_handler)
	**/
/datum/controller/subsystem/mapping/proc/Save()
	SSpersistence.SaveWorld()
