/datum/controller/subsystem/mapping
	/// List of z-levels that are marked to be saved
	var/list/saved_levels =  list()
	/// List of z-levels that regenerates mining turfs periodically
	var/list/mining_levels =  list()

/datum/controller/subsystem/mapping/Initialize(timeofday)
	. = ..()
#ifndef UNIT_TEST
	var/save_exists = SSpersistence.SaveExists()
	if(save_exists)
		report_progress_serializer("Existing save found.")
	else
		report_progress_serializer("No existing save found.")
#endif

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
