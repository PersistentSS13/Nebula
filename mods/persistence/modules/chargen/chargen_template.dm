/**
	Template for spawning chargen room prefabs in multiple rows and columns.
 */
/datum/map_template/chargen
	name                 = "chargen rooms"
	template_flags       = TEMPLATE_FLAG_SPAWN_GUARANTEED | TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RADS | TEMPLATE_FLAG_NO_RUINS
	template_categories  = list(MAP_TEMPLATE_CATEGORY_MAIN_SITE)
	level_data_type      = /datum/level_data/chargen
	template_parent_type = /datum/map_template/chargen

	///The map file containing the room template we'll use to fill the level. Set by the user.
	var/chargen_prefab_path
	///The amount of rooms we'll instantiate on the level. Should be set by the user.
	var/amount_chargen_rooms = MAX_NB_CHAR_GEN_PODS
	///The width of the chargen room prefab. Loaded at runtime.
	VAR_PRIVATE/tmp/room_width
	///The height of the chargen room prefab. Loaded at runtime.
	VAR_PRIVATE/tmp/room_height
	///The amount of rooms that fit between the top and bottom of the map in a single column. Loaded at runtime.
	VAR_PRIVATE/tmp/max_rooms_per_column
	///The amount of columns we reserve for placing down chargen rooms. This number also include incomplete columns. Loaded at runtime.
	VAR_PRIVATE/tmp/amount_columns

/datum/map_template/chargen/get_spawn_weight()
	return 1 //Must be loaded after the main template

/datum/map_template/chargen/is_runtime_generated()
	return TRUE

/datum/map_template/chargen/preload()
	var/datum/map_load_metadata/M = maploader.load_map(file(chargen_prefab_path), 1, 1, 1, cropMap=FALSE, measureOnly=TRUE, no_changeturf=TRUE, clear_contents=(template_flags & TEMPLATE_FLAG_CLEAR_CONTENTS), level_data_type=src.level_data_type)
	room_width  = M.bounds[MAP_MAXX]
	room_height = M.bounds[MAP_MAXY]
	tallness    = 1
	return TRUE

/datum/map_template/chargen/load_new_z(no_changeturf, centered)
	if(world.maxx <= 0 || world.maxy <= 0)
		CRASH("Couldn't load chargen template. The world x/y size was not set prior to loading the template!")

	max_rooms_per_column = FLOOR(world.maxy / room_height)
	amount_columns       = (amount_chargen_rooms / max_rooms_per_column)

	if(amount_columns <= 0)
		//If less than one full column, we're only occupying a limited height
		height = amount_chargen_rooms * room_height
	else
		//When more than one column, we use the full height of the world
		height = world.maxy
		//Make sure if we've got a remainder to add an extrac column
		amount_columns += (((amount_chargen_rooms % max_rooms_per_column) > 0)? 1 : 0)

	//Our with is tied to the nb of columns, and cannot be less than 1 time the pod width
	width = max(room_width * amount_columns, room_width)

	var/datum/level_data/chargen/LD = SSmapping.increment_world_z_size(level_data_type, TRUE)
	LD.setup_level_data(TRUE)
	report_progress("Placing [name] template.")
	gemerate_rooms(world.maxz)
	LD.generate_level()
	report_progress("Instantiated [name] template at Z: [LD.level_z].")
	return WORLD_CENTER_TURF(world.maxz)

/datum/map_template/chargen/proc/gemerate_rooms(cur_z)
	var/room_counter = 0
	//Fill up the rows and column of pods
	for(var/column in 1 to amount_columns)
		var/rows_this_column = min((amount_chargen_rooms - room_counter), max_rooms_per_column)
		for(var/row in 1 to rows_this_column)
			var/cur_min_x = ((column - 1) * room_width)  + 1
			var/cur_min_y = ((row - 1)    * room_height) + 1
			room_counter++
			maploader.load_map(file(chargen_prefab_path), cur_min_x, cur_min_y, cur_z, no_changeturf = TRUE)
			CHECK_TICK
