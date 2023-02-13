/datum/map
	var/list/default_levels

/datum/controller/subsystem/mapping
	var/loaded_maps = FALSE

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
		if(save_exists && (text2num(z) in SSpersistence.saved_levels))
			// Load a default map instead.
			increment_world_z_size_nolvldata()
			continue
#endif
		maploader.load_map(file(map_file), 1, 1, text2num(z), no_changeturf = TRUE)
		CHECK_TICK

	// Persistence overmaps use premapped overmaps at the moment, so we override here to delay building the overmaps until appropriate.
	loaded_maps = TRUE
	if(length(global.overmaps_by_name))
		for(var/name in global.overmaps_by_name)
			var/datum/overmap/O = global.overmaps_by_name[name]
			O.late_initialize()
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

//Rewrite the z-level stuff since the orig proc spawns duplicate level_data
/datum/controller/subsystem/mapping/proc/increment_world_z_size_nolvldata(var/defer_setup = FALSE)
	world.maxz++
	reindex_lists()
	if(SSzcopy.zlev_maximums.len)
		SSzcopy.calculate_zstack_limits()