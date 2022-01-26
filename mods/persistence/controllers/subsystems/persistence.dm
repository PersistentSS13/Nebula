/datum/controller/subsystem/persistence
	name = "Persistence"
	init_order = SS_INIT_EARLY
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

	var/loading_world = FALSE

	var/list/late_wrappers = list() // Some wrapped objects need special behavior post-load. This list is cleared post-atom Init.

/datum/controller/subsystem/persistence/Initialize()
	saved_levels = global.using_map.saved_levels
	saved_areas = global.using_map.saved_areas

/datum/controller/subsystem/persistence/proc/SaveExists()
	if(!save_exists)
		save_exists = serializer.save_exists()
		in_loaded_world = save_exists
	return save_exists

/datum/controller/subsystem/persistence/proc/SaveWorld()
	// Collect the z-levels we're saving and get the turfs!
	to_world_log("Saving [LAZYLEN(SSpersistence.saved_levels)] z-levels. World size max ([world.maxx],[world.maxy])")
	sleep(5)
	serializer._before_serialize()

	var/start = world.timeofday
	
	// Launch events

	events_repository.raise_event(/decl/observ/world_saving_start_event, src)
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
			report_progress("ZAS Rebuild initiated. Waiting for current air tick to complete before continuing.")
			sleep(5)
		while (SSair.state != SS_IDLE)
			stoplag()

		// Prepare all atmospheres to save.
		report_progress("Storing pipenet air..")
		sleep(5)
		var/time_start_pipenet = REALTIMEOFDAY
		for(var/datum/pipe_network/net in SSmachines.pipenets)
			for(var/datum/pipeline/line in net.line_members)
				line.temporarily_store_fluids()
		report_progress("Pipenet air stored in [(REALTIMEOFDAY - time_start_pipenet) / (1 SECOND)]s")
		sleep(5)

		report_progress("Invalidating all airzones..")
		sleep(5)
		var/time_start_airzones = REALTIMEOFDAY
		while (SSair.zones.len)
			var/zone/zone = SSair.zones[SSair.zones.len]
			SSair.zones.len--
			zone.c_invalidate()
		report_progress("Invalidated in [(REALTIMEOFDAY - time_start_airzones) / (1 SECOND)]s")
		sleep(5)
		
		report_progress("Removing queued limbo objects..")
		sleep(5)

		var/time_start_limbo_removal = REALTIMEOFDAY
		for(var/list/queued in limbo_removals)
			one_off.RemoveFromLimbo(queued[1], queued[2])
			limbo_removals -= queued

		report_progress("Done removing queued limbo objects in [(REALTIMEOFDAY - time_start_limbo_removal) / (1 SECOND)]s.")
		sleep(5)

		report_progress("Adding limbo players minds to limbo..")
		sleep(5)
		var/time_start_limbo_minds = REALTIMEOFDAY
		// Find all the minds gameworld and add any player characters to the limbo list.
		for(var/datum/mind/char_mind in global.player_minds)
			var/mob/current_mob = char_mind.current
			if(!current_mob || !char_mind.key || istype(char_mind.current, /mob/new_player) || !char_mind.finished_chargen)
				// Just in case, delete this character from limbo.
				one_off.RemoveFromLimbo(char_mind.unique_id, LIMBO_MIND)
				continue
			// Check to see if the mobs are already being saved.
			if(!QDELETED(current_mob) && ((current_mob.z in SSpersistence.saved_levels) || (get_area(current_mob) in SSpersistence.saved_areas)))
				continue
			one_off.AddToLimbo(char_mind, char_mind.unique_id, LIMBO_MIND, char_mind.persistent_id, char_mind.key, FALSE)
		report_progress("Done adding player minds to limbo in [(REALTIMEOFDAY - time_start_limbo_minds) / (1 SECOND)]s.")
		sleep(5)

		report_progress("Wiping previous save..")
		sleep(5)
		var/time_start_wipe = REALTIMEOFDAY
		// Wipe the previous save.
		serializer.WipeSave()
		report_progress("Done wiping previous save in [(REALTIMEOFDAY - time_start_wipe) / (1 SECOND)]s.")
		sleep(5)

		//
		// 	ACTUAL SAVING SECTION
		//

		report_progress("Preparing z-levels for save..")
		sleep(5)
		var/time_start_zprepare = REALTIMEOFDAY
		// This will prepare z_level translations.
		var/list/z_transform = list()
		var/new_z_index = 1
		// First we find the highest non-dynamic z_level.
		for(var/z in global.using_map.station_levels)
			if(z in saved_levels)
				new_z_index = max(new_z_index, z)

		// Now we go through our saved levels and remap all of those.
		for(var/z in saved_levels)
			var/datum/persistence/load_cache/z_level/z_level = new()
			z_level.default_turf = get_base_turf(z)
			z_level.index = z
			if(z in global.using_map.station_levels)
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
				if("[T.z]" in global.overmap_sectors)
					var/obj/effect/overmap = global.overmap_sectors["[T.z]"]
					z_level.metadata = "[overmap.x],[overmap.y]"
				new_z_index++
				z_level.new_index = new_z_index
				z_transform["[T.z]"] = z_level

		new_z_index++
		// Now we rebuild our z_level metadata list into the serializer for it to remap everything for us.
		for(var/z in z_transform)
			var/datum/persistence/load_cache/z_level/z_level = z_transform[z]
			serializer.z_map["[z_level.index]"] = z_level.new_index
		serializer.z_index = new_z_index
		
		// Now we find all the area datums themselves that need to be saved, since keeping references on the turfs is a huge waste of space.
		var/list/areas_to_serialize = list()
		for(var/area/A in global.areas)
			if(istype(A, world.area))
				continue
			var/turf/T = locate() in A.contents
			// Because cross Z-level areas should not exist except on the planet, this should be ok.
			if(!T || !(T.z in saved_levels))
				continue
			areas_to_serialize |= A
		areas_to_serialize |= saved_areas
		var/datum/wrapper_holder/area_wrapper_holder = new(areas_to_serialize)
		serializer.Serialize(area_wrapper_holder)
		serializer.Commit()

		report_progress("Z-levels prepared for save in [(REALTIMEOFDAY - time_start_zprepare) / (1 SECOND)]s.")
		sleep(5)

		report_progress("Saving z-level turfs..")
		sleep(5)
		var/time_start_zsave = REALTIMEOFDAY
		// This will save all the turfs/world.
		var/index = 1
		var/progress = 0
		var/max_progress = length(saved_levels)
		for(var/z in saved_levels)
			var/default_turf = get_base_turf(z)
			for(var/x in 1 to world.maxx)
				for(var/y in 1 to world.maxy)
					// Get the thing to serialize and serialize it.
					var/turf/T = locate(x,y,z)
					// This if statement, while complex, checks to see if we should save this turf.
					// Turfs not saved become their default_turf after deserialization.
					if(!istype(T) || istype(T, default_turf) || !T.should_save)
						if(!istype(T) || !T.contents || !length(T.contents))
							continue
						var/should_skip = TRUE
						for(var/atom/A AS_ANYTHING in T.contents)
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

			serializer.Commit() // cleanup leftovers.
			serializer.CommitRefUpdates()
			++progress
			report_progress("Working.. [(progress * 100) / max_progress]%")
			sleep(3)

		index = 1
		report_progress("Z-levels turfs saved in [(REALTIMEOFDAY - time_start_zsave) / (1 SECOND)]s.")
		sleep(5)

		report_progress("Saving z-level areas..")
		sleep(5)
		var/time_start_zarea = REALTIMEOFDAY
		// Repeat much of the above code in order to save areas marked to be saved that are not in a saved z-level.
		for(var/area/A in saved_areas)
			for(var/turf/T in A)
				if(T.z in saved_levels)
					continue
				var/turf/default_turf = get_base_turf(T.z)
				if(!istype(T) || istype(T, default_turf))
					if(!istype(T) || !T.contents || !length(T.contents) || !T.should_save)
						continue
					var/should_skip = TRUE
					for(var/atom/AM AS_ANYTHING in T.contents)
						if(AM.should_save())
							should_skip = FALSE
							break // We found a thing that's worth saving.
					if(should_skip)
						continue // Skip this tile. Not worth saving.
				serializer.Serialize(T, null, T.z)

				// Don't save every single tile.
				// Batch them up to save time.
				if(index % 128 == 0)
					serializer.Commit()
					index = 1
				else
					index++

			serializer.Commit() // cleanup leftovers.

		// Insert our z-level remaps.
		serializer.save_z_level_remaps(z_transform)
		serializer.Commit()
		serializer.CommitRefUpdates()

		report_progress("Z-levels areas saved in [(REALTIMEOFDAY - time_start_zarea) / (1 SECOND)]s.")
		sleep(5)

		report_progress("Saving extensions...")
		// Now save all the extensions which have marked themselves to be saved.
		// As with areas, we create a dummy wrapper holder to hold these during load etc.
		var/datum/wrapper_holder/extension_wrapper_holder = new(saved_extensions)
		var/time_start_extensions = REALTIMEOFDAY
		serializer.Serialize(extension_wrapper_holder)
		serializer.Commit()

		report_progress("Extensions saved in [(REALTIMEOFDAY - time_start_extensions) / (1 SECOND)]s.")
		sleep(5)

		//
		//	CLEANUP SECTION
		//
		// Clear the refmaps/do other cleanup to end the save.
		serializer.Clear()
		// Clear the custom saved list used to keep list refs intact
		global.custom_saved_lists.Cut()
		// Reboot air subsystem.
		SSair.reboot()
		// Let people back in
		if(reallow) config.enter_allowed = 1
	catch (var/exception/e)
		to_world_log("Save failed on line [e.line], file [e.file] with message: '[e]'.")
	to_world("Save complete! Took [(world.timeofday-start)/ (1 SECOND)]s to save world.")
	saved_extensions.Cut() // Make extensions re-report if they want to be saved again.
	serializer._after_serialize()

	// Launch event for anything that needs to do cleanup post save.
	events_repository.raise_event(/decl/observ/world_saving_finish_event, src)

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
		//var/last_index = world.maxz
		for(var/datum/persistence/load_cache/z_level/z_level in serializer.resolver.z_levels)
			if(z_level.dynamic)
				INCREMENT_WORLD_Z_SIZE
				z_level.new_index = world.maxz
			else
				z_level.new_index = z_level.index
			to_world_log("Mapping Save Z ([z_level.index]) to World Z ([z_level.new_index]) with default turf ([z_level.default_turf]).")
			serializer.z_map["[z_level.index]"] = z_level.new_index
		to_world_log("Z-Levels loaded!")

		// This is a sort-of hack. We're going to go back and edit all of the thing_references to their new Z from the z_levels we just modified.
		for(var/thing_id in serializer.resolver.things)
			var/datum/persistence/load_cache/thing/thing = serializer.resolver.things[thing_id]
			thing.z = serializer.z_map["[thing.z]"]
		to_world_log("Dynamic z-levels populated!")

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

		to_world_log("Adding default turfs...")
		start = world.timeofday
		for(var/datum/persistence/load_cache/z_level/z_level in serializer.resolver.z_levels)
			if(z_level.default_turf && !ispath(z_level.default_turf, /turf/space))
				for(var/turf/T in block(locate(1, 1, z_level.new_index), locate(world.maxx, world.maxy, z_level.new_index)))
					if(turfs_loaded["([T.x], [T.y], [T.z])"])
						continue
					T.ChangeTurf(z_level.default_turf)
		to_world_log("Default turfs complete! Took [(world.timeofday-start)/10]s.")

		// Cleanup the cache. It uses a *lot* of memory.
		for(var/id in serializer.reverse_map)
			var/datum/T = serializer.reverse_map[id]
			T.after_deserialize()
		for(var/id in serializer.reverse_list_map)
			var/list/_list = serializer.reverse_list_map[id]
			for(var/element in _list)
				var/datum/T = element
				if(istype(T, /datum))
					T.after_deserialize()
				var/datum/TE
				try
					TE = _list[element]
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
	for(var/datum/wrapper/late/L AS_ANYTHING in late_wrappers)
		L.on_late_load()
	
	late_wrappers.Cut()
	if(new_db_connection)
		close_save_db_connection()

/datum/controller/subsystem/persistence/proc/AddSavedLevel(var/z)
	saved_levels |= z

/datum/controller/subsystem/persistence/proc/RemoveSavedLevel(var/z)
	if(z in global.using_map.saved_levels)
		return
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

/datum/controller/subsystem/persistence/proc/AddToLimbo(var/datum/thing, var/key, var/limbo_type, var/metadata, var/modify = TRUE)
	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection during Limbo Addition!")
		new_db_connection = TRUE
	. = one_off.AddToLimbo(thing, key, limbo_type, metadata, modify)
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
		limbo_removals += list(list(limbo_key, limbo_type))
	if(new_db_connection)
		close_save_db_connection()

// Get an object from its p_id via ref tracking. This will not always work if an object is asynchronously deserialized from others.
// This is also quite slow - if you're trying to locate many objects at once, it's best to use a single query for multiple objects.

/datum/controller/subsystem/persistence/proc/get_object_from_p_id(var/target_p_id)
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