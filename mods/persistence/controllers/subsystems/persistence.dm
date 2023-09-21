/*
	#TODO: Save system overhaul:
	* Have sspersistence disable all but the critical subsystems.
	* Have saving sleeps/stoplag() every few turfs, so connection to clients doesn't cut.
	* Cut up the save and load procs since they're massive and clunky.
	* Unify the sql serializer stuff, so it's less redundant. (We don't need 2 different serializer objects.)
	* Don't iterate the world 3 times over for no reasons.
	* Don't access area's contents, behind the scene it just accesses world contents and is massively slow.
	* Don't concatenate strings more than once!! Use a list if you must, but just adding to a string is a hundred time slower
	  than just putting strings in a list and running jointext() on them.
*/

///Init priority for the persistence subsystem
#define SS_INIT_PERSISTENCE 18.5

///Comparison function for sorting the list of atoms that took the longest to save.
/proc/cmp_serialization_stats_dsc(var/datum/serialization_stat/S1, var/datum/serialization_stat/S2)
	return S2.time_spent - S1.time_spent

/**
 * Override of the persistence subsystem.
 */
/datum/controller/subsystem/persistence
	name       = "Persistence"
	init_order = SS_INIT_PERSISTENCE
	flags      = SS_NO_FIRE

	// *** Config ***
	///Whether or not rent will be required for created sectors.
	var/rent_enabled = FALSE
	///If set, we'll do everything we can to generate a valid save even if some things do runtime.
	var/error_tolerance = PERSISTENCE_ERROR_TOLERANCE_NONE

	// *** State ***

	///Whether or not a save exists in the DB. Value is cached when a save did exist at runtime for performance reasons.
	var/save_exists     = FALSE
	///Whether or not we're currently running a loaded save.
	var/in_loaded_world = FALSE
	///Whether we're currently loading a world save.
	var/loading_world = FALSE
	///The time when the currently loaded world save was made if any. NULL means we never loaded a save.
	var/loaded_save_time
	///Save log entry index from the database for the currently running save. Used to fill in the saving result into the db.
	var/save_log_id
	///Holds the previous entering allowed state while we're running a save.
	var/was_entering_allowed

	///Text to log into the database log for the completion/failure of the save
	var/save_complete_text = ""
	///Span class to use for displaying the completion/failure message into chat.
	var/save_complete_span_class = "danger"
	///Amount of z-levels saved
	var/nb_saved_z_levels = 0
	///Amount of atoms saved
	var/nb_saved_atoms    = 0

	//#FIXME: Not sure if keeping a separate list of those here is a very good idea?
	var/list/saved_areas      = list()
	/// Saved levels are saved entirely and optimized with get_base_turf()
	var/list/saved_levels     = list()
	/// Extensions mark themselves to be saved on world save.
	var/list/saved_extensions = list()

	//#FIXME: The idea for having a generic serializer class was that we wouldn't initiate the exact subtype in the var definition.
	//        So that you could just interchangeably use another kind of serializer that saves to json or xml or whatever instead of sql seamlessly.
	//        This implementation completely nullifies the whole point of having a serializer class currently?
	/// The serializer impl for actually saving.
	var/serializer/sql/serializer       = new()
	/// The serializer impl for one off serialization/deserialization.
	var/serializer/sql/one_off/one_off	= new()

	//#FIXME: Ideally, this shouldn't be handled by the server. The database could cross-reference atoms that were in limbo with those already in the world,
	//        and just clear their limbo entry. It would thousands of time faster.
	/// Objects which will be removed from limbo on the next save. Format is list(limbo_key, limbo_type)
	var/list/limbo_removals = list()
	/// Objects which are deserialized out of limbo don't have their refs in the database immediately, so we add them here until the next save. Format is p_id -> ref
	var/list/limbo_refs     = list()

	/// Some wrapped objects need special behavior post-load. This list is cleared post-atom Init.
	var/list/late_wrappers = list()

/datum/controller/subsystem/persistence/proc/SaveExists()
	if(!save_exists)
		save_exists = establish_save_db_connection() && serializer.save_exists()
		in_loaded_world = save_exists
	return save_exists

///Timestamp of when the currently loaded save was made.
/datum/controller/subsystem/persistence/proc/LoadedSaveTimestamp()
	if(!in_loaded_world)
		return
	if(!length(loaded_save_time))
		loaded_save_time = serializer.last_loaded_save_time()
	return loaded_save_time

///Keeps the previous state of 'enter_allowed' and set it to false. Returns TRUE if entering was currently allowed.
/datum/controller/subsystem/persistence/proc/_block_entering()
	was_entering_allowed = config.enter_allowed
	config.enter_allowed = FALSE
	return was_entering_allowed

///Restore the previous state of 'enter_allowed'. Returns the restored value of 'enter_allowed'.
/datum/controller/subsystem/persistence/proc/_restore_entering()
	. = (config.enter_allowed = was_entering_allowed)
	was_entering_allowed = FALSE

///Handle pausing all subsystems before save
/datum/controller/subsystem/persistence/proc/_pause_subsystems()
	//Turn off all the subsystems we don't need messing things up during saving.
	for(var/datum/controller/subsystem/S in Master.subsystems)
		S.disable()

	//Wait on SSair to complete it's tick.
	if (SSair.state != SS_IDLE)
		report_progress_serializer("ZAS Rebuild initiated. Waiting for current air tick to complete before continuing.")
	while (SSair.state != SS_IDLE)
		stoplag()

///Handles resuming all subsystems post-save
/datum/controller/subsystem/persistence/proc/_resume_subsystems()
	// Reboot air subsystem before mass enabling all of them.
	SSair.reboot()
	//Resune subsystems
	for(var/datum/controller/subsystem/S in Master.subsystems)
		S.enable()

///Call in a catch block for critical/typically unrecoverable errors during save. Filters out the kind of exceptions we let through or not.
/datum/controller/subsystem/persistence/proc/_handle_critical_exception(var/exception/E, var/code_location)
	if(error_tolerance < PERSISTENCE_ERROR_TOLERANCE_ANY)
		// Clear the custom saved list used to keep list refs intact
		global.custom_saved_lists.Cut()
		_resume_subsystems()
		_restore_entering()
		throw E
	else
		log_warning(EXCEPTION_TEXT(E))
		log_warning("Error tolerance set to 'any', proceeding with save despite critical error in '[code_location]'!")

///Call in a catch block for recoverable or non-critical errors during save. Filters out the kind of exceptions we let through or not.
/datum/controller/subsystem/persistence/proc/_handle_recoverable_exception(var/exception/E, var/code_location)
	if(error_tolerance < PERSISTENCE_ERROR_TOLERANCE_RECOVERABLE)
		// Clear the custom saved list used to keep list refs intact
		global.custom_saved_lists.Cut()
		_resume_subsystems()
		_restore_entering()
		throw E
	else
		log_warning(EXCEPTION_TEXT(E))
		log_warning("Error tolerance set to 'critical-only', proceeding with save despite error in '[code_location]'!")

///Causes a world save to be started.
/datum/controller/subsystem/persistence/proc/SaveWorld(var/save_initiator)
	//Make sure we log who started the save.
	if(!save_initiator && ismob(usr))
		save_initiator = usr.ckey

	var/start = REALTIMEOFDAY

	//Prevent entering
	_block_entering()

	//Saving start event
	RAISE_EVENT(/decl/observ/world_saving_start_event, src)

	// Do preparation first
	_before_save(save_initiator)

	try
		//Prepare z levels structure for saving
		var/list/z_transform = _prepare_zlevels_indexing()

		//Save all individual turfs marked for saving
		_save_turfs(z_transform)

		//Save area related stuff
		_save_areas(z_transform)

		// Now save all the extensions which have marked themselves to be saved.
		// As with areas, we create a dummy wrapper holder to hold these during load etc.
		_save_extensions()

		// Save escrow accounts which are normally held on the SSmoney_accounts subsystem
		_save_bank_accounts()

	catch(var/exception/e)
		//If exceptions end up in here, then we must interrupt saving completely.
		//Exceptions should be filtered in the sub-procs depending on severity and the error tolerance threshold set.
		save_complete_span_class = "danger"
		save_complete_text       = "SAVE FAILED: [EXCEPTION_TEXT(e)]"
		. = FALSE

	//Set our success text if we didn't hit any exceptions
	if(!length(save_complete_text))
		save_complete_span_class = "autosave"
		save_complete_text       = "Save complete! Took [REALTIMEOFDAY2SEC(start)]s to save world."
		. = TRUE

	//Handle post-save cleanup and such
	_after_save()

	// Launch event for anything that needs to do cleanup post save.
	RAISE_EVENT_REPEAT(/decl/observ/world_saving_finish_event, src)

	// Reallow people in
	_restore_entering()

/datum/controller/subsystem/persistence/proc/LoadWorld()
	serializer._before_deserialize()
	try
		// Loads all data in as part of a version.
		to_world_log("Loading [serializer.count_saved_datums()] things from world save.")

		// We start by loading the cache. This will load everything from SQL into an object structure
		// and is much faster than live-querying for information.
		serializer.resolver.load_cache()

		// Begin deserializing the world.
		var/start = world.timeofday
		loading_world = TRUE

		// Start with rebuilding the z-levels.

		var/list/unmapped_z     = list()
		var/list/mapped_z       = list()
		var/list/mapped_indices = list() //Indices reserved by mapped zlevels

		var/min_mapped_index
		var/mapped_offset = 0
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

				// map_indices is indexed by the database value, so we need to re-adjust.
				var/index_key = num2text(world.maxz - mapped_offset)
				if(index_key in mapped_indices)
					SSmapping.increment_world_z_size(text2path(mapped_indices[index_key]) || /datum/level_data/space, TRUE)
				else
					SSmapping.increment_world_z_size(/datum/level_data/space, TRUE)
					//If we have any unmapped z levels to place, use the empty space between
					if(length(unmapped_z))
						var/datum/persistence/load_cache/z_level/unmapped = unmapped_z[unmapped_z.len]
						unmapped_z.len--
						unmapped.new_index = world.maxz
						serializer.z_map["[unmapped.index]"] = unmapped.new_index
						report_progress_serializer("Mapping Save Z ([unmapped.index]) to World Z ([unmapped.new_index]) with default turf ([unmapped.default_turf]).")

			report_progress_serializer("Mapping Save Z ([z_level.index]) to World Z ([z_level.new_index]) with default turf ([z_level.default_turf]) and level data [z_level.level_data_subtype].")
			serializer.z_map[num2text(z_level.index)] = z_level.new_index

		//If any unmapped left, add them
		for(var/datum/persistence/load_cache/z_level/z_level in unmapped_z)
			SSmapping.increment_world_z_size(/datum/level_data/space)
			z_level.new_index = world.maxz
			serializer.z_map[num2text(z_level.index)] = z_level.new_index
			report_progress_serializer("Mapping Save Z ([z_level.index]) to World Z ([z_level.new_index]) with default turf ([z_level.default_turf]).")
		report_progress_serializer("Z-Levels loaded!")

		// This is a sort-of hack. We're going to go back and edit all of the thing_references to their new Z from the z_levels we just modified.
		for(var/thing_id in serializer.resolver.things)
			var/datum/persistence/load_cache/thing/thing = serializer.resolver.things[thing_id]
			thing.z = serializer.z_map["[thing.z]"]
		report_progress_serializer("Dynamic z-levels populated!")

		// Now we're going to load the actual data from the save.
		var/list/turfs_loaded = list()
		to_world_log("Things: [LAZYLEN(serializer.resolver.things)]")
		for(var/TKEY in serializer.resolver.things)
			try
				var/datum/persistence/load_cache/thing/T = serializer.resolver.things[TKEY]
				if(ispath(T.thing_type, /datum/wrapper_holder)) // Special handling for wrapper holders since they don't have another reference.
					serializer.DeserializeDatum(T)
					continue
				if(!T.x || !T.y || !T.z)
					continue // This isn't a turf or a wrapper holder. We can skip it.
				serializer.DeserializeDatum(T)
				turfs_loaded["([T.x], [T.y], [T.z])"] = TRUE
			catch(var/exception/E)
				to_world_log("Failed to load! [E.name], [E.file] [E.line], [E.desc]")
			CHECK_TICK
		to_world_log("Load complete! Took [(world.timeofday-start)/10]s to load [length(serializer.resolver.things)] things. Loaded [LAZYLEN(turfs_loaded)] turfs.")
		in_loaded_world = LAZYLEN(turfs_loaded) > 0

		report_progress_serializer("Adding default turfs and areas...")
		start = world.timeofday

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
			if(z_level.areas.len)
				current_area_chunk = z_level.areas[chunk_index]
				current_area = global.area_dictionary["[current_area_chunk[1]], [current_area_chunk[2]]"]

			for(var/turf/T in block(locate(1, 1, z_level.new_index), locate(world.maxx, world.maxy, z_level.new_index)))
				if(current_area)
					current_area.contents += T
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
		report_progress_serializer("Default turfs and areas complete! Took [(world.timeofday-start)/10]s.")

		report_progress_serializer("Adding other areas...")
		start = world.timeofday
		for(var/datum/persistence/load_cache/area_chunk/area_chunk in serializer.resolver.area_chunks)
			var/area/new_area = global.area_dictionary["[area_chunk.area_type], [area_chunk.name]"]
			if(!new_area)
				new area_chunk.area_type(null, area_chunk.name)

			for(var/turf_chunk in area_chunk.turfs)
				var/list/coords = splittext(turf_chunk, ",")
				// Adjust to new index.
				coords[3] = serializer.z_map[coords[3]]
				var/turf/T = locate(text2num(coords[1]), text2num(coords[2]), coords[3])
				new_area.contents += T

		report_progress_serializer("Adding other areas complete! Took [(world.timeofday-start)/10]s.")

		// Cleanup the cache. It uses a *lot* of memory.
		for(var/id in serializer.reverse_map)
			var/datum/T = serializer.reverse_map[id]
			T.after_deserialize()
		for(var/id in serializer.reverse_list_map)
			var/list/_list = serializer.reverse_list_map[id]
			//#FIXME: If the elements in the list are numbers, this will be even slower than it is right now.
			//        Since it'll runtime if a number is out of range of the list.
			for(var/element in _list)
				var/datum/T = element
				if(istype(T, /datum))
					T.after_deserialize()
				var/datum/TE
				try
					TE = _list[element] //#FIXME: We really need to get rid of this awful way to check list types.
				catch
					continue
				try
					if(istype(TE, /datum))
						TE.after_deserialize()
				catch(var/exception/E)
					to_world_log("TE after_deserialize! [E.name], [E.file] [E.line], [E.desc]")

		serializer.resolver.clear_cache()
		serializer.CommitRefUpdates() // Clean up any leftovers.
		serializer.Clear()

		// Clean up limbo by removing any characters present in the gameworld. This may occur if the server does not save after
		// a player enters limbo.

		// TODO: Generalize this for other things in limbo.
		for(var/datum/mind/char_mind in global.player_minds)
			one_off.RemoveFromLimbo(char_mind.unique_id, LIMBO_MIND)

		// Tell the atoms subsystem to not populate parts.
		//if(turfs_loaded)
			//SSatoms.adjust_init_arguments = TRUE
	catch(var/exception/e)
		to_world_log("Load failed on line [e.line], file [e.file] with message: '[e]'.")

	serializer._after_deserialize()
	loading_world = FALSE

/datum/controller/subsystem/persistence/proc/AddSavedLevel(var/z)
	saved_levels |= z

/datum/controller/subsystem/persistence/proc/RemoveSavedLevel(var/z)
	saved_levels -= z

/datum/controller/subsystem/persistence/proc/AddSavedArea(var/area/A)
	saved_areas |= A

/datum/controller/subsystem/persistence/proc/RemoveSavedArea(var/area/A)
	saved_areas -= A

/hook/roundstart/proc/retally_all_power()
	for(var/area/A)
		A.retally_power()
	return TRUE
///Sets the level of error tolerance to use during saves. Default is PERSISTENCE_ERROR_TOLERANCE_NONE.
/datum/controller/subsystem/persistence/proc/SetSaveErrorTolerance(var/tolerance_level = PERSISTENCE_ERROR_TOLERANCE_NONE)
	if(tolerance_level < PERSISTENCE_ERROR_TOLERANCE_NONE || tolerance_level > PERSISTENCE_ERROR_TOLERANCE_ANY)
		CRASH("Invalid error tolerance value.")
	return (error_tolerance = tolerance_level)


//
// Base Persistence Subsystem Overrides
//
/datum/controller/subsystem/persistence/Shutdown()
	return

/datum/controller/subsystem/persistence/track_value()
	return

/datum/controller/subsystem/persistence/is_tracking()
	return

/datum/controller/subsystem/persistence/forget_value()
	return

/datum/controller/subsystem/persistence/show_info(mob/user)
	to_chat(user, SPAN_INFO("Disabled with persistence modpack (how ironic)..."))
	return
/datum/controller/subsystem/persistence/proc/print_db_status()
	return SQLS_Print_DB_STATUS()
