/datum/level_data/setup_level_data()
	if(level_flags & ZLEVEL_SAVED)
		SSpersistence.saved_levels  |= level_z
	if(level_flags & ZLEVEL_MINING)
		SSmapping.mining_levels  |= level_z
	. = ..()