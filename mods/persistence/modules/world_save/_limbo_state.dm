// Limbo states are used to maintain objects in the database even when they do not exist in the gameworld. They only exist
// in the brief period between when saving begins and ends, and are used to hold table rows before the gameworld saves, update
// appropriate values post gameworld save, and then reinsert the values into the table.

// Limbo states should be used for any object which may need to be asynchronously deserialized, as they are necessary to cache 
// objects and variables for one-off deserialization.

/datum/limbo_state
	var/original_p_id
	var/limbo_key
	var/limbo_type

	var/list/thing_reinserts = list() // Associative list of thing persistence id to queried row for thing
	var/list/var_reinserts = list()   // Associative list of thing persistence id to list of queried rows for vars
	var/list/list_reinserts = list()  // Associative list of var index to list of queried rows for list elements 

	var/list/found_things = list()
	var/list/found_lists = list()
	var/recursions = 0

/datum/limbo_state/New(var/target_p_id, var/l_key, var/l_type)
	original_p_id = target_p_id
	limbo_key = l_key
	limbo_type = l_type
	get_inserts(target_p_id)

// Called before the gameworld has been serialized. 
// Queries the database for the variables and list elements associated with the target, recursively grabbing referenced datums.
/datum/limbo_state/proc/get_inserts(var/target_p_id)
	if(target_p_id in found_things) // We already copied rows for this object.
		return
	recursions++
	found_things |= target_p_id
	// Find the target in the database
	// TODO: x, y, and z are currently not pulled from the `thing` table because turfs are not supported. In the future, they will be handled
	// in a special way.
	var/DBQuery/target_query = dbcon.NewQuery("SELECT `p_id`,`type`,`ref` FROM `thing` WHERE `p_id` = '[target_p_id]'")
	target_query.Execute()
	while(target_query.NextRow())
		var/list/items = target_query.GetRowData()
		// Check to see if this thing is already being saved - if so, don't bother grabbing the rows.
		var/atom/in_world = locate(items["ref"])
		if(istype(in_world) && !QDELETED(in_world) && ((in_world.z in SSpersistence.saved_levels) || (get_area(in_world) in SSpersistence.saved_areas)))
			return
		thing_reinserts[target_p_id] = items
	// Find the vars associated with the target
	var_reinserts[target_p_id] = list()
	var/DBQuery/target_v_query = dbcon.NewQuery("SELECT `id`,`thing_id`,`key`,`type`,`value` FROM `thing_var` WHERE `thing_id` = '[target_p_id]'")
	target_v_query.Execute()
	while(target_v_query.NextRow())
		var/list/items = target_v_query.GetRowData()
		items["value"] = sanitizeSQL(items["value"])
		var_reinserts[target_p_id] += list(items)
		if(items["type"] == "LIST") // This is referencing a list, so grab the associated rows. Later we'll adjust the indices of these.
			list_reinserts[items["id"]] = list()
			var/index = items["value"]
			var/DBQuery/list_query = dbcon.NewQuery("SELECT `id`,`list_id`,`key`,`key_type`,`value`,`value_type` FROM `list_element` WHERE `list_id` = [index]")
			list_query.Execute()
			while(list_query.NextRow())
				var/list/list_items = list_query.GetRowData()
				// The list is referencing another object, so get the vars for it as well.
				if(list_items["key_type"] == "OBJ")
					get_inserts(list_items["key"])
				if(list_items["value_type"] == "OBJ")
					get_inserts(list_items["value"])
				
				// We insert the list id for reference when caching for load later, but replace it during reinsert if it gets changed
				found_lists |= list_items["list_id"]
				// We resanitize these in case it has any content that'll throw errors on reinsertion, especially wrappers.
				list_items["key"] = sanitizeSQL(list_items["key"])
				list_items["value"] = sanitizeSQL(list_items["value"])
				list_reinserts[items["id"]] += list(list_items)
		else if(items["type"] == "OBJ") // This is referencing another object, so get the vars for it as well
			get_inserts(items["value"])
	return

// Called after the game world has been serialized.
// Updates appropriate `id` values and reinserts rows into the appropriate tables.
/datum/limbo_state/proc/reinsert()
	var/list/thing_row_inserts = list()
	var/list/var_row_inserts = list()
	var/list/element_row_inserts = list()
	// Look to see if the thing has already been reinserted into the table.
	for(var/thing_p_id in thing_reinserts)
		var/DBQuery/existing_query = dbcon.NewQuery("SELECT 1 FROM `thing` WHERE `p_id` = '[thing_p_id]'")
		existing_query.Execute()
		if(existing_query.NextRow())
			continue // This thing already exists in the table so assume its connected vars also exist in the table
		var/list/thing_items = thing_reinserts[thing_p_id]
		thing_row_inserts.Add("('[thing_items["p_id"]]','[thing_items["type"]]')")
		for(var/list/var_items in var_reinserts[thing_p_id])
			// Check if there's a list associated - if so, we need to reinsert the list and update the list index reference
			// This is going to create a duplicate list if this was a list multiple things referenced. Don't save those.
			if(var_items["type"] == "LIST" && list_reinserts[var_items["id"]])
				var/list_index = SSpersistence.serializer.list_index
				found_lists -= var_items["value"] // We remove the previous list ID from the load cache reference. 
				var_items["value"] = list_index
				found_lists |= list_index
				for(var/list/list_items in list_reinserts[var_items["id"]])
					list_items["list_id"] = list_index
					element_row_inserts.Add("([list_items["list_id"]],\"[list_items["key"]]\",'[list_items["key_type"]]',\"[list_items["value"]]\",\"[list_items["value_type"]]\")")
				SSpersistence.serializer.list_index++
			var_row_inserts.Add("('[var_items["thing_id"]]','[var_items["key"]]','[var_items["type"]]',\"[var_items["value"]]\")")
	
	var/DBQuery/insert_query
	if(length(thing_row_inserts) > 0)
		// We're intentionally *not* reinserting the ref of the object here.
		insert_query = dbcon.NewQuery("INSERT INTO `thing`(`p_id`,`type`) VALUES[jointext(thing_row_inserts, ",")]")
		insert_query.Execute()
		if(insert_query.ErrorMsg())
			to_world_log("LIMBO THING REINSERT FAILED: [insert_query.ErrorMsg()].")
	if(length(var_row_inserts) > 0)
		insert_query = dbcon.NewQuery("INSERT INTO `thing_var`(`thing_id`,`key`,`type`,`value`) VALUES[jointext(var_row_inserts, ",")]")
		insert_query.Execute()
		if(insert_query.ErrorMsg())
			to_world_log("LIMBO VAR REINSERT FAILED: [insert_query.ErrorMsg()].")
	if(length(element_row_inserts) > 0)
		insert_query = dbcon.NewQuery("INSERT INTO `list_element`(`list_id`,`key`,`key_type`,`value`,`value_type`) VALUES[jointext(element_row_inserts, ",")]")
		insert_query.Execute()
		if(insert_query.ErrorMsg())
			to_world_log("LIMBO ELEMENT REINSERT FAILED: [insert_query.ErrorMsg()].")

	// We insert the 'found' ids into the database so that objects can be cached on load for asynchronously loaded objects.
	var/related_p_ids = json_encode(found_things)
	var/related_list_ids = json_encode(found_lists)
	var/DBQuery/update_query = dbcon.NewQuery("UPDATE `limbo` SET `rel_p_ids` = '[related_p_ids]', `rel_list_ids` = '[related_list_ids]' WHERE `key` = '[limbo_key]' AND `type` = '[limbo_type]'")
	update_query.Execute()