/datum/map/outreach
#ifndef UNIT_TEST
	// Hotloading module
	default_levels = list(
		"maps/outreach/outreach-1.dmm",
		"maps/outreach/outreach-2.dmm",
		"maps/outreach/outreach-3.dmm",
		"maps/outreach/outreach-4.dmm",
		"maps/outreach/outreach_south-1.dmm",
		"maps/outreach/outreach_south-2.dmm",
		"maps/outreach/outreach_south-3.dmm",
	)

#else
	default_levels = list(
		"maps/outreach/outreach-1.dmm",
		"maps/outreach/outreach-2.dmm",
		"maps/outreach/outreach-3.dmm",
		"maps/outreach/outreach-4.dmm",
		"maps/outreach/outreach_south-1.dmm",
		"maps/outreach/outreach_south-2.dmm",
		"maps/outreach/outreach_south-3.dmm",
	)
#endif

/////////////////////////////////////////////////////////////////////////////
// Station Building Levels
/////////////////////////////////////////////////////////////////////////////
/obj/abstract/level_data/player_level/outreach_1
	name        = "Outreach Depths"
	level_id    = "outreach_1"
	connects_to = list("outreach_south_1" = SOUTH, "outreach_2" = UP)
	level_flags = ZLEVEL_STATION | ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_PERSISTENT
	base_turf   = /turf/exterior/barren

/obj/abstract/level_data/player_level/outreach_2
	name        = "Outreach Underground"
	level_id    = "outreach_2"
	connects_to = list("outreach_south_2" = SOUTH, "outreach_1" = DOWN, "outreach_3" = UP)
	level_flags = ZLEVEL_STATION | ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_PERSISTENT
	base_turf   = /turf/exterior/barren

/obj/abstract/level_data/player_level/outreach_3
	name        = "Outreach Surface"
	level_id    = "outreach_3"
	connects_to = list("outreach_south_3" = SOUTH, "outreach_2" = DOWN, "outreach_4" = UP)
	level_flags = ZLEVEL_STATION | ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_PERSISTENT
	base_turf   = /turf/exterior/barren

/obj/abstract/level_data/player_level/outreach_4
	name        = "Outreach Sky"
	level_id    = "outreach_4"
	connects_to = list("outreach_3" = DOWN)
	level_flags = ZLEVEL_STATION | ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_PERSISTENT
	base_turf   = /turf/exterior/open

/////////////////////////////////////////////////////////////////////////////
// Adjacent Mining levels
/////////////////////////////////////////////////////////////////////////////
/obj/abstract/level_data/player_level/outreach_1/south
	name           = "Outreach Southern Abyss"
	level_id       = "outreach_south_1"
	connects_to    = list("outreach_1" = NORTH, "outreach_south_2" = UP)
	level_flags    = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_MINING
	level_gen_type = /datum/random_map/automata/cave_system/outreach/abyss
	base_turf      = /turf/exterior/barren/mining

/obj/abstract/level_data/player_level/outreach_2/south
	name           = "Outreach Southern Underground"
	level_id       = "outreach_south_2"
	connects_to    = list("outreach_2" = NORTH, "outreach_south_1" = DOWN, "outreach_south_3" = UP)
	level_flags    = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_MINING
	level_gen_type = /datum/random_map/automata/cave_system/outreach/subterrane
	base_turf      = /turf/exterior/barren/mining

/obj/abstract/level_data/player_level/outreach_3/south
	name           = "Outreach Southern Mountain"
	level_id       = "outreach_south_3"
	connects_to    = list("outreach_3" = NORTH, "outreach_south_2" = DOWN)
	level_flags    = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_MINING
	level_gen_type = /datum/random_map/automata/cave_system/outreach/mountain
	base_turf      = /turf/exterior/barren/mining
