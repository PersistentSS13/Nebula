/datum/controller/subsystem/mapping
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
	// Load our maps dynamically.
	for(var/map_file in global.using_map.default_levels)
		var/level_type = global.using_map.default_levels[map_file]
#ifndef UNIT_TEST
		if(save_exists && level_type)
			// Load a default map instead.
			SSmapping.increment_world_z_size(level_type)
			continue
#endif
		maploader.load_map(file(map_file), 1, 1, no_changeturf = TRUE)
		CHECK_TICK

	// Build the list of static persisted levels from our map.
#ifdef UNIT_TEST
	report_progress_serializer("Unit testing, so not loading saved map")
#else
	if(save_exists)
		report_progress_serializer("Loading world save.")
		SSpersistence.LoadWorld()
#endif
	// We repeat this here to finish setting up level_data from hotloaded maps or from the loaded world.
	for(var/z = 1 to world.maxz)
		var/obj/abstract/level_data/level = levels_by_z[z]
		if(!istype(level))
			level = new /obj/abstract/level_data/space(locate(round(world.maxx*0.5), round(world.maxy*0.5), z))
			PRINT_STACK_TRACE("Missing z-level data object for z [num2text(z)]!")
		level.setup_level_data()

/datum/controller/subsystem/mapping/proc/Save()
	SSpersistence.SaveWorld()

/datum/map
	// Currently associative list of map_files -> level data type to recreate on load.
	var/list/default_levels