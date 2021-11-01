// This serializer is used for individual, non-game world serialization of objects. The serialized objects themselves are put into the limbo
// tables of the database. Uniquely, this serializer is created and destroyed on demand in order to ensure objects are serialized with the proper
// limbo associative key.

/serializer/sql/one_off
	autocommit = FALSE

// Override to include limbo_assoc keys in the insert, and to disable ref insertion.
// In this instance, object_parent is the limbo_assoc key.
/serializer/sql/one_off/SerializeDatum(var/datum/object, var/object_parent, var/limbo_assoc)
	if(isnull(object) || !object.should_save)
		return

	if(isnull(global.saved_vars[object.type]))
		return // EXPERIMENTAL. Don't save things without a whitelist.

	var/existing = thing_map["\ref[object]"]
	if (existing)
#ifdef SAVE_DEBUG
		to_world_log("(SerializeThing-Resv) \ref[thing] to [existing]")
		CHECK_TICK
#endif
		return existing

	// Thing didn't exist. Create it.
	var/p_i = object.persistent_id ? object.persistent_id : PERSISTENT_ID
	object.persistent_id = p_i

	var/x = 0
	var/y = 0
	var/z = 0

	object.before_save() // Before save hook.
	if(ispath(object.type, /turf))
		var/turf/T = object
		x = T.x
		y = T.y
		if(nongreedy_serialize && !("[T.z]" in z_map))
			return null
		try
			z = z_map["[T.z]"]
		catch
			z = T.z

#ifdef SAVE_DEBUG
	to_world_log("(SerializeThingLimbo) ('[p_i]','[object.type]',[x],[y],[z],'[limbo_assoc]')")
#endif
	thing_inserts.Add("('[p_i]','[object.type]',[x],[y],[z],'[limbo_assoc]')")
	inserts_since_commit++
	thing_map["\ref[object]"] = p_i

	for(var/V in object.get_saved_vars())
		if(!issaved(object.vars[V]))
			to_world_log("BAD SAVED VARIABLE : '[object.type]' cannot have its '[V]' variable saved, since its marked as not saved!")
			continue
		var/VV = object.vars[V]
		var/VT = SERIALIZER_TYPE_VAR
#ifdef SAVE_DEBUG
		to_world_log("(SerializeThingLimboVar) [V]")
#endif
		if(VV == initial(object.vars[V]))
			continue

		if(islist(VV) && !isnull(VV))
			// Complex code for serializing lists...
			if(length(VV) == 0)
				// Another optimization. Don't need to serialize lists
				// that have 0 elements.
#ifdef SAVE_DEBUG
				to_world_log("(SerializeThingLimboVar-Skip) Zero Length List")
#endif
				continue
			VT = SERIALIZER_TYPE_LIST
			VV = SerializeList(VV, object, limbo_assoc)
			if(isnull(VV))
#ifdef SAVE_DEBUG
				to_world_log("(SerializeThingLimboVar-Skip) Null List")
#endif
				continue
		else if (isnum(VV))
			VT = SERIALIZER_TYPE_NUM
		else if (istext(VV))
			VT = SERIALIZER_TYPE_TEXT
			VV = byond2utf8(VV)
		else if (ispath(VV) || IS_PROC(VV)) // After /datum check to avoid high-number obj refs
			VT = SERIALIZER_TYPE_PATH
		else if (isfile(VV))
			VT = SERIALIZER_TYPE_FILE
		else if (isnull(VV))
			VT = SERIALIZER_TYPE_NULL
		else if(get_wrapper(VV))
			VT = SERIALIZER_TYPE_WRAPPER
			var/wrapper_path = get_wrapper(VV)
			var/datum/wrapper/GD = new wrapper_path
			if(!GD)
				// Missing wrapper!
				continue
			GD.on_serialize(VV)
			if(!GD.key)
				// Wrapper is null.
				continue
			VV = flattener.SerializeDatum(GD)
		else if (istype(VV, /datum))
			var/datum/VD = VV
			if(!VD.should_save(object))
				continue
			// Reference only vars do not serialize their target objects, and act only as pointers.
			if(V in global.reference_only_vars)
				VT = SERIALIZER_TYPE_DATUM
				VV = VD.persistent_id ? VD.persistent_id : PERSISTENT_ID
			// Serialize it complex-like, baby.
			else if(should_flatten(VV))
				VT = SERIALIZER_TYPE_DATUM_FLAT // If we flatten an object, the var becomes json. This saves on indexes for simple objects.
				VV = flattener.SerializeDatum(VV)
			else
				VT = SERIALIZER_TYPE_DATUM
				VV = SerializeDatum(VV, null, limbo_assoc)
		else
			// We don't know what this is. Skip it.
#ifdef SAVE_DEBUG
			to_world_log("(SerializeThingLimboVar-Skip) Unknown Var")
#endif
			continue
		VV = sanitizeSQL("[VV]")
#ifdef SAVE_DEBUG
		to_world_log("(SerializeThingLimboVar-Done) ('[p_i]','[V]','[VT]',\"[VV]\", '[limbo_assoc]')")
#endif
		var_inserts.Add("('[p_i]','[V]','[VT]',\"[VV]\", '[limbo_assoc]')")
		inserts_since_commit++
	object.after_save() // After save hook.
	if(inserts_since_commit > autocommit_threshold)
		Commit()
	return p_i

// Serialize a list, using the limbo_assoc key.
/serializer/sql/one_off/SerializeList(var/list/_list, var/list_parent, var/limbo_assoc)
	if(isnull(_list) || !islist(_list))
		return

	var/list/existing = list_map["\ref[_list]"]
	if(existing)
#ifdef SAVE_DEBUG
		to_world_log("(SerializeListLimbo-Resv) \ref[_list] to [existing]")
		CHECK_TICK
#endif
		return existing

	var/found_element = FALSE
	var/list_ref = "\ref[_list]"
	var/l_i = "[list_index]"
	list_index++
	inserts_since_commit++
	list_map[list_ref] = l_i
	for(var/key in _list)
		var/ET = SERIALIZER_TYPE_NULL
		var/KT = SERIALIZER_TYPE_NULL
		var/KV = key
		var/EV = null
		if(!isnum(key))
			try
				EV = _list[key]
			catch
				EV = null // NBD... No value.
		if (isnull(key))
			KT = SERIALIZER_TYPE_NULL
		else if(isnum(key))
			KT = SERIALIZER_TYPE_NUM
		else if (istext(key))
			KT = SERIALIZER_TYPE_TEXT
			key = byond2utf8(key)
		else if (ispath(key) || IS_PROC(key))
			KT = SERIALIZER_TYPE_PATH
		else if (isfile(key))
			KT = SERIALIZER_TYPE_FILE
		else if (islist(key))
			KT = SERIALIZER_TYPE_LIST
			KV = SerializeList(key, null, limbo_assoc)
		else if(get_wrapper(key))
			KT = SERIALIZER_TYPE_WRAPPER
			var/wrapper_path = get_wrapper(key)
			var/datum/wrapper/GD = new wrapper_path
			if(!GD)
				// Missing wrapper!
				continue
			GD.on_serialize(key)
			if(!GD.key)
				// Wrapper is null.
				continue
			KV = flattener.SerializeDatum(GD)
		else if(istype(key, /datum))
			var/datum/key_d = key
			if(!key_d.should_save(list_parent))
				continue
			if(should_flatten(KV))
				KT = SERIALIZER_TYPE_DATUM_FLAT // If we flatten an object, the var becomes json. This saves on indexes for simple objects.
				KV = flattener.SerializeDatum(KV)
			else
				KT = SERIALIZER_TYPE_DATUM
				KV = SerializeDatum(KV, null, limbo_assoc)
		else
#ifdef SAVE_DEBUG
			to_world_log("(SerializeListLimboElem-Skip) Unknown Key. Value: [key]")
#endif
			continue

		if(!isnull(key) && !isnull(EV))
			if(isnum(EV))
				ET = SERIALIZER_TYPE_NUM
			else if (istext(EV))
				ET = SERIALIZER_TYPE_TEXT
				EV = byond2utf8(EV)
			else if (isnull(EV))
				ET = SERIALIZER_TYPE_NULL
			else if (ispath(EV) || IS_PROC(EV))
				ET = SERIALIZER_TYPE_PATH
			else if (isfile(EV))
				ET = SERIALIZER_TYPE_FILE
			else if (islist(EV))
				ET = SERIALIZER_TYPE_LIST
				EV = SerializeList(EV, null, limbo_assoc)
			else if(get_wrapper(EV))
				ET = SERIALIZER_TYPE_WRAPPER
				var/wrapper_path = get_wrapper(EV)
				var/datum/wrapper/GD = new wrapper_path
				if(!GD)
					// Missing wrapper!
					continue
				GD.on_serialize(EV)
				if(!GD.key)
					// Wrapper is null.
					continue
				EV = flattener.SerializeDatum(GD)
			else if (istype(EV, /datum))
				if(should_flatten(EV))
					ET = SERIALIZER_TYPE_DATUM_FLAT // If we flatten an object, the var becomes json. This saves on indexes for simple objects.
					EV = flattener.SerializeDatum(EV)
				else
					ET = SERIALIZER_TYPE_DATUM
					EV = SerializeDatum(EV, null, limbo_assoc)
			else
				// Don't know what this is. Skip it.
#ifdef SAVE_DEBUG
				to_world_log("(SerializeListLimboElem-Skip) Unknown Value")
#endif
				continue
		KV = sanitizeSQL("[KV]")
		EV = sanitizeSQL("[EV]")
#ifdef SAVE_DEBUG
		if(verbose_logging)
			to_world_log("(SerializeListLimboElem-Done) ([l_i],\"[KV]\",'[KT]',\"[EV]\",\"[ET]\",'[limbo_assoc]')")
#endif	
		found_element = TRUE
		element_inserts.Add("([l_i],\"[KV]\",'[KT]',\"[EV]\",\"[ET]\",'[limbo_assoc]')")
		inserts_since_commit++
	
	if(!found_element) // There wasn't anything that actually needed serializing in this list, so return null.
		list_index--
		list_map -= list_ref
		return null
	return l_i

/serializer/sql/one_off/Commit()
	if(!establish_save_db_connection())
		CRASH("One-Off Serializer: Couldn't establish DB connection!")

	var/DBQuery/query
	var/exception/last_except
	try
		if(length(thing_inserts) > 0)
			query = dbcon_save.NewQuery("INSERT INTO `[SQLS_TABLE_LIMBO_DATUM]`(`p_id`,`type`,`x`,`y`,`z`,`limbo_assoc`) VALUES[jointext(thing_inserts, ",")] ON DUPLICATE KEY UPDATE `p_id` = `p_id`")
			SQLS_EXECUTE_AND_REPORT_ERROR(query, "LIMBO THING SERIALIZATION FAILED:")

		if(length(var_inserts) > 0)
			query = dbcon_save.NewQuery("INSERT INTO `[SQLS_TABLE_LIMBO_DATUM_VARS]`(`thing_id`,`key`,`type`,`value`,`limbo_assoc`) VALUES[jointext(var_inserts, ",")]")
			SQLS_EXECUTE_AND_REPORT_ERROR(query, "LIMBO VAR SERIALIZATION FAILED:")

		if(length(element_inserts) > 0) 
			tot_element_inserts += length(element_inserts)
			query = dbcon_save.NewQuery("INSERT INTO `[SQLS_TABLE_LIMBO_LIST_ELEM]`(`list_id`,`key`,`key_type`,`value`,`value_type`,`limbo_assoc`) VALUES[jointext(element_inserts, ",")]")
			SQLS_EXECUTE_AND_REPORT_ERROR(query, "LIMBO ELEMENT SERIALIZATION FAILED:")

	catch (var/exception/e)
		if(istype(e, /exception/sql_connection))
			last_except = e //Throw it after we clean up
		else
			to_world_log("Limbo Serializer Failed")
			to_world_log(e)

	thing_inserts.Cut(1)
	var_inserts.Cut(1)
	element_inserts.Cut(1)
	inserts_since_commit = 0

	//Throw after we cleanup
	if(last_except)
		throw last_except

// Update the indices since we can't be certain what the next ID is across saves.
// TODO: Replace list indices in general with persistent ID analogues
/serializer/sql/one_off/proc/update_indices()
	var/DBQuery/list_id_query = dbcon_save.NewQuery("SELECT MAX(list_id) FROM [SQLS_TABLE_LIMBO_LIST_ELEM];")
	SQLS_EXECUTE_AND_REPORT_ERROR(list_id_query, "LIST ID QUERY FAILED:")
	if(list_id_query.NextRow())
		var/list/id_row = list_id_query.GetRowData()
		list_index = text2num(id_row["MAX(list_id)"]) + 1

/serializer/sql/one_off/proc/update_load_cache(var/limbo_key, var/limbo_type)
	resolver.clear_cache()
	var/DBQuery/limbo_query = dbcon_save.NewQuery("SELECT `limbo_assoc` FROM `[SQLS_TABLE_LIMBO]` WHERE `key` = '[limbo_key]' AND `type` = '[limbo_type]';")
	SQLS_EXECUTE_AND_REPORT_ERROR(limbo_query, "LIMBO QUERY FAILED FOR UPDATING LOAD CACHE:")
	var/limbo_assoc
	if(limbo_query.NextRow())
		var/list/limbo_items = limbo_query.GetRowData()
		limbo_assoc = limbo_items["limbo_assoc"]

	var/list/ref_things = list()
	limbo_query = dbcon_save.NewQuery("SELECT `value` FROM `[SQLS_TABLE_LIMBO_DATUM_VARS]` WHERE `type` = 'OBJ' AND `limbo_assoc` = '[limbo_assoc]';")
	SQLS_EXECUTE_AND_REPORT_ERROR(limbo_query, "LIMBO QUERY FAILED FOR UPDATING LOAD CACHE:")

	while(limbo_query.NextRow())
		var/list/items = limbo_query.GetRowData()
		ref_things |= "'[items["value"]]'"

	// This is annoying, but we have to check against the game world refs to prevent duplication, as the limbo tables do not
	// normally track references.
	var/DBQuery/world_query = dbcon_save.NewQuery("SELECT `p_id`, `ref` FROM `[SQLS_TABLE_DATUM]` WHERE `p_id` IN ([jointext(ref_things, ", ")]);")
	SQLS_EXECUTE_AND_REPORT_ERROR(world_query, "LIMBO WORLD QUERY FAILED FOR UPDATING LOAD CACHE:")

	while(world_query.NextRow())
		var/list/items = world_query.GetRowData()
		var/datum/existing = locate(items["ref"])
		if(existing && !QDELETED(existing) && existing.persistent_id == items["p_id"]) // Check to see if the thing already exists in the gameworld by ref lookup.
			reverse_map[items["p_id"]] = existing
			continue

	// Now we re-execute and return to the limbo query.
	limbo_query = dbcon_save.NewQuery("SELECT `p_id`, `type`, `x`, `y`, `z` FROM `[SQLS_TABLE_LIMBO_DATUM]` WHERE `limbo_assoc` = '[limbo_assoc]';")
	SQLS_EXECUTE_AND_REPORT_ERROR(limbo_query, "LIMBO QUERY FAILED FOR UPDATING LOAD CACHE:")

	while(limbo_query.NextRow())
		var/list/items = limbo_query.GetRowData()
		if(reverse_map[items["p_id"]])
			continue
		var/datum/persistence/load_cache/thing/T = new(items)
		resolver.things[items["p_id"]] = T
		resolver.things_cached++

	limbo_query = dbcon_save.NewQuery("SELECT `thing_id`,`key`,`type`,`value` FROM `[SQLS_TABLE_LIMBO_DATUM_VARS]` WHERE `limbo_assoc` = '[limbo_assoc]';")
	SQLS_EXECUTE_AND_REPORT_ERROR(limbo_query, "LIMBO QUERY FAILED FOR UPDATING LOAD CACHE:")

	while(limbo_query.NextRow())
		var/items = limbo_query.GetRowData()
		var/datum/persistence/load_cache/thing_var/V = new(items)
		var/datum/persistence/load_cache/thing/T = resolver.things[items["thing_id"]]
		if(T)
			T.thing_vars.Add(V)
			resolver.vars_cached++

	limbo_query = dbcon_save.NewQuery("SELECT `list_id`,`key`,`key_type`,`value`,`value_type` FROM `[SQLS_TABLE_LIMBO_LIST_ELEM]` WHERE `limbo_assoc` = '[limbo_assoc]';")
	SQLS_EXECUTE_AND_REPORT_ERROR(limbo_query, "LIMBO QUERY FAILED FOR UPDATING LOAD CACHE:")

	while(limbo_query.NextRow())
		var/items = limbo_query.GetRowData()
		var/datum/persistence/load_cache/list_element/element = new(items)
		LAZYADD(resolver.lists["[items["list_id"]]"], element)
		resolver.lists_cached++

/serializer/sql/one_off/proc/AddToLimbo(var/datum/thing, var/key, var/limbo_type, var/metadata, var/modify = TRUE)

	// Check to see if this thing was already placed into limbo. If so, we go ahead and remove the thing from limbo first before reserializing.
	// When this occurs, it's possible things will be dropped from the database. Avoid serializing things into limbo which will remain in the game world.

	key = sanitizeSQL(key)
	limbo_type = sanitizeSQL(limbo_type)
	metadata = sanitizeSQL(metadata)

	// The 'limbo_assoc' column in the database relates every thing, thing_var, and list_element to an instance of limbo insertion.
	// While it uses the same PERSISTENT_ID format, it's not related to any datum's PERSISTENT_ID.
	var/limbo_assoc = PERSISTENT_ID
	var/DBQuery/existing_query = dbcon_save.NewQuery("SELECT 1 FROM `[SQLS_TABLE_LIMBO]` WHERE `key` = '[key]' AND `type` = '[limbo_type]'")
	SQLS_EXECUTE_AND_REPORT_ERROR(existing_query, "LIMBO SELECT KEY FAILED:")
	if(existing_query.NextRow()) // There was already something in limbo with this type.
		if(!modify)
			return
		RemoveFromLimbo(key, limbo_type)

	// Get the persistent ID for the "parent" object.
	if(!thing.persistent_id)
		thing.persistent_id = PERSISTENT_ID
	// Insert into the limbo table, a metadata holder that allows for access to the limbo_assoc key by 'type' and 'key'.
	var/DBQuery/insert_query
	insert_query = dbcon_save.NewQuery("INSERT INTO `[SQLS_TABLE_LIMBO]` (`key`,`type`,`p_id`,`metadata`,`limbo_assoc`) VALUES('[key]', '[limbo_type]', '[thing.persistent_id]', '[metadata]', '[limbo_assoc]')")
	SQLS_EXECUTE_AND_REPORT_ERROR(insert_query, "LIMBO ADDITION FAILED:")
	
	update_indices()
	SerializeDatum(thing, null, limbo_assoc)
	Commit()
	Clear()

// Removes an object from the limbo table. This should always be called after an object is deserialized from limbo into the world.
/serializer/sql/one_off/proc/RemoveFromLimbo(var/limbo_key, var/limbo_type)
	var/DBQuery/limbo_query = dbcon_save.NewQuery("SELECT `limbo_assoc` FROM `[SQLS_TABLE_LIMBO]` WHERE `key` = '[limbo_key]' AND `type` = '[limbo_type]';")
	var/limbo_assoc
	SQLS_EXECUTE_AND_REPORT_ERROR(limbo_query, "LIMBO QUERY FAILED DURING LIMBO REMOVAL:")

	// Acquire the list and thing rows that need to be deleted.
	if(limbo_query.NextRow())
		var/list/limbo_items = limbo_query.GetRowData()
		limbo_assoc = limbo_items["limbo_assoc"]
	else
		return // The object wasn't in limbo to begin with.
	var/DBQuery/delete_query
	delete_query = dbcon_save.NewQuery("DELETE FROM `[SQLS_TABLE_LIMBO_DATUM]` WHERE `limbo_assoc` = '[limbo_assoc]';")
	SQLS_EXECUTE_AND_REPORT_ERROR(delete_query, "LIMBO DELETION OF THING(S) FAILED:")

	delete_query = dbcon_save.NewQuery("DELETE FROM `[SQLS_TABLE_LIMBO_DATUM_VARS]` WHERE `limbo_assoc` = '[limbo_assoc]';")
	SQLS_EXECUTE_AND_REPORT_ERROR(delete_query, "LIMBO DELETION OF VAR(S) FAILED:")

	delete_query = dbcon_save.NewQuery("DELETE FROM `[SQLS_TABLE_LIMBO_LIST_ELEM]` WHERE `limbo_assoc` = '[limbo_assoc]';")
	SQLS_EXECUTE_AND_REPORT_ERROR(delete_query, "LIMBO DELETION OF LIST ELEMENT(S) FAILED:")

	delete_query = dbcon_save.NewQuery("DELETE FROM `[SQLS_TABLE_LIMBO]` WHERE `limbo_assoc` = '[limbo_assoc]';")
	SQLS_EXECUTE_AND_REPORT_ERROR(delete_query, "LIMBO DELETION FROM LIMBO TABLE FAILED:")


/serializer/sql/one_off/proc/DeserializeOneOff(var/limbo_key, var/limbo_type)
	// Hold off on initialization until everthing is finished loading.
	var/DBQuery/limbo_query = dbcon_save.NewQuery("SELECT `p_id` FROM `[SQLS_TABLE_LIMBO]` WHERE `key` = '[limbo_key]' AND `type` = '[limbo_type]';")
	SQLS_EXECUTE_AND_REPORT_ERROR(limbo_query, "DESERIALIZE ONE-OFF FAILED:")
	var/limbo_p_id
	if(limbo_query.NextRow())
		var/list/limbo_items = limbo_query.GetRowData()
		limbo_p_id = limbo_items["p_id"]
	SSatoms.map_loader_begin()
	update_load_cache(limbo_key, limbo_type)
	var/datum/target = QueryAndDeserializeDatum(limbo_p_id)

	// Copy pasta for calling after_deserialize on everything we just deserialized.
	for(var/id in reverse_map)
		var/datum/T = reverse_map[id]
		T.after_deserialize()
	
	// Start initializing whatever we deserialized.
	SSatoms.map_loader_stop()
	SSatoms.InitializeAtoms()
	CommitRefUpdates()
	Clear()
	return target
