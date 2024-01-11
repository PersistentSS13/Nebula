/datum/controller/subsystem/mapping/Initialize(timeofday)
	. = ..()
#ifndef UNIT_TEST
	if(SSpersistence.SaveExists())
		report_progress_serializer("Existing save found. Loading save...")
		var/old_maxz = world.maxz
		SSpersistence.LoadWorld()
		report_progress_serializer("Finished loading save!")

		for(var/z = old_maxz + 1 to world.maxz)
			var/datum/level_data/level = levels_by_z[z]
			if(!istype(level))
				level = new /datum/level_data/space(z)
				PRINT_STACK_TRACE("Missing z-level data object for loaded z[num2text(z)]!")
			level.setup_level_data(TRUE)
		report_progress_serializer("Finished setting up level data for loaded z-levels!")

		// Stopgap fix. We do this here rather than in SSair.Initialize because SSair may be rebooted.
		SSair.cull_updated_turfs()
	else
		report_progress_serializer("No existing save found. Loading from map files..")
#else
	report_progress_serializer("Unit testing, so not loading saved data.")
#endif

/datum/controller/subsystem/mapping/proc/Save()
	SSpersistence.SaveWorld()

///Work around for saved level and stuff not restoring properly after save load. Would be simpler if we'd just modify the base class.
/datum/controller/subsystem/mapping/register_level_data(var/datum/level_data/LD)
	if(!(. = ..()))
		return .
	if(LD.level_flags & ZLEVEL_SAVED)
		SSpersistence.saved_levels  |= LD.level_z
	if(LD.level_flags & ZLEVEL_MINING)
		SSmapping.mining_levels  |= LD.level_z
	return .
/datum/controller/subsystem/mapping/unregister_level_data(var/datum/level_data/LD)
	if(!(. = ..()))
		return .
	SSpersistence.saved_levels -= LD.level_z
	SSmapping.mining_levels    -= LD.level_z
	return .
