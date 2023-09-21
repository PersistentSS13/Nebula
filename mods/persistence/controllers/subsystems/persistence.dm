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
///If this returns true, we should always skip saving this turf!
///Ignore non-saved areas and turfs with no contents.
#define __SHOULD_SKIP_TURF(T) ((!istype(T) || !length(T.contents)) || (istype(T.loc, /area) && (T.loc:area_flags & AREA_FLAG_IS_NOT_PERSISTENT)))

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
/datum/controller/subsystem/persistence/proc/BlockEntering()
	was_entering_allowed = config.enter_allowed
	config.enter_allowed = FALSE
	return was_entering_allowed

///Restore the previous state of 'enter_allowed'. Returns the restored value of 'enter_allowed'.
/datum/controller/subsystem/persistence/proc/RestoreEntering()
	. = (config.enter_allowed = was_entering_allowed)
	was_entering_allowed = FALSE

///Handle pausing all subsystems before save
/datum/controller/subsystem/persistence/proc/PauseSubsystems()
	//Turn off all the subsystems we don't need messing things up during saving.
	for(var/datum/controller/subsystem/S in Master.subsystems)
		S.disable()

	//Wait on SSair to complete it's tick.
	if (SSair.state != SS_IDLE)
		report_progress_serializer("ZAS Rebuild initiated. Waiting for current air tick to complete before continuing.")
	while (SSair.state != SS_IDLE)
		stoplag()

///Handles resuming all subsystems post-save
/datum/controller/subsystem/persistence/proc/ResumeSubsystems()
	// Reboot air subsystem before mass enabling all of them.
	SSair.reboot()
	//Resune subsystems
	for(var/datum/controller/subsystem/S in Master.subsystems)
		S.enable()

///Call in a catch block for critical/typically unrecoverable errors during save. Filters out the kind of exceptions we let through or not.
/datum/controller/subsystem/persistence/proc/HandleCriticalException(var/exception/E, var/code_location)
	if(error_tolerance < PERSISTENCE_ERROR_TOLERANCE_ANY)
		// Clear the custom saved list used to keep list refs intact
		global.custom_saved_lists.Cut()
		ResumeSubsystems()
		RestoreEntering()
		throw E
	else
		log_warning(EXCEPTION_TEXT(E))
		log_warning("Error tolerance set to 'any', proceeding with save despite critical error in '[code_location]'!")

///Call in a catch block for recoverable or non-critical errors during save. Filters out the kind of exceptions we let through or not.
/datum/controller/subsystem/persistence/proc/HandleRecoverableException(var/exception/E, var/code_location)
	if(error_tolerance < PERSISTENCE_ERROR_TOLERANCE_CRITICAL)
		// Clear the custom saved list used to keep list refs intact
		global.custom_saved_lists.Cut()
		ResumeSubsystems()
		RestoreEntering()
		throw E
	else
		log_warning(EXCEPTION_TEXT(E))
		log_warning("Error tolerance set to 'critical-only', proceeding with save despite error in '[code_location]'!")

/datum/controller/subsystem/persistence/proc/prepare_atmos_for_save()
	var/time_start = REALTIMEOFDAY
	SSmachines.temporarily_store_pipenets()
	report_progress_serializer("Pipenet air stored in [REALTIMEOFDAY2SEC(time_start)]s")

	time_start = REALTIMEOFDAY
	SSair.invalidate_all_zones()
	report_progress_serializer("Invalidated in [REALTIMEOFDAY2SEC(time_start)]s")

/datum/controller/subsystem/persistence/proc/prepare_limbo_for_save()
	var/time_start = REALTIMEOFDAY
	for(var/list/queued in limbo_removals)
		one_off.RemoveFromLimbo(queued[1], queued[2])
		limbo_removals -= list(queued)
	limbo_refs.Cut()
	report_progress_serializer("Removed queued limbo objects in [REALTIMEOFDAY2SEC(time_start)]s.")

	// Find all the minds gameworld and add any player characters to the limbo list.
	time_start = REALTIMEOFDAY
	for(var/datum/mind/char_mind in global.player_minds)
		var/mob/current_mob = char_mind.current
		if(!current_mob || !char_mind.key || istype(char_mind.current, /mob/new_player) || !char_mind.finished_chargen)
			// Just in case, delete this character from limbo.
			one_off.RemoveFromLimbo(char_mind.unique_id, LIMBO_MIND)
			continue
		if(QDELETED(current_mob))
			continue
		// Check to see if the mobs are already being saved.
		if(current_mob.in_saved_location())
			continue
		one_off.AddToLimbo(list(current_mob, char_mind), char_mind.unique_id, LIMBO_MIND, char_mind.key, current_mob.real_name, TRUE)
	report_progress_serializer("Added player minds to limbo in [REALTIMEOFDAY2SEC(time_start)]s.")

///Run the pre-save stuff
/datum/controller/subsystem/persistence/proc/_before_save(var/save_initiator)
	//Clear any previous log entry ids we got from the db before
	save_log_id = null

	// Collect the z-levels we're saving and get the turfs!
	to_world_log("Saving [LAZYLEN(SSpersistence.saved_levels)] z-levels. World size max ([world.maxx],[world.maxy])")
	sleep(5)

	//Disable all subsystems
	try
		PauseSubsystems()
	catch(var/exception/e_ss)
		HandleRecoverableException(e_ss, "PauseSubsystems()")
	sleep(5)

	// Prepare all atmospheres to save.
	try
		prepare_atmos_for_save()
	catch(var/exception/e_atmos)
		HandleRecoverableException(e_atmos, "prepare_atmos_for_save()")
	sleep(5)

	//Let the serializer know we're preparing a save
	// Wipe the previous save + add log entry
	try
		var/time_start_wipe = REALTIMEOFDAY
		save_log_id = serializer.PreWorldSave(save_initiator)
		report_progress_serializer("Wiped previous save in [REALTIMEOFDAY2SEC(time_start_wipe)]s.")
	catch(var/exception/e_presave)
		if(istype(e_presave, /exception/sql_connection))
			HandleCriticalException(e_presave, "serializer.PreWorldSave()") //db queries errors during wipe are unrecoverable and WILL break further duplicate INSERTS..
		else
			HandleRecoverableException(e_presave, "serializer.PreWorldSave()")
	sleep(5)

	//Clear limbo stuff after we've connected to the db!
	try
		prepare_limbo_for_save()
	catch(var/exception/e_limbo)
		HandleRecoverableException(e_limbo, "prepare_limbo_for_save()")
	sleep(5)

///Runs the post-saving stuff
/datum/controller/subsystem/persistence/proc/_after_save()
	try
		//Do post-save cleanup and logging
		serializer.PostWorldSave(save_log_id, nb_saved_z_levels, nb_saved_atoms, save_complete_text)
		saved_extensions.Cut() // Make extensions re-report if they want to be saved again.
		// Clear the custom saved list used to keep list refs intact
		global.custom_saved_lists.Cut()

		//Print out detailed statistics on what time was spent on what types
		var/list/saved_types_stats = list()
		global.serialization_time_spent_type = sortTim(global.serialization_time_spent_type, /proc/cmp_serialization_stats_dsc, 1)
		for(var/key in global.serialization_time_spent_type)
			var/datum/serialization_stat/statistics = global.serialization_time_spent_type[key]
			saved_types_stats += "\t[statistics.time_spent / (1 SECOND)] second(s)\t[statistics.nb_instances]\tinstance(s)\t\t'[key]'"

		to_world(SPAN_CLASS(save_complete_span_class, save_complete_text))
		to_world_log("Time spent per type:\n[jointext(saved_types_stats, "\n")]")
		to_world_log("Total time spent doing saved variables lookups: [global.get_saved_variables_lookup_time_total / (1 SECOND)] second(s).")

		//Resume all subsystems
		ResumeSubsystems()

	catch(var/exception/e)
		HandleRecoverableException(e, "_after_save()") //Anything post-save is recoverable

/datum/controller/subsystem/persistence/proc/_prepare_zlevels_indexing()
	var/time_start_zprepare = REALTIMEOFDAY
	// This will prepare z_level translations.
	var/list/z_transform = list()
	var/new_z_index      = 1

	report_progress_serializer("Preparing z-levels for save..")
	sleep(5)
	try
		// First we find the highest non-dynamic z_level.
		for(var/z in SSmapping.player_levels) //#FIXME: That logic is flawed. We got levels that aren't dynamic and aren't station levels!!!!
			if(z in saved_levels)
				new_z_index = max(new_z_index, z)

		// Now we go through our saved levels and remap all of those.
		for(var/z in saved_levels)
			var/datum/persistence/load_cache/z_level/z_level = new()
			var/datum/level_data/LD = SSmapping.levels_by_z[z]
			z_level.default_turf = get_base_turf(z)
			z_level.index = z
			z_level.level_data_subtype = LD.type
			if(z in SSmapping.player_levels) //#FIXME: That logic is flawed. We got levels that aren't dynamic and aren't station levels!!!!
				z_level.dynamic = FALSE
				z_level.new_index = z
			else
				new_z_index++
				z_level.dynamic = TRUE
				z_level.new_index = new_z_index
			z_transform["[z]"] = z_level

		// Go through all of our saved areas and save those, too.
		for(var/area/A in saved_areas)
			for(var/turf/T in A)
				if("[T.z]" in z_transform)
					continue
				// Turf exists in an area outside of saved_levels.
				// In this case, we'll remap.
				var/datum/persistence/load_cache/z_level/z_level = new()
				z_level.default_turf = get_base_turf(T.z)
				z_level.index = T.z
				z_level.dynamic = TRUE
				var/datum/level_data/LD = SSmapping.levels_by_z[T.z]
				z_level.level_data_subtype = LD.type
				if("[T.z]" in global.overmap_sectors)
					var/obj/effect/overmap = global.overmap_sectors["[T.z]"]
					z_level.metadata = "[overmap.x],[overmap.y]"
				new_z_index++
				z_level.new_index = new_z_index
				z_transform["[T.z]"] = z_level

		// Now we rebuild our z_level metadata list into the serializer for it to remap everything for us.
		for(var/z in z_transform)
			var/datum/persistence/load_cache/z_level/z_level = z_transform[z]
			serializer.z_map["[z_level.index]"] = z_level.new_index
		new_z_index++
		serializer.z_index = new_z_index

		report_progress_serializer("Z-levels prepared for save in [REALTIMEOFDAY2SEC(time_start_zprepare)]s.")
		sleep(5)

	catch(var/exception/e)
		//Critical because If z-indexes are messed up, it can corrupt the whole save.
		HandleCriticalException(e, "_prepare_zlevels_indexing()")

	return z_transform

///Saves all the turfs marked for saving in the world.
/datum/controller/subsystem/persistence/proc/_save_turfs(var/list/z_transform)
	report_progress_serializer("Saving z-level turfs..")
	sleep(5)

	var/time_start_zsave = REALTIMEOFDAY
	///Amount of turfs waiting for a commit
	var/nb_turfs_queued  = 1
	///The total count of zlevels we're saving
	var/total_zlevels    = length(saved_levels)

	//!!!!!!!!!!!!!!!!!!!!!!!!
	//!! - HOT CODE BELOW - !!
	//!!!!!!!!!!!!!!!!!!!!!!!!
	for(var/z in saved_levels)
		var/datum/persistence/load_cache/z_level/z_level = z_transform["[z]"] //#FIXME: String concatenation are extremely slow!!!
		var/last_area_type
		var/last_area_name
		var/default_turf    = get_base_turf(z)
		var/area_turf_count = 0

		try
			// We iterate horizontally, since saved turfs 'in' area contents are iterated over in the same way.
			for(var/y in 1 to world.maxy)
				for(var/x in 1 to world.maxx)
					try
						// Get the thing to serialize and serialize it.
						var/turf/T  = locate(x,y,z)
						var/area/TA = T.loc

						if(last_area_type != TA.type || last_area_name != TA.name)
							if(area_turf_count > 0)
								z_level.areas += list(list("[last_area_type]", sanitize_sql(last_area_name), area_turf_count))
							last_area_type = TA.type //#FIXME: If last_area_type is only ever used as a string, might as well concat it here, instead of doing it thousands of time above?
							last_area_name = TA.name
							area_turf_count = 1
						else
							area_turf_count++

						var/should_skip = __SHOULD_SKIP_TURF(T)
						// These if statements checks to see if we should save this turf.
						if(!should_skip && istype(T, default_turf) || !T.should_save)
							for(var/atom/A as anything in T.contents)
								if(A.should_save())
									should_skip = FALSE
									break // We found a thing that's worth saving.
						if(should_skip)
							continue //Turfs not saved become their default_turf after deserialization.

						//If we got through the filter save
						serializer.Serialize(T, null, z)

					catch(var/exception/e_turf)
						HandleRecoverableException(e_turf, "saving a turf") //Allow a turf to fail to save when allowed, that's minimal damage.

					// Don't commit every single tile.
					// Batch them up to save time.
					if(nb_turfs_queued % 128 == 0)
						try
							serializer.Commit()
							nb_turfs_queued = 1
						catch(var/exception/e_turf_commit)
							nb_turfs_queued = 1
							HandleCriticalException(e_turf_commit, "pushing turf commit") //Failing a commit is pretty bad since they're all batched together.
					else
						nb_turfs_queued++

			if(last_area_type)
				z_level.areas += list(list("[last_area_type]", sanitize_sql(last_area_name), area_turf_count))
		catch(var/exception/e_zlvl)
			HandleRecoverableException(e_zlvl, "saving a z level") //A z-level failing is manageable.

		//Ref update commit + flush commit
		try
			serializer.Commit() // cleanup leftovers.
			serializer.CommitRefUpdates()
		catch(var/exception/e_ref_commit)
			HandleCriticalException(e_ref_commit, "pushing a ref update commit") //Failing ref updates is really bad.

		++nb_saved_z_levels
		report_progress_serializer("Working.. [CEILING((nb_saved_z_levels * 100) / total_zlevels)]%")
		sleep(3)

	nb_turfs_queued = 1
	report_progress_serializer("Z-levels turfs saved in [REALTIMEOFDAY2SEC(time_start_zsave)]s.")
	sleep(5)

///Saves area stuff
/datum/controller/subsystem/persistence/proc/_save_areas(var/list/z_transform)
	var/time_start_zarea = REALTIMEOFDAY
	var/list/area_chunks = list()
	var/nb_turfs_queued  = 1

	//#FIXME: This block of code is deranged. It's making us iterate over all turfs in the world again just to save area stuff?
	//        We should do all turf-related ops in a single spot, not copy paste code like this.

	// Repeat much of the above code in order to save areas marked to be saved that are not in a saved z-level.
	for(var/area/A in saved_areas)
		var/datum/persistence/load_cache/area_chunk/area_chunk = new()
		area_chunk.area_type = A.type
		area_chunk.name      = A.name

		for(var/turf/T in A) //#FIXME: This actually iterates through ALL TURFS IN THE WORLD. Area contents is broken and slow.
			if(T.z in saved_levels) //#FIXME: We're already going through saved zlevels above..
				continue
			//#FIXME: This is a copy paste of the code prior and it has some differences with it too, which will cause mismatches between areas and turfs saving.
			var/turf/default_turf = get_base_turf(T.z)
			if(!istype(T) || istype(T, default_turf))
				if(!istype(T) || !T.contents || !length(T.contents) || !T.should_save)
					continue
				var/should_skip = TRUE
				for(var/atom/AM as anything in T.contents)
					if(AM.should_save())
						should_skip = FALSE
						break // We found a thing that's worth saving.
				if(should_skip)
					continue // Skip this tile. Not worth saving.

			var/new_z = serializer.z_map["[T.z]"] //#FIXME: String concat is extremely slow.
			if(new_z)
				area_chunk.turfs += "[T.x],[T.y],[new_z]" //#FIXME: String concat is extremely slow.
			serializer.Serialize(T, null, T.z)

			// Don't save every single tile.
			// Batch them up to save time.
			if(nb_turfs_queued % 128 == 0)
				serializer.Commit()
				nb_turfs_queued = 1
			else
				nb_turfs_queued++

		if(length(area_chunk.turfs))
			area_chunks += area_chunk

		serializer.Commit() // cleanup leftovers.

	try
		// Insert our z-level remaps.
		serializer.save_z_level_remaps(z_transform)
		if(length(area_chunks))
			serializer.save_area_chunks(area_chunks)
		serializer.Commit()
		serializer.CommitRefUpdates()
	catch(var/exception/e_commit)
		HandleCriticalException(e_commit, "area saving turf ref commit")

	report_progress_serializer("Z-levels areas saved in [REALTIMEOFDAY2SEC(time_start_zarea)]s.")
	sleep(5)

///Saves extension wrapper stuff
/datum/controller/subsystem/persistence/proc/_save_extensions()
	var/datum/wrapper_holder/extension_wrapper_holder = new(saved_extensions)
	var/time_start_extensions = REALTIMEOFDAY

	try
		serializer.Serialize(extension_wrapper_holder)
	catch(var/exception/e_serial)
		HandleRecoverableException(e_serial, "extension serialization")

	try
		serializer.Commit()
	catch(var/exception/e_commit)
		HandleCriticalException(e_commit, "extension commit") //If commit fails, we corrupted our commit cache so not good

	report_progress_serializer("Saved extensions in [REALTIMEOFDAY2SEC(time_start_extensions)]s.")
	sleep(5)

///Save bank account stuff
/datum/controller/subsystem/persistence/proc/_save_bank_accounts()
	if(!length(SSmoney_accounts.all_escrow_accounts))
		return
	var/datum/wrapper_holder/escrow_holder/e_holder = new(SSmoney_accounts.all_escrow_accounts.Copy())
	var/time_start_escrow = REALTIMEOFDAY

	try
		serializer.Serialize(e_holder)
	catch(var/exception/e_serial)
		HandleRecoverableException(e_serial, "bank account serialization")

	try
		serializer.Commit()
	catch(var/exception/e_commit)
		HandleCriticalException(e_commit, "bank account  commit") //If commit fails, we corrupted our commit cache so not good

	report_progress_serializer("Escrow accounts saved in [REALTIMEOFDAY2SEC(time_start_escrow)]s.")
	sleep(5)

///Causes a world save to be started.
/datum/controller/subsystem/persistence/proc/SaveWorld(var/save_initiator)
	//Make sure we log who started the save.
	if(!save_initiator && ismob(usr))
		save_initiator = usr.ckey

	var/start = REALTIMEOFDAY

	//Prevent entering
	BlockEntering()

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
	RestoreEntering()

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

/datum/controller/subsystem/persistence/proc/clear_late_wrapper_queue()
	if(!length(late_wrappers))
		return
	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection while clearing wrapper queue!")
		new_db_connection = TRUE
	for(var/datum/wrapper/late/L as anything in late_wrappers)
		L.on_late_load()

	late_wrappers.Cut()
	if(new_db_connection)
		close_save_db_connection()

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

/datum/controller/subsystem/persistence/proc/AddToLimbo(var/list/things, var/key, var/limbo_type, var/metadata, var/metadata2, var/modify = TRUE, var/initiator)
	//Make sure we log who started the save.
	if(!initiator && ismob(usr))
		initiator = usr.ckey

	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection during Limbo Addition!")
		new_db_connection = TRUE

	//Log transaction
	var/limbo_log_id = one_off.PreStorageSave(initiator)
	. = one_off.AddToLimbo(things, key, limbo_type, metadata, metadata2, modify)
	if(.) // Clear it from the queued removals.
		for(var/list/queued in limbo_removals)
			if(queued[1] == sanitize_sql(key) && queued[2] == limbo_type)
				limbo_removals -= list(queued)

	one_off.PostStorageSave(limbo_log_id, 0, length(things), "Addition [limbo_type] [key]")
	if(new_db_connection)
		close_save_db_connection()

/datum/controller/subsystem/persistence/proc/RemoveFromLimbo(var/limbo_key, var/limbo_type, var/initiator)
	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection during Limbo Removal!")
	//Log transaction
	var/limbo_log_id = one_off.PreStorageSave(initiator)
	. = one_off.RemoveFromLimbo(limbo_key, limbo_type)
	one_off.PostStorageSave(limbo_log_id, 0, ., "Removal [limbo_type]")

	if(new_db_connection)
		close_save_db_connection()

/datum/controller/subsystem/persistence/proc/DeserializeOneOff(var/limbo_key, var/limbo_type, var/remove_after = TRUE)
	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection during Limbo Deserialization!")
		new_db_connection = TRUE
	. = one_off.DeserializeOneOff(limbo_key, limbo_type, remove_after)
	if(remove_after)
		limbo_removals += list(list(sanitize_sql(limbo_key), limbo_type))
	if(new_db_connection)
		close_save_db_connection()

// Get an object from its p_id via ref tracking. This will not always work if an object is asynchronously deserialized from others.
// This is also quite slow - if you're trying to locate many objects at once, it's best to use a single query for multiple objects.
/datum/controller/subsystem/persistence/proc/get_object_from_p_id(var/target_p_id)

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

/datum/controller/subsystem/persistence/proc/print_db_status()
	return SQLS_Print_DB_STATUS()

//Stats datum
/datum/serialization_stat
	var/time_spent   = 0
	var/nb_instances = 0
/datum/serialization_stat/New(var/_time_spent = 0, var/_nb_instances = 0)
	. = ..()
	time_spent   = _time_spent
	nb_instances = _nb_instances

#undef __SHOULD_SKIP_TURF