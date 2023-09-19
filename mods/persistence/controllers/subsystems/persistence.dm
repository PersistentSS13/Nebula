#define SS_INIT_PERSISTENCE 18.5

/proc/cmp_serialization_stats_dsc(var/datum/serialization_stat/S1, var/datum/serialization_stat/S2)
	return S2.time_spent - S1.time_spent

/datum/controller/subsystem/persistence
	name = "Persistence"
	init_order = SS_INIT_PERSISTENCE
	flags = SS_NO_FIRE

	var/save_exists			=	FALSE	// Whether or not a save exists in the DB
	var/in_loaded_world 	= 	FALSE	// Whether or not we're in a world that was loaded.

	var/list/saved_areas	= 	list()
	var/list/saved_levels 	= 	list()	// Saved levels are saved entirely and optimized with get_base_turf()
	var/list/saved_extensions = list()  // Extensions mark themselves to be saved on world save.

	var/rent_enabled = FALSE			// Whether or not rent will be required for created sectors.

	var/serializer/sql/serializer = new() // The serializer impl for actually saving.
	var/serializer/sql/one_off/one_off	= new() // The serializer impl for one off serialization/deserialization.

	var/list/limbo_removals = list() // Objects which will be removed from limbo on the next save. Format is list(limbo_key, limbo_type)
	var/list/limbo_refs = list()	 // Objects which are deserialized out of limbo don't have their refs in the database immediately, so we add them here until the next save
									 // Format is p_id -> ref

	var/loading_world = FALSE

	var/list/late_wrappers = list() // Some wrapped objects need special behavior post-load. This list is cleared post-atom Init.

/datum/controller/subsystem/persistence/proc/SaveExists()
	if(!save_exists)
		save_exists = establish_save_db_connection() && serializer.save_exists()
		in_loaded_world = save_exists
	return save_exists

/datum/controller/subsystem/persistence/proc/SaveWorld()
	// Collect the z-levels we're saving and get the turfs!
	to_world_log("Saving [LAZYLEN(SSpersistence.saved_levels)] z-levels. World size max ([world.maxx],[world.maxy])")
	sleep(5)
	serializer._before_serialize()

	var/start = world.timeofday

	// Launch events

	RAISE_EVENT(/decl/observ/world_saving_start_event, src)
	try
		//
		// 	PREPARATION SECTIONS
		//
		var/reallow = 0
		if(config.enter_allowed) reallow = 1
		config.enter_allowed = 0
		// Prepare atmosphere for saving.
		SSair.can_fire = FALSE
		if (SSair.state != SS_IDLE)
			report_progress_serializer("ZAS Rebuild initiated. Waiting for current air tick to complete before continuing.")
			sleep(5)
		while (SSair.state != SS_IDLE)
			stoplag()

		// Prepare all atmospheres to save.
		report_progress_serializer("Storing pipenet air..")
		sleep(5)
		var/time_start_pipenet = REALTIMEOFDAY
		for(var/datum/pipe_network/net in SSmachines.pipenets)
			for(var/datum/pipeline/line in net.line_members)
				line.temporarily_store_fluids()
		report_progress_serializer("Pipenet air stored in [(REALTIMEOFDAY - time_start_pipenet) / (1 SECOND)]s")
		sleep(5)

		report_progress_serializer("Invalidating all airzones..")
		sleep(5)
		var/time_start_airzones = REALTIMEOFDAY
		while (SSair.zones.len)
			var/zone/zone = SSair.zones[SSair.zones.len]
			SSair.zones.len--
			zone.c_invalidate()
		report_progress_serializer("Invalidated in [(REALTIMEOFDAY - time_start_airzones) / (1 SECOND)]s")
		sleep(5)

		report_progress_serializer("Removing queued limbo objects..")
		sleep(5)

		var/time_start_limbo_removal = REALTIMEOFDAY
		for(var/list/queued in limbo_removals)
			one_off.RemoveFromLimbo(queued[1], queued[2])
			limbo_removals -= list(queued)

		limbo_refs.Cut()
		report_progress_serializer("Done removing queued limbo objects in [(REALTIMEOFDAY - time_start_limbo_removal) / (1 SECOND)]s.")
		sleep(5)

		report_progress_serializer("Adding limbo players minds to limbo..")
		sleep(5)
		var/time_start_limbo_minds = REALTIMEOFDAY
		// Find all the minds gameworld and add any player characters to the limbo list.
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
		report_progress_serializer("Done adding player minds to limbo in [(REALTIMEOFDAY - time_start_limbo_minds) / (1 SECOND)]s.")
		sleep(5)

		report_progress_serializer("Wiping previous save..")
		sleep(5)
		var/time_start_wipe = REALTIMEOFDAY
		// Wipe the previous save.
		serializer.WipeSave()
		report_progress_serializer("Done wiping previous save in [(REALTIMEOFDAY - time_start_wipe) / (1 SECOND)]s.")
		sleep(5)

		//
		// 	ACTUAL SAVING SECTION
		//

		report_progress_serializer("Preparing z-levels for save..")
		sleep(5)
		var/time_start_zprepare = REALTIMEOFDAY
		// This will prepare z_level translations.
		var/list/z_transform = list()
		var/new_z_index = 1
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

		report_progress_serializer("Z-levels prepared for save in [(REALTIMEOFDAY - time_start_zprepare) / (1 SECOND)]s.")
		sleep(5)

		report_progress_serializer("Saving z-level turfs..")
		sleep(5)
		var/time_start_zsave = REALTIMEOFDAY
		// This will save all the turfs/world.
		var/index = 1
		var/progress = 0
		var/max_progress = length(saved_levels)

		for(var/z in saved_levels)
			var/default_turf = get_base_turf(z)
			var/datum/persistence/load_cache/z_level/z_level = z_transform["[z]"]

			var/last_area_type
			var/last_area_name
			var/area_turf_count = 0

			// We iterate horizontally, since saved turfs 'in' area contents are iterated over in the same way.
			for(var/y in 1 to world.maxy)
				for(var/x in 1 to world.maxx)
					// Get the thing to serialize and serialize it.
					var/turf/T = locate(x,y,z)
					var/area/TA = T.loc

					if(last_area_type != TA.type || last_area_name != TA.name)
						if(area_turf_count > 0)
							z_level.areas += list(list("[last_area_type]", sanitize_sql(last_area_name), area_turf_count))
						last_area_type = TA.type
						last_area_name = TA.name
						area_turf_count = 1
					else
						area_turf_count++

					// These if statements checks to see if we should save this turf.

					//Ignore non-saved areas
					if(istype(TA) && (TA.area_flags & AREA_FLAG_IS_NOT_PERSISTENT))
						continue

					// Turfs not saved become their default_turf after deserialization.
					if(!istype(T) || !LAZYLEN(T.contents))
						continue

					//Save anything else
					if(istype(T, default_turf) || !T.should_save)
						var/should_skip = TRUE
						for(var/atom/A as anything in T.contents)
							if(A.should_save())
								should_skip = FALSE
								break // We found a thing that's worth saving.
						if(should_skip)
							continue // Skip this tile. Not worth saving.
					serializer.Serialize(T, null, z)

					// Don't save every single tile.
					// Batch them up to save time.
					if(index % 128 == 0)
						serializer.Commit()
						index = 1
					else
						index++
			if(last_area_type)
				z_level.areas += list(list("[last_area_type]", sanitize_sql(last_area_name), area_turf_count))

			serializer.Commit() // cleanup leftovers.
			serializer.CommitRefUpdates()
			++progress
			report_progress_serializer("Working.. [(progress * 100) / max_progress]%")
			sleep(3)

		index = 1
		report_progress_serializer("Z-levels turfs saved in [(REALTIMEOFDAY - time_start_zsave) / (1 SECOND)]s.")
		sleep(5)

		report_progress_serializer("Saving z-level areas..")
		sleep(5)
		var/time_start_zarea = REALTIMEOFDAY
		// Repeat much of the above code in order to save areas marked to be saved that are not in a saved z-level.
		var/list/area_chunks = list()
		for(var/area/A in saved_areas)
			var/datum/persistence/load_cache/area_chunk/area_chunk = new()
			area_chunk.area_type = A.type
			area_chunk.name = A.name
			for(var/turf/T in A)
				if(T.z in saved_levels)
					continue
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

				var/new_z = serializer.z_map["[T.z]"]
				if(new_z)
					area_chunk.turfs += "[T.x],[T.y],[new_z]"
				serializer.Serialize(T, null, T.z)

				// Don't save every single tile.
				// Batch them up to save time.
				if(index % 128 == 0)
					serializer.Commit()
					index = 1
				else
					index++

			if(length(area_chunk.turfs))
				area_chunks += area_chunk

			serializer.Commit() // cleanup leftovers.

		// Insert our z-level remaps.
		serializer.save_z_level_remaps(z_transform)
		if(length(area_chunks))
			serializer.save_area_chunks(area_chunks)
		serializer.Commit()
		serializer.CommitRefUpdates()

		report_progress_serializer("Z-levels areas saved in [(REALTIMEOFDAY - time_start_zarea) / (1 SECOND)]s.")
		sleep(5)

		report_progress_serializer("Saving extensions...")
		// Now save all the extensions which have marked themselves to be saved.
		// As with areas, we create a dummy wrapper holder to hold these during load etc.
		var/datum/wrapper_holder/extension_wrapper_holder = new(saved_extensions)
		var/time_start_extensions = REALTIMEOFDAY
		serializer.Serialize(extension_wrapper_holder)
		serializer.Commit()

		report_progress_serializer("Extensions saved in [(REALTIMEOFDAY - time_start_extensions) / (1 SECOND)]s.")
		sleep(5)

		// Save escrow accounts which are normally held on the SSmoney_accounts subsystem
		if(length(SSmoney_accounts.all_escrow_accounts))
			report_progress_serializer("Saving escrow accounts...")
			var/datum/wrapper_holder/escrow_holder/e_holder = new(SSmoney_accounts.all_escrow_accounts.Copy())
			var/time_start_escrow = REALTIMEOFDAY

			serializer.Serialize(e_holder)
			serializer.Commit()

			report_progress_serializer("Escrow accounts saved in [(REALTIMEOFDAY - time_start_escrow) / (1 SECOND)]s.")

		//
		//	CLEANUP SECTION
		//
		// Clear the refmaps/do other cleanup to end the save.
		serializer.Clear()
		// Clear the custom saved list used to keep list refs intact
		global.custom_saved_lists.Cut()
		// Let people back in
		if(reallow) config.enter_allowed = 1
	catch (var/exception/e)
		to_world_log("Save failed on line [e.line], file [e.file] with message: '[e]'.")

	to_world("Save complete! Took [(world.timeofday-start)/ (1 SECOND)]s to save world.")
	saved_extensions.Cut() // Make extensions re-report if they want to be saved again.
	serializer._after_serialize()

	// Launch event for anything that needs to do cleanup post save.
	RAISE_EVENT_REPEAT(/decl/observ/world_saving_finish_event, src)

	//Print out detailed statistics on what time was spent on what types
	var/list/saved_types_stats = list()
	global.serialization_time_spent_type = sortTim(global.serialization_time_spent_type, /proc/cmp_serialization_stats_dsc, 1)
	for(var/key in global.serialization_time_spent_type)
		var/datum/serialization_stat/statistics = global.serialization_time_spent_type[key]
		saved_types_stats += "\t[statistics.time_spent / (1 SECOND)] second(s)\t[statistics.nb_instances]\tinstance(s)\t\t'[key]'"
	to_world_log("Time spent per type:\n[jointext(saved_types_stats, "\n")]")
	to_world_log("Total time spent doing saved variables lookups: [global.get_saved_variables_lookup_time_total / (1 SECOND)] second(s).")

	// Reboot air subsystem.
	SSair.reboot()

/datum/controller/subsystem/persistence/proc/LoadWorld()
	serializer._before_deserialize()
	try
		// Loads all data in as part of a version.
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection!")
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

/datum/controller/subsystem/persistence/proc/AddToLimbo(var/list/things, var/key, var/limbo_type, var/metadata, var/metadata2, var/modify = TRUE)
	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection during Limbo Addition!")
		new_db_connection = TRUE
	. = one_off.AddToLimbo(things, key, limbo_type, metadata, metadata2, modify)
	if(.) // Clear it from the queued removals.
		for(var/list/queued in limbo_removals)
			if(queued[1] == sanitize_sql(key) && queued[2] == limbo_type)
				limbo_removals -= list(queued)
	if(new_db_connection)
		close_save_db_connection()

/datum/controller/subsystem/persistence/proc/RemoveFromLimbo(var/limbo_key, var/limbo_type)
	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection during Limbo Removal!")
	. = one_off.RemoveFromLimbo(limbo_key, limbo_type)
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