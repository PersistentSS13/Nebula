/proc/SQLS_Force_Reconnect()
	setup_save_database_connection()
	to_chat(usr, "Forced db connection to be reconnected!")
	if(!check_save_db_connection())
		to_chat(usr, SPAN_WARNING("Reconnect failed.."))
	else
		to_chat(usr, "Reconnect successful")
	to_chat(usr, "Running test query SELECT DATABASE();")

	var/DBQuery/dbq = global.dbcon_save.NewQuery("SELECT DATABASE();")
	if(dbq.Execute() && dbq.NextRow())
		to_chat(usr, "Test query returned: '[dbq.item[1]]'!")
	else
		to_chat(usr, SPAN_WARNING("Failed with error: '[dbcon_save.ErrorMsg()]'"))

/proc/SQLS_Print_DB_STATUS()
	if(!establish_save_db_connection())
		to_chat(usr, "Couldn't get DB status, connection failed: [dbcon_save.ErrorMsg()]")
		return

	var/DBQuery/query = dbcon_save.NewQuery("SELECT `id`, `z`, `dynamic`, `default_turf` FROM `[SQLS_TABLE_Z_LEVELS]`")
	if(!query.Execute())
		to_chat(usr, "Error: [query.ErrorMsg()]")
	if(!query.RowCount())
		to_chat(usr, "No Z data...")

	while(query.NextRow())
		to_chat(usr, "Z data: (ID: [query.item[1]], Z: [query.item[2]], Dynamic: [query.item[3]], Default Turf: [query.item[4]])")

	query = dbcon_save.NewQuery("SELECT DATABASE();")
	var/my_db_name
	if(!query.Execute())
		to_chat(usr, "Error: [query.ErrorMsg()]")
		return

	query.NextRow()
	my_db_name = query.item[1]

	query = dbcon_save.NewQuery("SELECT `TABLE_NAME`, `TABLE_ROWS` FROM information_schema.tables WHERE `TABLE_SCHEMA` = '[my_db_name]' AND `TABLE_NAME` IN ('[SQLS_TABLE_LIST_ELEM]', '[SQLS_TABLE_DATUM]', '[SQLS_TABLE_DATUM_VARS]', '[SQLS_TABLE_AREAS]', '[SQLS_TABLE_LIMBO]', '[SQLS_TABLE_LIMBO_DATUM]', '[SQLS_TABLE_LIMBO_DATUM_VARS]', '[SQLS_TABLE_LIMBO_LIST_ELEM]', '[SQLS_TABLE_LIST_ELEM]')")
	if(!query.Execute())
		to_chat(usr, "Error: [query.ErrorMsg()]")
		return

	while(query.NextRow())
		to_chat(usr, "Table `[query.item[1]]` Rows: [query.item[2]]")

	close_save_db_connection()

/*
	Actual serizlizer
*/
/serializer/sql
	var/list_index = 1

	var/list/thing_inserts = list()
	var/list/var_inserts = list()
	var/list/element_inserts = list()
	var/list/ref_updates = list()

	var/tot_element_inserts = 0

	var/autocommit = TRUE // whether or not to autocommit after a certain number of inserts.
	var/inserts_since_commit = 0
	var/autocommit_threshold = 5000

	var/ref_tracker = TRUE // whether or not this serializer does reference tracking and adds it to the thing insert list.
	var/inserts_since_ref_update = 0 // we automatically commit refs to the database in batches on load
	var/ref_update_threshold = 200

	// Add the flatten serializer.
	var/serializer/json/flattener

	var/static/byondChar			// byondChar isn't unicode valid, so we have to get this at runtime
	var/static/utf8Char = "\uF811"	// this is a Private Use character in utf8 that we can use as a replacement

#ifdef SAVE_DEBUG
	var/verbose_logging = FALSE
#endif


/serializer/sql/New()
	..()
	flattener = new(src)

	if(isnull(byondChar))
		byondChar = copytext_char("\improper", 1, 2)

/serializer/sql/proc/byond2utf8(var/text)
	return replacetext(text, byondChar, utf8Char)

/serializer/sql/proc/utf82byond(var/text)
	return replacetext(text, utf8Char, byondChar)


/serializer/sql/_before_serialize()
	if(!establish_save_db_connection())
		CRASH("SQL SERIALIZER: Failed to connect to save DB!")
	LAZYCLEARLIST(serialization_time_spent_type)

/serializer/sql/_before_deserialize()
	if(!establish_save_db_connection())
		CRASH("SQL SERIALIZER: Failed to connect to save DB!")
	LAZYCLEARLIST(serialization_time_spent_type)

/serializer/sql/_after_serialize()
	close_save_db_connection()

/serializer/sql/_after_deserialize()
	close_save_db_connection()

/**Keep a tally of the time taken to save each datum types */
var/global/list/serialization_time_spent_type

// Serialize an object datum. Returns the appropriate serialized form of the object. What's outputted depends on the serializer.
/serializer/sql/SerializeDatum(var/datum/object, var/atom/object_parent)
	// Check for existing references first. If we've already saved
	// there's no reason to save again.
	if(isnull(object) || !object.should_save())
		return

	var/existing = thing_map["\ref[object]"]
	if (existing)
#ifdef SAVE_DEBUG
		to_world_log("(SerializeThing-Resv) \ref[thing] to [existing]")
		CHECK_TICK
#endif
		return existing

	//locs check, to make sure we're saving a multi-tile object only on its original turf
	if(isturf(object_parent) && ismovable(object))
		var/atom/movable/am = object
		if(length(am.locs) > 1 && (am.loc != object_parent))
			return

	var/time_before_serialize = REALTIMEOFDAY
	// Thing didn't exist. Create it.
	var/p_i = object.persistent_id ? object.persistent_id : PERSISTENT_ID
	object.persistent_id = p_i

	var/x = 0
	var/y = 0
	var/z = 0

	var/before_before_save = REALTIMEOFDAY
	object.before_save() // Before save hook.
	if((REALTIMEOFDAY - before_before_save) > 5 SECONDS)
		to_world_log("before_save() took [(REALTIMEOFDAY - before_before_save) / (1 SECOND)] to execute on type [object.type]!")

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
	to_world_log("(SerializeThing) ('[p_i]','[object.type]',[x],[y],[z],'[ref(object)]')")
#endif
	if(ref_tracker)
		thing_inserts.Add("'[p_i]','[object.type]',[x],[y],[z],'[ref(object)]'")
	else
		thing_inserts.Add("'[p_i]','[object.type]',[x],[y],[z]")
	inserts_since_commit++
	thing_map["\ref[object]"] = p_i

	for(var/V in get_saved_variables_for(object.type))
		var/VV = object.vars[V]
		var/VT = SERIALIZER_TYPE_VAR
#ifdef SAVE_DEBUG
		to_world_log("(SerializeThingVar) [V]")
#endif
		if(VV == initial(object.vars[V]))
			continue

		if(islist(VV) && !isnull(VV))
			// Complex code for serializing lists...
			VT = SERIALIZER_TYPE_LIST
			if(length(VV) == 0)
				// Another optimization. Don't need to serialize lists
				// that have 0 elements.
				VV = SERIALIZER_TYPE_LIST_EMPTY
			else
				VV = SerializeList(VV, object)
			if(isnull(VV))
#ifdef SAVE_DEBUG
				to_world_log("(SerializeThingVar-Skip) Null List")
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
			GD.on_serialize(VV, src)
			if(!GD.key)
				// Wrapper is null.
				continue
			VV = flattener.SerializeDatum(GD, object)
		else if (istype(VV, /datum))
			var/datum/VD = VV
			if(!VD.should_save(object))
				continue
			// Reference only vars do not serialize their target objects, only retaining the reference if its been serialized elsewhere.
			if(V in global.reference_only_vars)
				VT = SERIALIZER_TYPE_DATUM
				if(!VD.persistent_id)
					VD.persistent_id = PERSISTENT_ID
				VV = VD.persistent_id
			// Serialize it complex-like, baby.
			else if(should_flatten(VV))
				VT = SERIALIZER_TYPE_DATUM_FLAT // If we flatten an object, the var becomes json. This saves on indexes for simple objects.
				VV = flattener.SerializeDatum(VV, object)
			else
				VT = SERIALIZER_TYPE_DATUM
				VV = SerializeDatum(VV, object)
		else
			// We don't know what this is. Skip it.
#ifdef SAVE_DEBUG
			to_world_log("(SerializeThingVar-Skip) Unknown Var")
#endif
			continue
		VV = sanitize_sql("[VV]")
#ifdef SAVE_DEBUG
		to_world_log("(SerializeThingVar-Done) ('[p_i]','[V]','[VT]',\"[VV]\")")
#endif
		var_inserts.Add("'[p_i]','[V]','[VT]',\"[VV]\"")
		inserts_since_commit++

	var/before_after_save = REALTIMEOFDAY
	object.after_save() // After save hook.
	if((REALTIMEOFDAY - before_after_save) > 5 SECONDS)
		to_world_log("after_save() took [(REALTIMEOFDAY - before_after_save) / (1 SECOND)] to execute on type [object.type]!")

	if(autocommit && inserts_since_commit > autocommit_threshold)
		Commit()

	//Tally up statistices
	var/datum/serialization_stat/st = LAZYACCESS(serialization_time_spent_type, object.type)
	if(!st)
		st = new
		LAZYSET(serialization_time_spent_type, object.type, st)
	st.time_spent += (REALTIMEOFDAY - time_before_serialize)
	st.nb_instances++
	return p_i

// Serialize a list. Returns the appropriate serialized form of the list. What's outputted depends on the serializer.
/serializer/sql/SerializeList(var/list/_list, var/datum/list_parent)
	if(isnull(_list) || !islist(_list))
		return
	var/existing = list_map["\ref[_list]"]
	if(existing)
#ifdef SAVE_DEBUG
		to_world_log("(SerializeList-Resv) \ref[_list] to [existing]")
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
				EV = _list[key] //#FIXME: We really need to get rid of this awful way to check if lists are associative.
			catch
				EV = null // NBD... No value.
		if (isnull(key))
			KT = SERIALIZER_TYPE_NULL
		else if(isnum(key))
			KT = SERIALIZER_TYPE_NUM
		else if (istext(key))
			KT = SERIALIZER_TYPE_TEXT
			KV = byond2utf8(key)
		else if (ispath(key) || IS_PROC(key))
			KT = SERIALIZER_TYPE_PATH
		else if (isfile(key))
			KT = SERIALIZER_TYPE_FILE
		else if (islist(key))
			KT = SERIALIZER_TYPE_LIST
			if(length(key) == 0)
				KV = SERIALIZER_TYPE_LIST_EMPTY
			else
				KV = SerializeList(key)
		else if(get_wrapper(key))
			KT = SERIALIZER_TYPE_WRAPPER
			var/wrapper_path = get_wrapper(key)
			var/datum/wrapper/GD = new wrapper_path
			if(!GD)
				// Missing wrapper!
				continue
			GD.on_serialize(key, src)
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
				KV = SerializeDatum(KV)
		else
#ifdef SAVE_DEBUG
			to_world_log("(SerializeListElem-Skip) Unknown Key. Value: [key]")
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
				if(length(EV) == 0)
					EV = SERIALIZER_TYPE_LIST_EMPTY
				else
					EV = SerializeList(EV)
			else if(get_wrapper(EV))
				ET = SERIALIZER_TYPE_WRAPPER
				var/wrapper_path = get_wrapper(EV)
				var/datum/wrapper/GD = new wrapper_path
				if(!GD)
					// Missing wrapper!
					continue
				GD.on_serialize(EV, src)
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
					EV = SerializeDatum(EV)
			else
				// Don't know what this is. Skip it.
#ifdef SAVE_DEBUG
				to_world_log("(SerializeListElem-Skip) Unknown Value")
#endif
				continue
		KV = sanitize_sql("[KV]")
		EV = sanitize_sql("[EV]")
#ifdef SAVE_DEBUG
		if(verbose_logging)
			to_world_log("(SerializeListElem-Done) ([l_i],\"[KV]\",'[KT]',\"[EV]\",\"[ET]\")")
#endif
		found_element = TRUE
		element_inserts.Add("[l_i],\"[KV]\",'[KT]',\"[EV]\",\"[ET]\"")
		inserts_since_commit++

	if(!found_element) // There wasn't anything that actually needed serializing in this list, so return null.
		list_index--
		list_map -= list_ref
		return null
	return l_i

/serializer/sql/DeserializeDatum(var/datum/persistence/load_cache/thing/thing)
#ifdef SAVE_DEBUG
	var/list/deserialized_vars = list()
#endif
	if(!thing)
		to_world_log("DeserializeDatum(): Got a null thing!")

	// Checking for existing items.
	var/datum/existing = reverse_map["[thing.p_id]"]
	if(existing)
		return existing
	// Handlers for specific types would go here.
	if (ispath(thing.thing_type, /turf))
		// turf turf turf
		var/turf/T = locate(thing.x, thing.y, thing.z)
		if (!T)
			to_world_log("Attempting to deserialize onto turf [thing.x],[thing.y],[thing.z] failed. Could not locate turf.")
			return
		existing = T.ChangeTurf(thing.thing_type)
	else
		// default creation
		existing = new thing.thing_type()
	existing.persistent_id = thing.p_id // Upon deserialization we reapply the persistent_id in the thing table to save space.
	reverse_map["[thing.p_id]"] = existing

	//Remove vars not in our currently saved vars, since they're validated, we won't ever load a missing variable this way
	// Which is enormously faster than comparing to the object's vars var.
	var/list/saved = get_saved_variables_for(existing.type)
	for(var/datum/persistence/load_cache/thing_var/TV in thing.thing_vars)
		if(!(TV.key in saved))
			thing.thing_vars -= TV
			log_warning("Saved var '[TV.key]' ignored since receiving object '[TV.var_type]' doesn't have this variable!")

	// Fetch all the variables for the thing.
	for(var/datum/persistence/load_cache/thing_var/TV in thing.thing_vars)
		// Each row is a variable on this object.
#ifdef SAVE_DEBUG
		deserialized_vars.Add("[TV.key]:[TV.var_type]")
#endif
		try
			switch(TV.var_type)
				if(SERIALIZER_TYPE_NUM)
					existing.vars[TV.key] = text2num(TV.value)
				if(SERIALIZER_TYPE_TEXT)
					TV.value = utf82byond(TV.value)
					existing.vars[TV.key] = TV.value
				if(SERIALIZER_TYPE_PATH)
					existing.vars[TV.key] = text2path(TV.value)
				if(SERIALIZER_TYPE_NULL)
					existing.vars[TV.key] = null
				if(SERIALIZER_TYPE_WRAPPER)
					var/datum/wrapper/GD = flattener.QueryAndDeserializeDatum(TV.value)
					existing.vars[TV.key] = GD.on_deserialize(src)
				if(SERIALIZER_TYPE_LIST)
					// This was just an empty list.
					if(TV.value == SERIALIZER_TYPE_LIST_EMPTY)
						existing.vars[TV.key] = list()
					else
						existing.vars[TV.key] = QueryAndDeserializeList(TV.value)
				if(SERIALIZER_TYPE_DATUM)
					existing.vars[TV.key] = QueryAndDeserializeDatum(TV.value, TV.key in global.reference_only_vars)
				if(SERIALIZER_TYPE_DATUM_FLAT)
					existing.vars[TV.key] = flattener.QueryAndDeserializeDatum(TV.value)
				if(SERIALIZER_TYPE_FILE)
					existing.vars[TV.key] = file(TV.value)

		catch(var/exception/e)
			to_world_log("Failed to deserialize '[TV.key]' of type '[TV.var_type]' on line [e.line] / file [e.file] for reason: '[e]'.")
#ifdef SAVE_DEBUG
	to_world_log("Deserialized thing of type [thing.thing_type] ([thing.x],[thing.y],[thing.z]) with vars: " + jointext(deserialized_vars, ", "))
#endif
	ref_updates["[existing.persistent_id]"] = ref(existing)
	inserts_since_ref_update++
	if(inserts_since_ref_update > ref_update_threshold)
		CommitRefUpdates()
	return existing

/serializer/sql/DeserializeList(var/raw_list)
	var/list/existing = list()
	// Will deserialize and return a list.
	// to_world_log("deserializing list with [length(raw_list)] elements.")
	for(var/datum/persistence/load_cache/list_element/LE in raw_list)
		var/key_value
		// to_world_log("deserializing list element [LE.key_type].")
		try
			switch(LE.key_type)
				if(SERIALIZER_TYPE_NULL)
					key_value = null
				if(SERIALIZER_TYPE_TEXT)
					LE.key = utf82byond(LE.key)
					key_value = LE.key
				if(SERIALIZER_TYPE_NUM)
					key_value = text2num(LE.key)
				if(SERIALIZER_TYPE_PATH)
					key_value = text2path(LE.key)
				if(SERIALIZER_TYPE_WRAPPER)
					var/datum/wrapper/GD = flattener.QueryAndDeserializeDatum(LE.key)
					key_value = GD.on_deserialize(src)
				if(SERIALIZER_TYPE_LIST)
					if(LE.key == SERIALIZER_TYPE_LIST_EMPTY)
						key_value = list()
					else
						key_value = QueryAndDeserializeList(LE.key)
				if(SERIALIZER_TYPE_DATUM)
					key_value = QueryAndDeserializeDatum(LE.key)
				if(SERIALIZER_TYPE_DATUM_FLAT)
					key_value = flattener.QueryAndDeserializeDatum(LE.key)
				if(SERIALIZER_TYPE_FILE)
					key_value = file(LE.key)

			switch(LE.value_type)
				if(SERIALIZER_TYPE_NULL)
					// This is how lists are made. Everything else is a dict.
					existing += list(key_value)
				if(SERIALIZER_TYPE_TEXT)
					LE.value = utf82byond(LE.value)
					existing[key_value] = LE.value
				if(SERIALIZER_TYPE_NUM)
					existing[key_value] = text2num(LE.value)
				if(SERIALIZER_TYPE_PATH)
					existing[key_value] = text2path(LE.value)
				if(SERIALIZER_TYPE_WRAPPER)
					var/datum/wrapper/GD = flattener.QueryAndDeserializeDatum(LE.value)
					existing[key_value] = GD.on_deserialize(src)
				if(SERIALIZER_TYPE_LIST)
					if(LE.value == SERIALIZER_TYPE_LIST_EMPTY)
						existing[key_value] = list()
					else
						existing[key_value] = QueryAndDeserializeList(LE.value)
				if(SERIALIZER_TYPE_DATUM)
					existing[key_value] = QueryAndDeserializeDatum(LE.value)
				if(SERIALIZER_TYPE_DATUM_FLAT)
					existing[key_value] = flattener.QueryAndDeserializeDatum(LE.value)
				if(SERIALIZER_TYPE_FILE)
					existing[key_value] = file(LE.value)

		catch(var/exception/e)
			var/cur_val = ""
			if(LE)
				var/datum/casted = LE?.key
				cur_val += "('[LE?.key]'([LE?.key_type] [istype(casted)? casted.type : null])"
				if(LE.value)
					casted = LE?.value
					cur_val += " = '[LE?.value]'([LE?.value_type] [istype(casted)? casted.type : null]))"
				else
					cur_val += ")"
			to_world_log("Failed to deserialize list element [cur_val] on line [e.line] / file [e.file] for reason: [e].")

	return existing

/serializer/sql/proc/Commit()
	if(!establish_save_db_connection())
		CRASH("SQL Serializer: Failed to connect to db!")

	var/DBQuery/query
	var/exception/last_except
	try
		if(length(thing_inserts) > 0)
			query = dbcon_save.NewQuery("INSERT INTO `[SQLS_TABLE_DATUM]`(`p_id`,`type`,`x`,`y`,`z`,`ref`) VALUES["(" + jointext(thing_inserts, "),(") + ")"] ON DUPLICATE KEY UPDATE `p_id` = `p_id`")
			SQLS_EXECUTE_AND_REPORT_ERROR(query, "THING SERIALIZATION FAILED:")
		if(length(var_inserts) > 0)
			query = dbcon_save.NewQuery("INSERT INTO `[SQLS_TABLE_DATUM_VARS]`(`thing_id`,`key`,`type`,`value`) VALUES["(" + jointext(var_inserts, "),(") + ")"]")
			SQLS_EXECUTE_AND_REPORT_ERROR(query, "VAR SERIALIZATION FAILED:")
		if(length(element_inserts) > 0)
			tot_element_inserts += length(element_inserts)
			query = dbcon_save.NewQuery("INSERT INTO `[SQLS_TABLE_LIST_ELEM]`(`list_id`,`key`,`key_type`,`value`,`value_type`) VALUES["(" + jointext(element_inserts, "),(") + ")"]")
			SQLS_EXECUTE_AND_REPORT_ERROR(query, "ELEMENT SERIALIZATION FAILED:")
	catch (var/exception/e)
		if(istype(e, /exception/sql_connection))
			last_except = e //Throw it after we clean up
		else
			to_world_log("World Serializer Failed")
			to_world_log(e) //#FIXME: This doesn't print the exception's contents

	thing_inserts.Cut(1)
	var_inserts.Cut(1)
	element_inserts.Cut(1)
	inserts_since_commit = 0

	//Throw after we cleanup
	if(last_except)
		throw last_except

/serializer/sql/proc/CommitRefUpdates()
	if(!establish_save_db_connection())
		CRASH("SQL Serializer: Failed to connect to db!")

	if(length(ref_updates) == 0)
		inserts_since_ref_update = 0
		return
	var/list/where_list = list()
	var/list/case_list = list()
	var/DBQuery/query
	for(var/p_id in ref_updates)
		where_list.Add("'[p_id]'")
		var/new_ref = sanitize_sql(ref_updates[p_id])
		case_list.Add("WHEN `p_id` = '[p_id]' THEN '[new_ref]'")
	if(length(where_list) && length(case_list))
		query = dbcon_save.NewQuery("UPDATE `[SQLS_TABLE_DATUM]` SET `ref` = CASE [jointext(case_list, " ")] END WHERE `p_id` IN ([jointext(where_list, ", ")])")
		SQLS_EXECUTE_AND_REPORT_ERROR(query, "REFERENCE UPDATE FAILED:")

	ref_updates.Cut()
	inserts_since_ref_update = 0

/serializer/sql/Clear()
	. = ..()
	thing_inserts.Cut(1)
	var_inserts.Cut(1)
	element_inserts.Cut(1)
	list_index = 1
	flattener.Clear()

///Do pre world saving stuff. Returns the current save log entry id.
/serializer/sql/proc/PreWorldSave(var/save_initiator)
	_before_serialize()
	//Ask the db to clear the old world save
	var/DBQuery/query = dbcon_save.NewQuery("CALL `[SQLS_PROC_CLEAR_WORLD_SAVE]`();")
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "UNABLE TO WIPE PREVIOUS SAVE:")

	//Logs the world save into the table
	query = dbcon_save.NewQuery("SELECT `[SQLS_FUNC_LOG_SAVE_WORLD_START]`('[sanitize_sql(sanitize(save_initiator, MAX_LNAME_LEN))]');")
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "UNABLE TO LOG WORLD SAVE START:")
	if(query.NextRow())
		. = query.item[1]
	Clear()

/serializer/sql/proc/PostWorldSave(var/save_entry_id, var/nb_saved_lvl, var/nb_saved_atoms, var/result_text)
	var/actual_query = "SELECT `[SQLS_FUNC_LOG_SAVE_END]`('[save_entry_id]','[nb_saved_lvl]','[nb_saved_atoms]','[sanitize_sql(sanitize(result_text, MAX_MEDIUM_TEXT_LEN))]');"
	var/DBQuery/query = dbcon_save.NewQuery(actual_query)
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "UNABLE TO LOG WORLD SAVE END ('[actual_query]'):")
	if(query.NextRow())
		. = query.item[1]
	_after_serialize()
	Clear()

/serializer/sql/save_exists()
	return count_saved_datums() > 0

///Returns the timestamp of when the currently loaded save was completed.
/serializer/sql/last_loaded_save_time()
	if(!establish_save_db_connection())
		CRASH("Couldn't get last world save timestamp, connection failed!")
	//Get the last logged world save from the db
	var/DBQuery/query = dbcon_save.NewQuery("SELECT `[SQLS_FUNC_GET_LAST_SAVE_TIME]`();")
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "UNABLE TO GET THE TIMESTAMP FOR THE LAST WORLD SAVE:")
	if(query.NextRow())
		return query.item[1]

/serializer/sql/save_z_level_remaps(var/list/z_transform)
	var/list/z_inserts = list()
	var/z_insert_index = 1
	for(var/z in z_transform)
		var/datum/persistence/load_cache/z_level/z_level = z_transform[z]
		z_inserts += "([z_insert_index],[z_level.new_index],[z_level.dynamic],'[z_level.default_turf]','[z_level.metadata]','[json_encode(z_level.areas)]','[z_level.level_data_subtype]')"
		z_insert_index++

	var/DBQuery/query = dbcon_save.NewQuery("INSERT INTO `[SQLS_TABLE_Z_LEVELS]` (`id`,`z`,`dynamic`,`default_turf`,`metadata`,`areas`,`level_data_subtype`) VALUES[jointext(z_inserts, ",")]")
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "Z_LEVEL SERIALIZATION FAILED:")
	return TRUE

/serializer/sql/save_area_chunks(var/list/area_chunks)
	var/list/area_inserts = list()
	var/area_insert_index = 1
	for(var/datum/persistence/load_cache/area_chunk/area_chunk in area_chunks)
		area_inserts += "([area_insert_index],'[area_chunk.area_type]','[sanitize_sql(area_chunk.name)]','[json_encode(area_chunk.turfs)]')"
		area_insert_index++

	// No additional areas to save!
	if(!length(area_inserts))
		return TRUE
	log_world("Query is: INSERT INTO `[SQLS_TABLE_AREAS]` (`id`,`type`,`name`,`turfs`) VALUES[jointext(area_inserts, ",")]")
	var/DBQuery/query = dbcon_save.NewQuery("INSERT INTO `[SQLS_TABLE_AREAS]` (`id`,`type`,`name`,`turfs`) VALUES[jointext(area_inserts, ",")]")
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "AREA CHUNK SERIALIZATION FAILED:")
	return TRUE

/serializer/sql/count_saved_datums()
	if(!establish_save_db_connection())
		CRASH("Couldn't count saved datums, connection failed!")
	var/DBQuery/query = dbcon_save.NewQuery("SELECT COUNT(*) FROM `[SQLS_TABLE_DATUM]`;")
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "COUNT SAVED DATUMS FAILED:")
	if(query.NextRow())
		testing("counted [query.item[1]] entrie(s) in [SQLS_TABLE_DATUM] table..")
		return text2num(query.item[1])
