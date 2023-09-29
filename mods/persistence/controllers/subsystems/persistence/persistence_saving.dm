///If this returns true, we should always skip saving this turf!
///Ignore non-saved areas and turfs with no contents.
#define __SHOULD_SKIP_TURF(T) ((!istype(T) || !length(T.contents)) || (istype(T.loc, /area) && (T.loc:area_flags & AREA_FLAG_IS_NOT_PERSISTENT)))

/////////////////////////////////////////////////////////////////
// Utility
/////////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////////
// Exception Filtering
/////////////////////////////////////////////////////////////////

///Call in a catch block for critical/typically unrecoverable errors during save. Filters out the kind of exceptions we let through or not.
/datum/controller/subsystem/persistence/proc/_handle_critical_save_exception(var/exception/E, var/code_location)
	if(error_tolerance < PERSISTENCE_ERROR_TOLERANCE_ANY)
		throw E
	else
		log_warning(EXCEPTION_TEXT(E))
		log_warning("Error tolerance set to 'any', proceeding with save despite critical error in '[code_location]'!")

///Call in a catch block for recoverable or non-critical errors during save. Filters out the kind of exceptions we let through or not.
/datum/controller/subsystem/persistence/proc/_handle_recoverable_save_exception(var/exception/E, var/code_location)
	if(error_tolerance < PERSISTENCE_ERROR_TOLERANCE_RECOVERABLE)
		throw E
	else
		log_warning(EXCEPTION_TEXT(E))
		log_warning("Error tolerance set to 'critical-only', proceeding with save despite error in '[code_location]'!")

/////////////////////////////////////////////////////////////////
// Saving Steps
/////////////////////////////////////////////////////////////////

///Make atmos store it's air values so we can properly save them per atmos atom.
/datum/controller/subsystem/persistence/proc/prepare_atmos_for_save()
	var/time_start = REALTIMEOFDAY
	SSmachines.temporarily_store_pipenets()
	report_progress_serializer("Pipenet air stored in [REALTIMEOFDAY2SEC(time_start)]s")

	time_start = REALTIMEOFDAY
	SSair.invalidate_all_zones()
	report_progress_serializer("Invalidated in [REALTIMEOFDAY2SEC(time_start)]s")

///Update the list of things in limbo and not in limbo, so they don't get saved in 2 different states.
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
		_handle_critical_save_exception(e, "_prepare_zlevels_indexing()")

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

	//Reset our status vars
	nb_saved_z_levels = 0
	nb_saved_atoms    = 0

	//!!!!!!!!!!!!!!!!!!!!!!!!
	//!! - HOT CODE BELOW - !!
	//!!!!!!!!!!!!!!!!!!!!!!!!
	for(var/z in saved_levels)
		var/datum/persistence/load_cache/z_level/z_level = z_transform["[z]"]
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
							last_area_type = TA.type
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
						_handle_recoverable_save_exception(e_turf, "saving a turf") //Allow a turf to fail to save when allowed, that's minimal damage.

					// Don't commit every single tile.
					// Batch them up to save time.
					if(nb_turfs_queued % 128 == 0)
						try
							serializer.Commit()
							nb_turfs_queued = 1
						catch(var/exception/e_turf_commit)
							nb_turfs_queued = 1
							_handle_critical_save_exception(e_turf_commit, "pushing turf commit") //Failing a commit is pretty bad since they're all batched together.
					else
						nb_turfs_queued++

			if(last_area_type)
				z_level.areas += list(list("[last_area_type]", sanitize_sql(last_area_name), area_turf_count))
		catch(var/exception/e_zlvl)
			_handle_recoverable_save_exception(e_zlvl, "saving a z level") //A z-level failing is manageable.

		//Ref update commit + flush commit
		try
			serializer.Commit() // cleanup leftovers.
			serializer.CommitRefUpdates()
		catch(var/exception/e_ref_commit)
			_handle_critical_save_exception(e_ref_commit, "pushing a ref update commit") //Failing ref updates is really bad.

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
		_handle_critical_save_exception(e_commit, "area saving turf ref commit")

	report_progress_serializer("Z-levels areas saved in [REALTIMEOFDAY2SEC(time_start_zarea)]s.")
	sleep(5)

///Saves extension wrapper stuff
/datum/controller/subsystem/persistence/proc/_save_extensions()
	var/datum/wrapper_holder/extension_wrapper_holder = new(saved_extensions)
	var/time_start_extensions = REALTIMEOFDAY

	try
		serializer.Serialize(extension_wrapper_holder)
	catch(var/exception/e_serial)
		_handle_recoverable_save_exception(e_serial, "extension serialization")

	try
		serializer.Commit()
	catch(var/exception/e_commit)
		_handle_critical_save_exception(e_commit, "extension commit") //If commit fails, we corrupted our commit cache so not good

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
		_handle_recoverable_save_exception(e_serial, "bank account serialization")

	try
		serializer.Commit()
	catch(var/exception/e_commit)
		_handle_critical_save_exception(e_commit, "bank account  commit") //If commit fails, we corrupted our commit cache so not good

	report_progress_serializer("Escrow accounts saved in [REALTIMEOFDAY2SEC(time_start_escrow)]s.")
	sleep(5)

/////////////////////////////////////////////////////////////////
// Pre/Post Save
/////////////////////////////////////////////////////////////////

///Run the pre-save stuff
/datum/controller/subsystem/persistence/proc/_before_save(var/save_initiator)
	//Clear any previous log entry ids we got from the db before
	save_log_id = null

	// Collect the z-levels we're saving and get the turfs!
	to_world_log("Saving [LAZYLEN(SSpersistence.saved_levels)] z-levels. World size max ([world.maxx],[world.maxy])")
	sleep(5)

	//Disable all subsystems
	try
		_pause_subsystems()
	catch(var/exception/e_ss)
		_handle_recoverable_save_exception(e_ss, "_pause_subsystems()")
	sleep(5)

	// Prepare all atmospheres to save.
	try
		prepare_atmos_for_save()
	catch(var/exception/e_atmos)
		_handle_recoverable_save_exception(e_atmos, "prepare_atmos_for_save()")
	sleep(5)

	//Let the serializer know we're preparing a save
	// Wipe the previous save + add log entry
	try
		var/time_start_wipe = REALTIMEOFDAY
		save_log_id = serializer.PreWorldSave(save_initiator)
		report_progress_serializer("Wiped previous save in [REALTIMEOFDAY2SEC(time_start_wipe)]s.")
	catch(var/exception/e_presave)
		if(istype(e_presave, /exception/sql_connection))
			_handle_critical_save_exception(e_presave, "serializer.PreWorldSave()") //db queries errors during wipe are unrecoverable and WILL break further duplicate INSERTS..
		else
			_handle_recoverable_save_exception(e_presave, "serializer.PreWorldSave()")
	sleep(5)

	//Clear limbo stuff after we've connected to the db!
	try
		prepare_limbo_for_save()
	catch(var/exception/e_limbo)
		_handle_recoverable_save_exception(e_limbo, "prepare_limbo_for_save()")
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
		to_world_log(save_complete_text)
		to_world_log("Time spent per type:\n[jointext(saved_types_stats, "\n")]")
		to_world_log("Total time spent doing saved variables lookups: [global.get_saved_variables_lookup_time_total / (1 SECOND)] second(s).")

	catch(var/exception/e)
		_handle_recoverable_save_exception(e, "_after_save()") //Anything post-save is recoverable

#undef __SHOULD_SKIP_TURF
