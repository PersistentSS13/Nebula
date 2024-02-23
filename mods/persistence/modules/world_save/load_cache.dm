SAVED_VAR(/datum/persistence/load_cache/world, z_levels)
SAVED_VAR(/datum/persistence/load_cache/world, area_chunks)

SAVED_VAR(/datum/persistence/load_cache/z_level, index)
SAVED_VAR(/datum/persistence/load_cache/z_level, dynamic)
SAVED_VAR(/datum/persistence/load_cache/z_level, default_turf)
SAVED_VAR(/datum/persistence/load_cache/z_level, metadata)
SAVED_VAR(/datum/persistence/load_cache/z_level, areas)
SAVED_VAR(/datum/persistence/load_cache/z_level, level_data_subtype)

SAVED_VAR(/datum/persistence/load_cache/area_chunk, name)
SAVED_VAR(/datum/persistence/load_cache/area_chunk, area_type)
SAVED_VAR(/datum/persistence/load_cache/area_chunk, turfs)

SAVED_VAR(/datum/persistence/load_cache/character, target)


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

/datum/persistence/load_cache/world
	var/list/z_levels = list()
	var/list/area_chunks = list()

/datum/persistence/load_cache/character
	var/mob/target


/datum/persistence/load_cache/z_level
	var/index			// The index in the database for the z_level
	var/new_index		// The new z_index on load.
	var/dynamic = FALSE // Dynamic z_levels are transformed on load.
	var/metadata
	var/default_turf	// The fill turf for the z_level.
	var/level_data_subtype

	var/list/areas = list() // List of lists corresponding to one horizontal row of areas.
							// Format is list(list(type, name, tile count), ...)

/datum/persistence/load_cache/z_level/New(var/sql_row)
	if(sql_row)
		index = text2num(sql_row["z"])
		dynamic = text2num(sql_row["dynamic"])
		default_turf = text2path(sql_row["default_turf"])
		metadata = sql_row["metadata"]
		areas = json_decode(sql_row["areas"])
		level_data_subtype = text2path(sql_row["level_data_subtype"])

// A much less performant way of keeping track of areas by recording each individual turf.
/datum/persistence/load_cache/area_chunk
	var/name
	var/area_type

	var/list/turfs = list()

/datum/persistence/load_cache/area_chunk/New(var/sql_row)
	if(sql_row)
		name = sql_row["name"]
		area_type = text2path(sql_row["type"])
		turfs = json_decode(sql_row["turfs"])

/datum/persistence/load_cache/resolver
	var/list/things = list()
	var/list/lists = list()
	var/list/z_levels = list()
	var/list/area_chunks = list()

	var/vars_cached = 0
	var/lists_cached = 0
	var/things_cached = 0
	var/z_levels_cached = 0
	var/area_chunks_cached = 0

	var/failed_vars = 0
	var/datum/persistence/load_cache/world/world_cache_s


/datum/persistence/load_cache/resolver/proc/load_cache(var/instanceid)
	clear_cache()

	if(!establish_save_db_connection())
		CRASH("Load_Cache: Couldn't establish DB connection!")
	// Deserialize levels
	var/start = world.timeofday

	// Deserialize the objects
	start = world.timeofday
	var/DBQuery/query = dbcon_save.NewQuery("SELECT `p_id`,`type`,`x`,`y`,`z` FROM `[SQLS_TABLE_DATUM]` WHERE `InstanceID` = [instanceid];")
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "DESERIALIZE DATUMS FAILED:")
	while(query.NextRow())
		var/items = query.GetRowData()
		var/datum/persistence/load_cache/thing/T = new(items)
		things["[items["p_id"]]"] = T
		things_cached++
		CHECK_TICK

// Deserialize vars
	start = world.timeofday
	query = dbcon_save.NewQuery("SELECT `thing_id`,`key`,`type`,`value` FROM `[SQLS_TABLE_DATUM_VARS]` WHERE `InstanceID` = [instanceid];")
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

	to_world_log("Took [(world.timeofday - start) / 10]s to cache [things_cached] things.")

	// Deserialized lists
	start = world.timeofday
	query = dbcon_save.NewQuery("SELECT `list_id`,`key`,`key_type`,`value`,`value_type` FROM `[SQLS_TABLE_LIST_ELEM]` WHERE `InstanceID` = [instanceid];")
	SQLS_EXECUTE_AND_REPORT_ERROR(query, "DESERIALIZE LIST FAILED:")
	while(query.NextRow())
		var/items = query.GetRowData()
		var/datum/persistence/load_cache/list_element/element = new(items)
		LAZYADD(lists["[items["list_id"]]"], element)
		lists_cached++
	to_world_log("Took [(world.timeofday - start) / 10]s to cache [lists_cached] lists")

	// Done!
	to_world_log("Cached [things_cached] things, [vars_cached + failed_vars] vars, [lists_cached] lists. [failed_vars] failed to cache due to missing thing references.")

/datum/persistence/load_cache/resolver/proc/clear_cache()
	things.Cut()
	lists.Cut()
	z_levels.Cut()
	area_chunks.Cut()

	vars_cached = 0
	lists_cached = 0
	things_cached = 0
	failed_vars = 0
	z_levels_cached = 0
	area_chunks_cached = 0
