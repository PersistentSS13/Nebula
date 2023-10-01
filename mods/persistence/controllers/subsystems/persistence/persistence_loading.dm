//Text helper to avoid copy-pasta
#define __PRINT_STRING_LIST_DETAIL(ID, L) "'[id]'[islist(_list)? ", ref:\ref[_list],length:[length(_list)]" : ""]"
#define __PRINT_KEY_DETAIL(KEY)           "'[KEY]'(ref:\ref[KEY])([KEY.type])"
#define __PRINT_VALUE_DETAIL(VAL)         "'[VAL]'(ref:\ref[VAL])([VAL.type])"

///Call in a catch block for critical/typically unrecoverable errors during load. Filters out the kind of exceptions we let through or not.
/datum/controller/subsystem/persistence/proc/_handle_critical_load_exception(var/exception/E, var/code_location)
	if(error_tolerance < PERSISTENCE_ERROR_TOLERANCE_ANY)
		throw E
	else
		log_warning(EXCEPTION_TEXT(E))
		log_warning("Error tolerance set to 'any', proceeding with load despite critical error in '[code_location]'!")

///Call in a catch block for recoverable or non-critical errors during load. Filters out the kind of exceptions we let through or not.
/datum/controller/subsystem/persistence/proc/_handle_recoverable_load_exception(var/exception/E, var/code_location)
	if(error_tolerance < PERSISTENCE_ERROR_TOLERANCE_RECOVERABLE)
		throw E
	else
		log_warning(EXCEPTION_TEXT(E))
		log_warning("Error tolerance set to 'critical-only', proceeding with load despite error in '[code_location]'!")

// Get an object from its p_id via ref tracking. This will not always work if an object is asynchronously deserialized from others.
// This is also quite slow - if you're trying to locate many objects at once, it's best to use a single query for multiple objects.
/datum/controller/subsystem/persistence/proc/get_object_from_p_id(var/target_p_id)
//#TODO: This could be sped up by changing the db structure to use indexes and using stored procedures.

	// Check to see if the object has been deserialized from limbo and not yet added to the normal tables.
	if(target_p_id in limbo_refs)
		var/datum/existing = locate(limbo_refs[target_p_id])
		if(existing && !QDELETED(existing) && existing.persistent_id == target_p_id)
			return existing
		limbo_refs -= target_p_id

	// If it was in limbo_refs we shouldn't find it in the normal tables, but we'll check anyway.
	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection during Object Lookup!")
		new_db_connection = TRUE
	var/DBQuery/world_query = dbcon_save.NewQuery("SELECT `p_id`, `ref` FROM `[SQLS_TABLE_DATUM]` WHERE `p_id` = \"[target_p_id]\";")
	SQLS_EXECUTE_AND_REPORT_ERROR(world_query, "OBTAINING OBJECT FROM P_ID FAILED:")

	while(world_query.NextRow())
		var/list/items = world_query.GetRowData()
		var/datum/existing = locate(items["ref"])
		if(existing && !QDELETED(existing) && existing.persistent_id == items["p_id"])
			. = existing
		break

	if(new_db_connection)
		close_save_db_connection()

/datum/controller/subsystem/persistence/proc/clear_late_wrapper_queue()
	if(!length(late_wrappers))
		return
	//#TODO: Move db handling to serializer stuff.
	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection while clearing wrapper queue!")
		new_db_connection = TRUE
	for(var/datum/wrapper/late/L as anything in late_wrappers)
		L.on_late_load()

	late_wrappers.Cut()
	if(new_db_connection)
		close_save_db_connection() //#TODO: Move db handling to serializer stuff.

///Handles setting up db connections and etc..
/datum/controller/subsystem/persistence/proc/_before_load()
	try
		//Establish connection mainly
		serializer._before_deserialize()

		// Loads all data in as part of a version.
		report_progress_serializer("Loading last save, `[serializer.last_loaded_save_time()]`, with [serializer.count_saved_datums()] atoms to load.")
	catch(var/exception/e)
		_handle_critical_load_exception(e, "establishing db connection before load")

///Assign the right z-level index to the right level.
/datum/controller/subsystem/persistence/proc/_restore_zlevel_structure()
	// Start with rebuilding the z-levels.
	var/list/unmapped_z     = list()
	var/list/mapped_z       = list()
	var/list/mapped_indices = list() //Indices reserved by mapped zlevels
	var/mapped_offset       = 0
	var/time_start          = REALTIMEOFDAY
	var/min_mapped_index

	//#TODO: The dynamic thing is a bit cruddy. We could avoid a lot of that by just handling turfs separately. And associating them to static level id, z stack ids and areas ids.
	///Sort z-levels on whether they got a mapped z indice, or not
	for(var/datum/persistence/load_cache/z_level/z_level in serializer.resolver.z_levels)
		if(z_level.dynamic)
			unmapped_z |= z_level
		else
			mapped_z |= z_level
			mapped_indices[num2text(z_level.index)] = z_level.level_data_subtype

			if(!min_mapped_index || z_level.index < min_mapped_index)
				min_mapped_index = z_level.index

	// If mapping changes have resulted in more levels existing then during save, offset the mapped levels.
	mapped_offset = max(0, world.maxz + 1 - min_mapped_index)

	//Then handle assigning z levels
	for(var/datum/persistence/load_cache/z_level/z_level in mapped_z)
		//If the world z isn't at the index we're loading this level at, increment
		z_level.new_index = z_level.index + mapped_offset
		for(var/z_incr = 1 to max(z_level.new_index - world.maxz, 0))

			// mapped_indices is indexed by the database value, so we need to re-adjust.
			var/index_key = num2text(z_level.index)
			if(index_key in mapped_indices)
				var/lvldat_path = mapped_indices[index_key]
				if(length(mapped_indices[index_key]) && !ispath(lvldat_path))
					CRASH("Loaded level_data path '[mapped_indices[index_key]]' resolved to null type!")
				SSmapping.increment_world_z_size(lvldat_path, TRUE)
			else
				SSmapping.increment_world_z_size(/datum/level_data/space, TRUE)
				//If we have any unmapped z levels to place, use the empty space between
				if(length(unmapped_z))
					var/datum/persistence/load_cache/z_level/unmapped = unmapped_z[unmapped_z.len]
					unmapped_z.len--
					unmapped.new_index = world.maxz
					serializer.z_map["[unmapped.index]"] = unmapped.new_index
					report_progress_serializer("Mapping Save Z ([unmapped.index]) to World Z ([unmapped.new_index]) with default turf ([unmapped.default_turf]).")

		report_progress_serializer("Mapping original Z ([z_level.index]) to new Z ([z_level.new_index]) with default turf ([z_level.default_turf]) and level data [z_level.level_data_subtype].")
		serializer.z_map[num2text(z_level.index)] = z_level.new_index

	//If any unmapped left, add them
	for(var/datum/persistence/load_cache/z_level/z_level in unmapped_z)
		SSmapping.increment_world_z_size(/datum/level_data/space)
		z_level.new_index = world.maxz
		serializer.z_map[num2text(z_level.index)] = z_level.new_index
		report_progress_serializer("Mapping original Z ([z_level.index]) to new Z ([z_level.new_index]) with default turf ([z_level.default_turf]).")
	report_progress_serializer("Z-Levels loaded!")

	// This is a sort-of hack. We're going to go back and edit all of the thing_references to their new Z from the z_levels we just modified.
	for(var/thing_id in serializer.resolver.things)
		var/datum/persistence/load_cache/thing/thing = serializer.resolver.things[thing_id]
		thing.z = serializer.z_map["[thing.z]"]
	report_progress_serializer("Dynamic z-levels populated!")

	report_progress_serializer("Restored z-level structure in [REALTIMEOFDAY2SEC(time_start)]s.")
	sleep(5)

///Runs after deserialize on all the loaded atoms.
/datum/controller/subsystem/persistence/proc/_run_after_deserialize()
	//Run after_deserialize on all atoms in the map.
	for(var/id in serializer.reverse_map)
		var/datum/T
		try
			T = serializer.reverse_map[id]
			T.after_deserialize()
		catch(var/exception/e)
			_handle_recoverable_load_exception(e, "while running after_deserialize() on PID: '[id]'[!isnull(T)? ", '[T]'(\ref[T])([T.type])" : ""]")

	//Since datums used as list value and list key are stored in another list, run after_deserialize() on them too
	for(var/id in serializer.reverse_list_map)
		var/list/_list
		try
			_list = serializer.reverse_list_map[id]
			//#FIXME: If the keys in the list are numbers, this will be even slower than it is right now.
			//        Since it'll runtime if a number is out of range of the list.
			for(var/key in _list)
				var/datum/K = key
				if(istype(K, /datum))
					try
						K.after_deserialize()
					catch(var/exception/e_list_key)
						_handle_recoverable_load_exception(e_list_key, "while running after_deserialize() on key [__PRINT_KEY_DETAIL(K)], of list: [__PRINT_STRING_LIST_DETAIL(id, _list)]")

				var/datum/V
				try
					V = _list[key] //#FIXME: We really need to get rid of this awful way to check list types.
				catch
					continue
				if(istype(V, /datum))
					try
						V.after_deserialize()
					catch(var/exception/e_list_value)
						_handle_recoverable_load_exception(e_list_value, "while running after_deserialize() on value [__PRINT_VALUE_DETAIL(V)], for key [__PRINT_KEY_DETAIL(K)], of list: [__PRINT_STRING_LIST_DETAIL(id, _list)]")
		catch(var/exception/e_list)
			//Catch any sort of bad index error
			_handle_recoverable_load_exception(e_list, "while running after_deserialize() on elements of list: [__PRINT_STRING_LIST_DETAIL(id, _list)]")

///Clean up limbo by removing any characters present in the gameworld. This may occur if the server does not save after
///a player enters limbo.
/datum/controller/subsystem/persistence/proc/_update_limbo_state()
	// TODO: Generalize this for other things in limbo.
	for(var/datum/mind/char_mind in global.player_minds)
		try
			one_off.RemoveFromLimbo(char_mind.unique_id, LIMBO_MIND)
		catch(var/exception/e)
			_handle_recoverable_load_exception(e, "while updating off-world storage state for player '[char_mind.key]'")

///Deserialize cached top level wrapper datum/turf exclusively from the db cache.
/datum/controller/subsystem/persistence/proc/_deserialize_turfs()
	var/list/turfs_loaded = list()
	var/time_start        = REALTIMEOFDAY

	report_progress_serializer("Deserializing [LAZYLEN(serializer.resolver.things)] cached atoms...")
	sleep(5)

	for(var/TKEY in serializer.resolver.things)
		var/datum/persistence/load_cache/thing/T
		try
			T = serializer.resolver.things[TKEY]
			if(ispath(T.thing_type, /datum/wrapper_holder)) // Special handling for wrapper holders since they don't have another reference.
				serializer.DeserializeDatum(T)
				continue
			if(!T.x || !T.y || !T.z)
				continue // This isn't a turf or a wrapper holder. We can skip it.
			serializer.DeserializeDatum(T)
			turfs_loaded["([T.x], [T.y], [T.z])"] = TRUE
		catch(var/exception/E)
			to_world_log("Failed to load turf '[T]'!: [EXCEPTION_TEXT(E)]")
		CHECK_TICK

	in_loaded_world = LAZYLEN(turfs_loaded) > 0
	. = turfs_loaded
	report_progress_serializer("Deserialized [LAZYLEN(turfs_loaded)] turfs and their contents in [REALTIMEOFDAY2SEC(time_start)]s.")
	sleep(5)

/// TODO
/datum/controller/subsystem/persistence/proc/_setup_default_turfs(var/list/turfs_loaded)
	var/time_start = REALTIMEOFDAY
	for(var/datum/persistence/load_cache/z_level/z_level in serializer.resolver.z_levels)
		var/change_turf = z_level.default_turf && !ispath(z_level.default_turf, /turf/space)

		// Create the areas in the z-level if they don't already exist.
		// Areas are added to the area dictionary in area/New()
		for(var/list/area_chunk in z_level.areas)
			var/area/area_instance = global.area_dictionary["[area_chunk[1]], [area_chunk[2]]"]
			if(!area_instance)
				var/new_type = text2path(area_chunk[1])
				new new_type(null, area_chunk[2])
		// The areas are split into horizontal chunks with the area type and name corresponding to a certain amount of tiles in a row.
		var/chunk_index = 1
		var/list/current_area_chunk
		var/area/current_area
		var/turf_count = 1
		if(length(z_level.areas))
			current_area_chunk = z_level.areas[chunk_index]
			current_area = global.area_dictionary["[current_area_chunk[1]], [current_area_chunk[2]]"]

		for(var/turf/T in block(locate(1, 1, z_level.new_index), locate(world.maxx, world.maxy, z_level.new_index)))
			try
				if(current_area)
					current_area.contents += T //#FIXME: It's dangerous to do it like this. Use loc on the turf, not the area's contents "list".
					turf_count++
					if(turf_count > current_area_chunk[3])
						chunk_index++
						// All the chunks are done. Most likely we're on the last tile of the z-level but just in case allow the loop
						// to continue.
						if(chunk_index > z_level.areas.len)
							current_area = null
							current_area_chunk = null
						else
							current_area_chunk = z_level.areas[chunk_index]
							current_area = global.area_dictionary["[current_area_chunk[1]], [current_area_chunk[2]]"]
							turf_count = 1
				if(change_turf && !turfs_loaded["([T.x], [T.y], [T.z])"])
					T.ChangeTurf(z_level.default_turf)
			catch(var/exception/e_changeturf)
				_handle_recoverable_load_exception(e_changeturf, "changing base turf/area")

	report_progress_serializer("Applied default turfs and areas in [REALTIMEOFDAY2SEC(time_start)]s!")
	sleep(5)

///Applies areas to both loaded and default turfs inside the regions they cover.
/datum/controller/subsystem/persistence/proc/_apply_area_chunks()
	report_progress_serializer("Applying area chunks...")
	var/time_start = REALTIMEOFDAY
	for(var/datum/persistence/load_cache/area_chunk/area_chunk in serializer.resolver.area_chunks)
		try
			var/area/new_area = global.area_dictionary["[area_chunk.area_type], [area_chunk.name]"]
			if(!new_area)
				new area_chunk.area_type(null, area_chunk.name)

			for(var/turf_chunk in area_chunk.turfs)
				var/list/coords = splittext(turf_chunk, ",")
				// Adjust to new index.
				coords[3] = serializer.z_map[coords[3]]
				var/turf/T = locate(text2num(coords[1]), text2num(coords[2]), coords[3])
				new_area.contents += T //#FIXME: Accessing contents directly is dangerous. It's better to set loc instead.
		catch(var/exception/e)
			//Keep going if we're tolerating critical exceptions
			_handle_critical_load_exception(e, "applying area for area chunk '[area_chunk?.name]'")

	report_progress_serializer("Applied area chunks completed! Took [REALTIMEOFDAY2SEC(time_start)]s.")
	sleep(5)

#undef __PRINT_STRING_LIST_DETAIL
#undef __PRINT_KEY_DETAIL
#undef __PRINT_VALUE_DETAIL