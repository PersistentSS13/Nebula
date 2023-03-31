/datum/controller/subsystem/mapping
	/// List of z-levels that are marked to be saved
	var/list/saved_levels =  list()
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

/datum/controller/subsystem/mapping/proc/Save()
	SSpersistence.SaveWorld()
