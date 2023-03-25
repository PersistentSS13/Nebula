/obj/abstract/level_data
	should_save = TRUE

/obj/abstract/level_data/setup_level_data()
	if(level_flags & ZLEVEL_SAVED)
		SSpersistence.saved_levels |= my_z
	if(level_flags & ZLEVEL_NONDYNAMIC)
		SSpersistence.nondynamic_levels |= my_z
	if(level_flags & ZLEVEL_MINING)
		SSmapping.mining_levels  |= my_z
	. = ..()