var/global/list/flatten_types = list()
var/global/list/saved_vars = initialize_saved_vars()
var/global/list/blacklisted_vars = list("is_processing", "vars", "active_timers", "type", "parent_type")
var/global/list/reference_only_vars = list("home_spawn")

/proc/initialize_saved_vars()
	. = list()

	// Stats
	var/loaded_types = 0
	var/loaded_vars = 0

	// Actual serialization
	for(var/saved_var in json_decode(file2text('./mods/persistence/saved_vars.json')))
		if(!saved_var["path"])
			continue
		if(!saved_var["vars"] || !length(saved_var["vars"]))
			continue
		var/path
		try
			path = text2path(saved_var["path"])
		catch
			to_world_log("[saved_var["path"]] does not exist.")
			continue
		var/subtypes = subtypesof(path)
		loaded_types += length(subtypes) + 1
		if(saved_var["flatten"])
			// We're flattening this obj too.
			LAZYDISTINCTADD(global.flatten_types, path)

		for(var/v in saved_var["vars"])
			LAZYDISTINCTADD(.[path], v)
			loaded_vars++
			for(var/subtype in subtypes)
				LAZYDISTINCTADD(.[subtype], v)

	to_world_log("Successfully loaded [loaded_types] serialized types, and [loaded_vars] variables.")

