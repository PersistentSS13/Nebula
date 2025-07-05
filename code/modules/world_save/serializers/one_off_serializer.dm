// This serializer is used for individual, non-game world serialization of objects. The serialized objects themselves are put into the limbo
// tables of the database.

/serializer/sql/one_off
	autocommit = FALSE
	ref_tracker = FALSE
	var/datum/wrapper_holder/extension_wrapper_holder

/serializer/sql/one_off/SerializeDatum(var/datum/object, var/object_parent)
	. = ..()
	// Special handling for extensions for one off serialization. Normally extensions self-report when they need to be saved, but here
	// we instead check if the saved objects have extensions that need to be saved.
	if(extension_wrapper_holder && object.extensions)
		for(var/key in object.extensions)
			var/datum/extension/E = object.extensions[key]
			if(istype(E) && E.should_save(one_off = TRUE))
				extension_wrapper_holder.wrapped |= E

///Do pre world saving stuff. Returns the current save log entry id.
/serializer/sql/one_off/proc/PreStorageSave(var/save_initiator)
	//Logs the save into the table
	var/DBQuery/query = dbcon_save.NewQuery("SELECT `[SQLS_FUNC_LOG_SAVE_STORAGE_START]`('[sanitize_sql(sanitize(save_initiator, MAX_LNAME_LEN))]');")
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "UNABLE TO LOG STORAGE SAVE START:")
	if(query.NextRow())
		. = query.item[1]

/serializer/sql/one_off/proc/PostStorageSave(var/log_id, var/nb_saved_lvl, var/nb_saved_atoms, var/result_text)
	var/DBQuery/query = dbcon_save.NewQuery("SELECT `[SQLS_FUNC_LOG_SAVE_END]`('[log_id]','[nb_saved_lvl]','[nb_saved_atoms]','[sanitize_sql(sanitize(result_text, MAX_MEDIUM_TEXT_LEN))]');")
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "UNABLE TO LOG STORAGE SAVE END ('[query.sql]'):")
	if(query.NextRow())
		. = query.item[1]

/serializer/sql/one_off/Commit(limbo_assoc)
	if(!establish_save_db_connection())
		CRASH("One-Off Serializer: Couldn't establish DB connection!")

	var/DBQuery/query
	var/exception/last_except
	try
		if(length(thing_inserts) > 0)
			query = dbcon_save.NewQuery("INSERT INTO `[SQLS_TABLE_LIMBO_DATUM]`(`p_id`,`type`,`x`,`y`,`z`,`limbo_assoc`) VALUES["(" + jointext(thing_inserts, ",'[limbo_assoc]'),(") + ",'[limbo_assoc]')"] ON DUPLICATE KEY UPDATE `p_id` = `p_id`")
			SQLS_EXECUTE_AND_REPORT_ERROR(query, "LIMBO THING SERIALIZATION FAILED:")

		if(length(var_inserts) > 0)
			query = dbcon_save.NewQuery("INSERT INTO `[SQLS_TABLE_LIMBO_DATUM_VARS]`(`thing_id`,`key`,`type`,`value`,`limbo_assoc`) VALUES["(" + jointext(var_inserts, ",'[limbo_assoc]'),(") + ",'[limbo_assoc]')"]")
			SQLS_EXECUTE_AND_REPORT_ERROR(query, "LIMBO VAR SERIALIZATION FAILED:")

		if(length(element_inserts) > 0)
			tot_element_inserts += length(element_inserts)
			var/raw_statement = "INSERT INTO `[SQLS_TABLE_LIMBO_LIST_ELEM]`(`list_id`,`key`,`key_type`,`value`,`value_type`,`limbo_assoc`) VALUES["(" + jointext(element_inserts, ",'[limbo_assoc]'),(") + ",'[limbo_assoc]')"]"
			query = dbcon_save.NewQuery(raw_statement)
			try
				SQLS_EXECUTE_AND_REPORT_ERROR(query, "LIMBO ELEMENT SERIALIZATION FAILED:")
			catch(var/exception/E)
				log_warning("Caught exception when issuing query :\n[raw_statement]") //#FIXME: query.sql does the same thing
				throw E

	catch (var/exception/e)
		if(istype(e, /exception/sql_connection))
			last_except = e //Throw it after we clean up
		else
			to_world_log("Limbo Serializer Failed")
			to_world_log(e) //#FIXME: This isn't going to print the exception's text...

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

	// It's very odd for ref_things to be empty, but it will throw a runtime if it is.
	if(length(ref_things))
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

/serializer/sql/one_off/proc/AddToLimbo(var/list/things, var/key, var/limbo_type, var/metadata, var/metadata2, var/modify = TRUE)

	// Check to see if this thing was already placed into limbo. If so, we go ahead and remove the thing from limbo first before reserializing.
	// When this occurs, it's possible things will be dropped from the database. Avoid serializing things into limbo which will remain in the game world.

	key = sanitize_sql(key)
	limbo_type = sanitize_sql(limbo_type)
	metadata = sanitize_sql(metadata)
	metadata2 = sanitize_sql(metadata2)

	// The 'limbo_assoc' column in the database relates every thing, thing_var, and list_element to an instance of limbo insertion.
	// While it uses the same PERSISTENT_ID format, it's not related to any datum's PERSISTENT_ID.
	var/limbo_assoc = PERSISTENT_ID
	var/DBQuery/existing_query = dbcon_save.NewQuery("SELECT 1 FROM `[SQLS_TABLE_LIMBO]` WHERE `key` = '[key]' AND `type` = '[limbo_type]'")
	SQLS_EXECUTE_AND_REPORT_ERROR(existing_query, "LIMBO SELECT KEY FAILED:")
	if(existing_query.NextRow()) // There was already something in limbo with this type.
		if(!modify)
			return
		RemoveFromLimbo(key, limbo_type)

	if(!islist(things))
		things = list(things)

	// Prepare the wrapper holder for possible extensions.
	extension_wrapper_holder = new()
	// Begin serialization of parent objects.
	update_indices()
	for(var/datum/thing in things)
		SerializeDatum(thing, null, limbo_assoc)
	if(length(extension_wrapper_holder.wrapped))
		SerializeDatum(extension_wrapper_holder, null, limbo_assoc)

	try
		Commit(limbo_assoc)
	catch (var/exception/e)
		Clear()
		throw e

	// Get the persistent ID for the "parent" objects.
	var/list/thing_p_ids = list()

	for(var/datum/thing in things)
		if(!thing.persistent_id)
			thing.persistent_id = PERSISTENT_ID
		thing_p_ids |= thing.persistent_id
	if(extension_wrapper_holder.persistent_id)
		thing_p_ids |= extension_wrapper_holder.persistent_id
	var/encoded_p_ids = json_encode(thing_p_ids)
	// Insert into the limbo table, a metadata holder that allows for access to the limbo_assoc key by 'type' and 'key'.
	var/DBQuery/insert_query
	insert_query = dbcon_save.NewQuery("INSERT INTO `[SQLS_TABLE_LIMBO]` (`key`,`type`,`p_ids`,`metadata`,`limbo_assoc`,`metadata2`) VALUES('[key]', '[limbo_type]', '[encoded_p_ids]', '[metadata]', '[limbo_assoc]', '[metadata2]')")

	try
		SQLS_EXECUTE_AND_REPORT_ERROR(insert_query, "LIMBO ADDITION FAILED:")
	catch (var/exception/insert_e)
		Clear()
		throw insert_e

	// Final check, ensure each passed thing has been added to the limbo table
	var/DBQuery/check_query
	check_query = dbcon_save.NewQuery("SELECT COUNT(*) FROM `[SQLS_TABLE_LIMBO_DATUM]` WHERE `limbo_assoc` = '[limbo_assoc]' AND `p_id` IN ('[jointext(thing_p_ids, "', '")]');")

	try
		SQLS_EXECUTE_AND_REPORT_ERROR(check_query, "LIMBO CHECK FAILED:")
	catch (var/exception/check_e)
		Clear()
		RemoveFromLimbo(key, limbo_type)
		throw check_e

	if(check_query.NextRow())
		if(text2num(check_query.item[1]) == length(thing_p_ids))
			. = TRUE // Success!
		else
			RemoveFromLimbo(key, limbo_type) // If we failed, remove any rows still in the database.
	Clear()

// Removes an object from the limbo table. This should always be called after an object is deserialized from limbo into the world.
/serializer/sql/one_off/proc/RemoveFromLimbo(var/limbo_key, var/limbo_type)

	limbo_key = sanitize_sql(limbo_key)

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
	. = delete_query.RowsAffected() //Return the amount of datums removed

	delete_query = dbcon_save.NewQuery("DELETE FROM `[SQLS_TABLE_LIMBO_DATUM_VARS]` WHERE `limbo_assoc` = '[limbo_assoc]';")
	SQLS_EXECUTE_AND_REPORT_ERROR(delete_query, "LIMBO DELETION OF VAR(S) FAILED:")

	delete_query = dbcon_save.NewQuery("DELETE FROM `[SQLS_TABLE_LIMBO_LIST_ELEM]` WHERE `limbo_assoc` = '[limbo_assoc]';")
	SQLS_EXECUTE_AND_REPORT_ERROR(delete_query, "LIMBO DELETION OF LIST ELEMENT(S) FAILED:")

	delete_query = dbcon_save.NewQuery("DELETE FROM `[SQLS_TABLE_LIMBO]` WHERE `limbo_assoc` = '[limbo_assoc]';")
	SQLS_EXECUTE_AND_REPORT_ERROR(delete_query, "LIMBO DELETION FROM LIMBO TABLE FAILED:")


/serializer/sql/one_off/proc/LoadFromLimbo(var/limbo_key, var/limbo_type)
	var/DBQuery/limbo_query = dbcon_save.NewQuery("SELECT `p_ids` FROM `[SQLS_TABLE_LIMBO]` WHERE `key` = '[limbo_key]' AND `type` = '[limbo_type]';")
	SQLS_EXECUTE_AND_REPORT_ERROR(limbo_query, "DESERIALIZE ONE-OFF FAILED:")
	var/list/limbo_p_ids = list()
	if(limbo_query.NextRow())
		var/list/limbo_items = limbo_query.GetRowData()
		limbo_p_ids |= json_decode(limbo_items["p_ids"])
	// Hold off on initialization until everthing is finished loading.
	SSatoms.map_loader_begin()
	update_load_cache(limbo_key, limbo_type)
	var/list/targets = list()
	for(var/target_p_id in limbo_p_ids)
		targets |= QueryAndDeserializeDatum(target_p_id)
	// Copy pasta for calling after_deserialize on everything we just deserialized.
	for(var/p_id in reverse_map)
		var/datum/T = reverse_map[p_id]
		T.after_deserialize()

		SSpersistence.limbo_refs[p_id] = ref(T)

	// Start initializing whatever we deserialized.
	SSatoms.map_loader_stop()
	SSatoms.InitializeAtoms()

	Clear()
	return targets

/serializer/sql/one_off/Clear()
	. = ..()
	extension_wrapper_holder = null