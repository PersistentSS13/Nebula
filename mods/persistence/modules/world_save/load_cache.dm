/datum/persistence/load_cache/thing
	var/p_id
	var/thing_type
	var/x
	var/y
	var/z
	var/list/thing_vars = list()

/datum/persistence/load_cache/thing/New(var/sql_row)
	p_id = sql_row["p_id"]
	thing_type = text2path(sql_row["type"])
	x = text2num(sql_row["x"])
	y = text2num(sql_row["y"])
	z = text2num(sql_row["z"])
	thing_vars = list()

/datum/persistence/load_cache/thing_var
	var/id
	var/var_type
	var/key
	var/value

/datum/persistence/load_cache/thing_var/New(var/sql_row)
	var_type = sql_row["type"]
	key = sql_row["key"]
	value = sql_row["value"]

/datum/persistence/load_cache/list_element
	var/index
	var/key
	var/key_type
	var/value
	var/value_type

/datum/persistence/load_cache/list_element/New(var/sql_row)
	index = text2num(sql_row["index"])
	key = sql_row["key"]
	key_type = sql_row["key_type"]
	value = sql_row["value"]
	value_type = sql_row["value_type"]

/datum/persistence/load_cache/z_level
	var/index			// The index in the database for the z_level
	var/new_index		// The new z_index on load.
	var/dynamic = FALSE // Dynamic z_levels are transformed on load.
	var/metadata
	var/default_turf	// The fill turf for the z_level.

/datum/persistence/load_cache/z_level/New(var/sql_row)
	if(sql_row)
		index = text2num(sql_row["z"])
		dynamic = text2num(sql_row["dynamic"])
		default_turf = text2path(sql_row["default_turf"])
		metadata = sql_row["metadata"]

/datum/persistence/load_cache/resolver
	var/list/things = list()
	var/list/lists = list()
	var/list/z_levels = list()

	var/vars_cached = 0
	var/lists_cached = 0
	var/things_cached = 0
	var/z_levels_cached = 0

	var/failed_vars = 0

/datum/persistence/load_cache/resolver/proc/load_cache()
	clear_cache()

	if(!establish_save_db_connection())
		CRASH("Load_Cache: Couldn't establish DB connection!")
	// Deserialized levels
	var/start = world.timeofday
	var/DBQuery/query = dbcon_save.NewQuery("SELECT `z`,`dynamic`,`default_turf`,`metadata` FROM `[SQLS_TABLE_Z_LEVELS]`;")
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "DESERIALIZE Z LEVELS FAILED:")
	while(query.NextRow())
		var/items = query.GetRowData()
		var/datum/persistence/load_cache/z_level/z_level = new(items)
		z_levels += z_level
		z_levels_cached++
		CHECK_TICK
	to_world_log("Took [(world.timeofday - start) / 10]s to cache [z_levels_cached] z_levels")

	// Deserialize the objects
	start = world.timeofday
	query = dbcon_save.NewQuery("SELECT `p_id`,`type`,`x`,`y`,`z` FROM `[SQLS_TABLE_DATUM]`;")
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "DESERIALIZE DATUMS FAILED:")
	while(query.NextRow())
		var/items = query.GetRowData()
		var/datum/persistence/load_cache/thing/T = new(items)
		things[items["p_id"]] = T
		things_cached++
		CHECK_TICK
	to_world_log("Took [(world.timeofday - start) / 10]s to cache [things_cached] things.")

	// Deserialize vars
	start = world.timeofday
	query = dbcon_save.NewQuery("SELECT `thing_id`,`key`,`type`,`value` FROM `[SQLS_TABLE_DATUM_VARS]`;")
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "DESERIALIZE VARS FAILED:")
	while(query.NextRow())
		var/items = query.GetRowData()
		var/datum/persistence/load_cache/thing_var/V = new(items)
		var/datum/persistence/load_cache/thing/T = things[items["thing_id"]]
		if(T)
			T.thing_vars.Add(V)
			vars_cached++
		else
			failed_vars++
		CHECK_TICK
	to_world_log("Took [(world.timeofday - start) / 10]s to cache [vars_cached] thing vars.")

	// Deserialized lists
	start = world.timeofday
	query = dbcon_save.NewQuery("SELECT `list_id`,`key`,`key_type`,`value`,`value_type` FROM `[SQLS_TABLE_LIST_ELEM]`;")
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "DESERIALIZE LIST FAILED:")
	while(query.NextRow())
		var/items = query.GetRowData()
		var/datum/persistence/load_cache/list_element/element = new(items)
		LAZYADD(lists["[items["list_id"]]"], element)
		lists_cached++
		CHECK_TICK
	to_world_log("Took [(world.timeofday - start) / 10]s to cache [lists_cached] lists")

	// Done!
	to_world_log("Cached [things_cached] things, [vars_cached + failed_vars] vars, [lists_cached] lists. [failed_vars] failed to cache due to missing thing references.")

/datum/persistence/load_cache/resolver/proc/clear_cache()
	things.Cut(1)
	lists.Cut(1)
	z_levels.Cut(1)

	vars_cached = 0
	lists_cached = 0
	things_cached = 0
	failed_vars = 0
	z_levels_cached = 0