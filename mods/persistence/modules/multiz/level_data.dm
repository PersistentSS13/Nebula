/obj/abstract/level_data/setup_level_data()
	if(level_flags & ZLEVEL_SAVED)
		SSmapping.saved_levels  |= my_z
	if(level_flags & ZLEVEL_MINING)
		SSmapping.mining_levels  |= my_z
	. = ..()