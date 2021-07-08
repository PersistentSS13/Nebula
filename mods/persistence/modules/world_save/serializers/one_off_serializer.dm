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
			continue
		var/VV = object.vars[V]
		var/VT = "VAR"
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
			VT = "LIST"
			VV = SerializeList(VV, object, limbo_assoc)
			if(isnull(VV))
#ifdef SAVE_DEBUG
				to_world_log("(SerializeThingLimboVar-Skip) Null List")
#endif
				continue
		else if (isnum(VV))
			VT = "NUM"
		else if (istext(VV))
			VT = "TEXT"
			VV = byond2utf8(VV)
		else if (ispath(VV) || IS_PROC(VV)) // After /datum check to avoid high-number obj refs
			VT = "PATH"
		else if (isfile(VV))
			VT = "FILE"
		else if (isnull(VV))
			VT = "NULL"
		else if(get_wrapper(VV))
			VT = "WRAP"
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
				VT = "OBJ"
				VV = VD.persistent_id ? VD.persistent_id : PERSISTENT_ID
			// Serialize it complex-like, baby.
			else if(should_flatten(VV))
				VT = "FLAT_OBJ" // If we flatten an object, the var becomes json. This saves on indexes for simple objects.
				VV = flattener.SerializeDatum(VV)
			else
				VT = "OBJ"
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
		var/ET = "NULL"
		var/KT = "NULL"
		var/KV = key
		var/EV = null
		if(!isnum(key))
			try
				EV = _list[key]
			catch
				EV = null // NBD... No value.
		if (isnull(key))
			KT = "NULL"
		else if(isnum(key))
			KT = "NUM"
		else if (istext(key))
			KT = "TEXT"
			key = byond2utf8(key)
		else if (ispath(key) || IS_PROC(key))
			KT = "PATH"
		else if (isfile(key))
			KT = "FILE"
		else if (islist(key))
			KT = "LIST"
			KV = SerializeList(key, null, limbo_assoc)
		else if(get_wrapper(key))
			KT = "WRAP"
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
				KT = "FLAT_OBJ" // If we flatten an object, the var becomes json. This saves on indexes for simple objects.
				KV = flattener.SerializeDatum(KV)
			else
				KT = "OBJ"
				KV = SerializeDatum(KV, null, limbo_assoc)
		else
#ifdef SAVE_DEBUG
			to_world_log("(SerializeListLimboElem-Skip) Unknown Key. Value: [key]")
#endif
			continue

		if(!isnull(key) && !isnull(EV))
			if(isnum(EV))
				ET = "NUM"
			else if (istext(EV))
				ET = "TEXT"
				EV = byond2utf8(EV)
			else if (isnull(EV))
				ET = "NULL"
			else if (ispath(EV) || IS_PROC(EV))
				ET = "PATH"
			else if (isfile(EV))
				ET = "FILE"
			else if (islist(EV))
				ET = "LIST"
				EV = SerializeList(EV, null, limbo_assoc)
			else if(get_wrapper(EV))
				ET = "WRAP"
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
					ET = "FLAT_OBJ" // If we flatten an object, the var becomes json. This saves on indexes for simple objects.
					EV = flattener.SerializeDatum(EV)
				else
					ET = "OBJ"
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
	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	var/DBQuery/query
	try
		if(length(thing_inserts) > 0)
			query = dbcon.NewQuery("INSERT INTO `limbo_thing`(`p_id`,`type`,`x`,`y`,`z`,`limbo_assoc`) VALUES[jointext(thing_inserts, ",")] ON DUPLICATE KEY UPDATE `p_id` = `p_id`")
			query.Execute()
			if(query.ErrorMsg())
				to_world_log("LIMBO THING SERIALIZATION FAILED: [query.ErrorMsg()].")
		if(length(var_inserts) > 0)
			query = dbcon.NewQuery("INSERT INTO `limbo_thing_var`(`thing_id`,`key`,`type`,`value`,`limbo_assoc`) VALUES[jointext(var_inserts, ",")]")
			query.Execute()
			if(query.ErrorMsg())
				to_world_log("LIMBO VAR SERIALIZATION FAILED: [query.ErrorMsg()].")
		if(length(element_inserts) > 0) 
			tot_element_inserts += length(element_inserts)
			query = dbcon.NewQuery("INSERT INTO `limbo_list_element`(`list_id`,`key`,`key_type`,`value`,`value_type`,`limbo_assoc`) VALUES[jointext(element_inserts, ",")]")
			query.Execute()
			if(query.ErrorMsg())
				to_world_log("LIMBO ELEMENT SERIALIZATION FAILED: [query.ErrorMsg()].")
	catch (var/exception/e)
		to_world_log("Limbo Serializer Failed")
		to_world_log(e)

	thing_inserts.Cut(1)
	var_inserts.Cut(1)
	element_inserts.Cut(1)
	inserts_since_commit = 0

// Update the indices since we can't be certain what the next ID is across saves.
// TODO: Replace list indices in general with persistent ID analogues
/serializer/sql/one_off/proc/update_indices()
	var/DBQuery/list_id_query = dbcon.NewQuery("SELECT MAX(list_id) FROM limbo_list_element;")
	list_id_query.Execute()
	if(list_id_query.NextRow())
		var/list/id_row = list_id_query.GetRowData()
		list_index = text2num(id_row["MAX(list_id)"]) + 1

/serializer/sql/one_off/proc/update_load_cache(var/limbo_key, var/limbo_type)
	resolver.clear_cache()
	var/DBQuery/limbo_query = dbcon.NewQuery("SELECT `limbo_assoc` FROM `limbo` WHERE `key` = '[limbo_key]' AND `type` = '[limbo_type]';")
	var/limbo_assoc
	limbo_query.Execute()
	if(limbo_query.ErrorMsg())
		to_world_log("LIMBO QUERY FAILED FOR UPDATING LOAD CACHE: [limbo_query.ErrorMsg()].")
	if(limbo_query.NextRow())
		var/list/limbo_items = limbo_query.GetRowData()
		limbo_assoc = limbo_items["limbo_assoc"]

	var/list/ref_things = list()
	limbo_query = dbcon.NewQuery("SELECT `value` FROM `limbo_thing_var` WHERE `type` = 'OBJ' AND `limbo_assoc` = '[limbo_assoc]';")
	limbo_query.Execute()
	if(limbo_query.ErrorMsg())
		to_world_log("LIMBO QUERY FAILED FOR UPDATING LOAD CACHE: [limbo_query.ErrorMsg()].")
	while(limbo_query.NextRow())
		var/list/items = limbo_query.GetRowData()
		ref_things |= "'[items["value"]]'"

	// This is annoying, but we have to check against the game world refs to prevent duplication, as the limbo tables do not
	// normally track references.
	var/DBQuery/world_query = dbcon.NewQuery("SELECT `p_id`, `ref` FROM `thing` WHERE `p_id` IN ([jointext(ref_things, ", ")]);")
	world_query.Execute()
	if(world_query.ErrorMsg())
		to_world_log("LIMBO WORLD QUERY FAILED FOR UPDATING LOAD CACHE: [world_query.ErrorMsg()]")
	while(world_query.NextRow())
		var/list/items = world_query.GetRowData()
		var/datum/existing = locate(items["ref"])
		if(existing && !QDELETED(existing) && existing.persistent_id == items["p_id"]) // Check to see if the thing already exists in the gameworld by ref lookup.
			reverse_map[items["p_id"]] = existing
			continue

	// Now we re-execute and return to the limbo query.
	limbo_query = dbcon.NewQuery("SELECT `p_id`, `type`, `x`, `y`, `z` FROM `limbo_thing` WHERE `limbo_assoc` = '[limbo_assoc]';")
	limbo_query.Execute()
	if(limbo_query.ErrorMsg())
		to_world_log("LIMBO QUERY FAILED FOR UPDATING LOAD CACHE: [limbo_query.ErrorMsg()].")
	while(limbo_query.NextRow())
		var/list/items = limbo_query.GetRowData()
		if(reverse_map[items["p_id"]])
			continue
		var/datum/persistence/load_cache/thing/T = new(items)
		resolver.things[items["p_id"]] = T
		resolver.things_cached++

	limbo_query = dbcon.NewQuery("SELECT `thing_id`,`key`,`type`,`value` FROM `limbo_thing_var` WHERE `limbo_assoc` = '[limbo_assoc]';")
	limbo_query.Execute()
	if(limbo_query.ErrorMsg())
		to_world_log("LIMBO QUERY FAILED FOR UPDATING LOAD CACHE: [limbo_query.ErrorMsg()].")
	while(limbo_query.NextRow())
		var/items = limbo_query.GetRowData()
		var/datum/persistence/load_cache/thing_var/V = new(items)
		var/datum/persistence/load_cache/thing/T = resolver.things[items["thing_id"]]
		if(T)
			T.thing_vars.Add(V)
			resolver.vars_cached++

	limbo_query = dbcon.NewQuery("SELECT `list_id`,`key`,`key_type`,`value`,`value_type` FROM `limbo_list_element` WHERE `limbo_assoc` = '[limbo_assoc]';")
	limbo_query.Execute()
	if(limbo_query.ErrorMsg())
		to_world_log("LIMBO QUERY FAILED FOR UPDATING LOAD CACHE: [limbo_query.ErrorMsg()].")
	while(limbo_query.NextRow())
		var/items = limbo_query.GetRowData()
		var/datum/persistence/load_cache/list_element/element = new(items)
		LAZYADD(resolver.lists["[items["list_id"]]"], element)
		resolver.lists_cached++