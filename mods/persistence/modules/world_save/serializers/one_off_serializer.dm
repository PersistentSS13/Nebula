// This serializer is used for individual, non-game world serialization of objects.

// This takes in the persistent_id of a target object, and uses refs stored in the database rather than keeping a thing map around post-load.
// For consistency, it then generates a loadcache for the object, and passes it along to the normal deserialization procs.
/serializer/sql/one_off
	autocommit = FALSE

/serializer/sql/one_off/proc/update_indices()
	var/DBQuery/list_id_query = dbcon.NewQuery("SELECT MAX(list_id) FROM list_element;")
	list_id_query.Execute()
	if(list_id_query.NextRow())
		var/list/id_row = list_id_query.GetRowData()
		list_index = text2num(id_row["MAX(list_id)"]) + 1

/serializer/sql/one_off/proc/update_load_cache(var/limbo_key, var/limbo_type)
	resolver.clear_cache()
	// Obtain any objects or lists related to the limbo object. We'll cache these to speed up the loading process greatly.
	var/list/rel_p_ids = list()
	var/list/rel_list_ids = list()
	
	var/list/where_rel_p_ids = list()
	var/list/where_rel_list_ids = list()

	var/DBQuery/limbo_query = dbcon.NewQuery("SELECT `rel_p_ids`, `rel_list_ids` FROM `limbo` WHERE `key` = '[limbo_key]' AND `type` = '[limbo_type]';")
	limbo_query.Execute()
	if(limbo_query.ErrorMsg())
		to_world_log("LIMBO QUERY FAILED FOR ONE OFF DESERIALIZE: [limbo_query.ErrorMsg()].")
	if(limbo_query.NextRow())
		var/list/limbo_items = limbo_query.GetRowData()
		rel_p_ids += json_decode(limbo_items["rel_p_ids"])
		rel_list_ids += json_decode(limbo_items["rel_list_ids"])
		for(var/rel_p_id in rel_p_ids)
			where_rel_p_ids += "'[rel_p_id]'"
		for(var/rel_list_id in rel_list_ids)
			where_rel_list_ids += text2num(rel_list_id)

	var/DBQuery/query = dbcon.NewQuery("SELECT `p_id`,`type`,`x`,`y`,`z`,`ref` FROM `thing` WHERE `p_id` IN ([jointext(where_rel_p_ids, ", ")]);")
	query.Execute()

	while(query.NextRow())
		var/items = query.GetRowData()
		var/datum/existing = locate(items["ref"])
		if(existing && !QDELETED(existing) && existing.persistent_id == items["p_id"]) // Check to see if the thing already exists in the gameworld by ref lookup.
			reverse_map[items["p_id"]] = existing
			continue
		var/datum/persistence/load_cache/thing/T = new(items)
		resolver.things[items["p_id"]] = T
		resolver.things_cached++

	query = dbcon.NewQuery("SELECT `thing_id`,`key`,`type`,`value` FROM `thing_var` WHERE `thing_id` IN ([jointext(where_rel_p_ids, ", ")]);")
	query.Execute()
	while(query.NextRow())
		var/items = query.GetRowData()
		var/datum/persistence/load_cache/thing_var/V = new(items)
		var/datum/persistence/load_cache/thing/T = resolver.things[items["thing_id"]]
		if(T)
			T.thing_vars.Add(V)
			resolver.vars_cached++

	query = dbcon.NewQuery("SELECT `list_id`,`key`,`key_type`,`value`,`value_type` FROM `list_element` WHERE `list_id` IN ([jointext(where_rel_list_ids, ", ")]);")
	query.Execute()
	while(query.NextRow())
		var/items = query.GetRowData()
		var/datum/persistence/load_cache/list_element/element = new(items)
		LAZYADD(resolver.lists["[items["list_id"]]"], element)
		resolver.lists_cached++