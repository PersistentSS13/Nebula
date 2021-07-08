/datum/controller/subsystem/persistence
	name = "Persistence"
	init_order = SS_INIT_EARLY
	flags = SS_NO_FIRE

	var/save_exists			=	FALSE	// Whether or not a save exists in the DB
	var/in_loaded_world 	= 	FALSE	// Whether or not we're in a world that was loaded.

	var/list/saved_areas	= 	list()
	var/list/saved_levels 	= 	list()	// Saved levels are saved entirely and optimized with get_base_turf()
	var/rent_enabled = FALSE			// Whether or not rent will be required for created sectors.

	var/serializer/sql/serializer = new() // The serializer impl for actually saving.
	var/serializer/sql/one_off/one_off	= new() // The serializer impl for one off serialization/deserialization.

	var/loading_world = FALSE

/datum/controller/subsystem/persistence/Initialize()
	saved_levels = global.using_map.saved_levels

/datum/controller/subsystem/persistence/proc/SaveExists()
	if(save_exists)
		return save_exists
	var/DBQuery/query = dbcon.NewQuery("SELECT COUNT(*) FROM `thing`;")
	query.Execute()
	if(query.NextRow())
		save_exists = text2num(query.item[1]) > 0
		in_loaded_world = save_exists

/datum/controller/subsystem/persistence/proc/SaveWorld()
	// Collect the z-levels we're saving and get the turfs!
	to_world_log("Saving [LAZYLEN(SSpersistence.saved_levels)] z-levels. World size max ([world.maxx],[world.maxy])")
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
		while (SSair.state != SS_IDLE)
			stoplag()

		// Prepare all atmospheres to save.
		for(var/datum/pipe_network/net in SSmachines.pipenets)
			for(var/datum/pipeline/line in net.line_members)
				line.temporarily_store_air()
		while (SSair.zones.len)
			var/zone/zone = SSair.zones[SSair.zones.len]
			SSair.zones.len--
			zone.c_invalidate()
		
		// Find all the minds gameworld and add any player characters to the limbo list.
		for(var/datum/mind/char_mind in global.player_minds)
			var/mob/current_mob = char_mind.current
			if(!current_mob || !char_mind.key || istype(char_mind.current, /mob/new_player) || !char_mind.finished_chargen)
				// Just in case, delete this character from limbo.
				RemoveFromLimbo(char_mind.unique_id, LIMBO_MIND)
				continue
			// Check to see if the mobs are already being saved.
			if(!QDELETED(current_mob) && ((current_mob.z in SSpersistence.saved_levels) || (get_area(current_mob) in SSpersistence.saved_areas)))
				continue
			AddToLimbo(char_mind, char_mind.unique_id, LIMBO_MIND, char_mind.persistent_id, char_mind.key, FALSE)

		// Wipe the previous save.
		serializer.WipeSave()

		//
		// 	ACTUAL SAVING SECTION
		//
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
				if("[T.z]" in map_sectors)
					var/obj/effect/overmap = map_sectors["[T.z]"]
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
		// Locate a turf that will always be saved to move or create the area holder
		var/turf/saved_turf = locate(world.maxx/2, world.maxy/2, global.using_map.saved_levels[1])
		if(!global.area_holder)
			global.area_holder = new /atom/movable/area_holder(saved_turf)
		area_holder.areas = areas_to_serialize
		area_holder.forceMove(saved_turf)
		// Just in case, serialize the holder. No need to commit ref updates because the areas are wrapped.
		serializer.Serialize(area_holder)
		serializer.Commit()
		area_holder.areas.Cut()

		// This will save all the turfs/world.
		var/index = 1
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
						for(var/atom/movable/AM in T.contents)
							if(AM.should_save())
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

					// Prevent the whole game from locking up.
				CHECK_TICK
			serializer.Commit() // cleanup leftovers.
			serializer.CommitRefUpdates()

		index = 1

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
					for(var/atom/movable/AM in T.contents)
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

				// Prevent the whole game from locking up.
				CHECK_TICK
			serializer.Commit() // cleanup leftovers.

		// Insert our z-level remaps.
		var/list/z_inserts = list()
		var/z_insert_index = 1
		for(var/z in z_transform)
			var/datum/persistence/load_cache/z_level/z_level = z_transform[z]
			z_inserts += "([z_insert_index],[z_level.new_index],[z_level.dynamic],'[z_level.default_turf]','[z_level.metadata]')"
			z_insert_index++
		var/DBQuery/query = dbcon.NewQuery("INSERT INTO `z_level` (`id`,`z`,`dynamic`,`default_turf`,`metadata`) VALUES[jointext(z_inserts, ",")]")
		query.Execute()
		if(query.ErrorMsg())
			to_world_log("Z_LEVEL SERIALIZATION FAILED: [query.ErrorMsg()].")

		serializer.Commit()
		serializer.CommitRefUpdates()

		//
		//	CLEANUP SECTION
		//
		// Clear the refmaps/do other cleanup to end the save.
		serializer.Clear()
		// Reboot air subsystem.
		SSair.reboot()
		// Let people back in
		if(reallow) config.enter_allowed = 1
	catch (var/exception/e)
		to_world_log("Save failed on line [e.line], file [e.file] with message: '[e]'.")
	to_world("Save complete! Took [(world.timeofday-start)/10]s to save world.")
	
	// Launch event for anything that needs to do cleanup post save.
	events_repository.raise_event(/decl/observ/world_saving_finish_event, src)

/datum/controller/subsystem/persistence/proc/LoadWorld()
	try
		// Loads all data in as part of a version.
		establish_db_connection()
		if(!dbcon.IsConnected())
			return

		var/DBQuery/query = dbcon.NewQuery("SELECT COUNT(*) FROM `thing`;")
		query.Execute()
		if(query.NextRow())
			// total_entries = text2num(query.item[1])
			to_world_log("Loading [query.item[1]] things from world save.")

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
				if(!T.x || !T.y || !T.z)
					continue // This isn't a turf. We can skip it.
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
				try
					var/datum/TE = _list[element]
					if(istype(TE, /datum))
						TE.after_deserialize()
				catch // Ignore/eat error. This is just testing for dicts.

		serializer.resolver.clear_cache()
		serializer.CommitRefUpdates() // Clean up any leftovers.
		serializer.Clear()

		// Tell the atoms subsystem to not populate parts.
		//if(turfs_loaded)
			//SSatoms.adjust_init_arguments = TRUE
	catch(var/exception/e)
		to_world_log("Load failed on line [e.line], file [e.file] with message: '[e]'.")

	loading_world = FALSE

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

// Adds the passed object into limbo, saving it into the limbo tables which remain in the database outside of the world.
// This does not delete the object from the world, which should be handled seperately.
/datum/controller/subsystem/persistence/proc/AddToLimbo(var/datum/thing, var/key, var/limbo_type, var/metadata, var/modify = TRUE)

	// Check to see if this thing was already placed into limbo. If so, we go ahead and remove the thing from limbo first before reserializing.
	// When this occurs, it's possible things will be dropped from the database. Avoid serializing things into limbo which will remain in the game world.

	key = sanitizeSQL(key)
	limbo_type = sanitizeSQL(limbo_type)
	metadata = sanitizeSQL(metadata)

	// The 'limbo_assoc' column in the database relates every thing, thing_var, and list_element to an instance of limbo insertion.
	// While it uses the same PERSISTENT_ID format, it's not related to any datum's PERSISTENT_ID.
	var/limbo_assoc = PERSISTENT_ID
	var/DBQuery/existing_query = dbcon.NewQuery("SELECT 1 FROM `limbo` WHERE `key` = '[key]' AND `type` = '[limbo_type]'")
	existing_query.Execute()

	var/DBQuery/insert_query
	if(existing_query.NextRow()) // There was already something in limbo with this type.
		if(!modify)
			return
		RemoveFromLimbo(key, limbo_type)

	// Get the persistent ID for the "parent" object.
	if(!thing.persistent_id)
		thing.persistent_id = PERSISTENT_ID
	// Insert into the limbo table, a metadata holder that allows for access to the limbo_assoc key by 'type' and 'key'.
	insert_query = dbcon.NewQuery("INSERT INTO `limbo` (`key`,`type`,`p_id`,`metadata`,`limbo_assoc`) VALUES('[key]', '[limbo_type]', '[thing.persistent_id]', '[metadata]', '[limbo_assoc]')")
	insert_query.Execute()
	if(insert_query.ErrorMsg())
		to_world_log("LIMBO ADDITION FAILED: [insert_query.ErrorMsg()].")
	
	one_off.update_indices()
	one_off.SerializeDatum(thing, null, limbo_assoc)
	one_off.Commit()
	one_off.Clear()

// Removes an object from the limbo table. This should always be called after an object is deserialized from limbo into the world.
/datum/controller/subsystem/persistence/proc/RemoveFromLimbo(var/limbo_key, var/limbo_type)
	var/DBQuery/limbo_query = dbcon.NewQuery("SELECT `limbo_assoc` FROM `limbo` WHERE `key` = '[limbo_key]' AND `type` = '[limbo_type]';")
	var/limbo_assoc
	limbo_query.Execute()
	if(limbo_query.ErrorMsg())
		to_world_log("LIMBO QUERY FAILED DURING LIMBO REMOVAL: [limbo_query.ErrorMsg()].")
	// Acquire the list and thing rows that need to be deleted.
	if(limbo_query.NextRow())
		var/list/limbo_items = limbo_query.GetRowData()
		limbo_assoc = limbo_items["limbo_assoc"]
	else
		return // The object wasn't in limbo to begin with.
	var/DBQuery/delete_query
	delete_query = dbcon.NewQuery("DELETE FROM `limbo_thing` WHERE `limbo_assoc` = '[limbo_assoc]';")
	delete_query.Execute()
	if(delete_query.ErrorMsg())
		to_world_log("LIMBO DELETION OF THING(S) FAILED: [delete_query.ErrorMsg()].")
	delete_query = dbcon.NewQuery("DELETE FROM `limbo_thing_var` WHERE `limbo_assoc` = '[limbo_assoc]';")
	delete_query.Execute()
	if(delete_query.ErrorMsg())
		to_world_log("LIMBO DELETION OF VAR(S) FAILED: [delete_query.ErrorMsg()].")
	delete_query = dbcon.NewQuery("DELETE FROM `limbo_list_element` WHERE `limbo_assoc` = '[limbo_assoc]';")
	delete_query.Execute()
	if(delete_query.ErrorMsg())
		to_world_log("LIMBO DELETION OF LIST ELEMENT(S) FAILED: [delete_query.ErrorMsg()].")
	delete_query = dbcon.NewQuery("DELETE FROM `limbo` WHERE `limbo_assoc` = '[limbo_assoc]';")
	delete_query.Execute()

/datum/controller/subsystem/persistence/proc/DeserializeOneOff(var/limbo_key, var/limbo_type, var/remove_after = TRUE)
	// Hold off on initialization until everthing is finished loading.
	var/DBQuery/limbo_query = dbcon.NewQuery("SELECT `p_id` FROM `limbo` WHERE `key` = '[limbo_key]' AND `type` = '[limbo_type]';")
	limbo_query.Execute()
	if(limbo_query.ErrorMsg())
		to_world_log("DESERIALIZE ONE-OFF FAILED: [limbo_query.ErrorMsg()].")
	var/limbo_p_id
	if(limbo_query.NextRow())
		var/list/limbo_items = limbo_query.GetRowData()
		limbo_p_id = limbo_items["p_id"]
	SSatoms.map_loader_begin()
	one_off.update_load_cache(limbo_key, limbo_type)
	var/datum/target = one_off.QueryAndDeserializeDatum(limbo_p_id)

	// Copy pasta for calling after_deserialize on everything we just deserialized.
	for(var/id in one_off.reverse_map)
		var/datum/T = one_off.reverse_map[id]
		T.after_deserialize()
	
	// Start initializing whatever we deserialized.
	SSatoms.map_loader_stop()
	SSatoms.InitializeAtoms()
	one_off.CommitRefUpdates()
	one_off.Clear()

	if(remove_after)
		RemoveFromLimbo(limbo_key, limbo_type)
	return target

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