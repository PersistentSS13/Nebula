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
/obj/abstract/level_data/exoplanet/outreach/underground/abyss
	name        = "Outreach Depths"
	level_id    = "outreach_abyss"
	connects_to = list("outreach_south_abyss" = SOUTH, "outreach_underground" = UP)
	level_flags = ZLEVEL_STATION | ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_SAVED | ZLEVEL_SEALED
	base_turf   = /turf/exterior/barren

/obj/abstract/level_data/exoplanet/outreach/underground
	name        = "Outreach Underground"
	level_id    = "outreach_underground"
	connects_to = list("outreach_south_underground" = SOUTH, "outreach_abyss" = DOWN, "outreach_surface" = UP)
	level_flags = ZLEVEL_STATION | ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_SAVED
	base_turf   = /turf/exterior/barren
	ambient_light_level = 0.2
	ambient_light_color = COLOR_YELLOW_GRAY

/obj/abstract/level_data/exoplanet/outreach
	name        = "Outreach Surface"
	level_id    = "outreach_surface"
	connects_to = list("outreach_south_mountain" = SOUTH, "outreach_underground" = DOWN, "outreach_sky" = UP)
	level_flags = ZLEVEL_STATION | ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_SAVED
	base_turf   = /turf/exterior/barren
	ambient_light_level = 0.7
	ambient_light_color = COLOR_GREEN_GRAY
	exterior_atmos_temp = OUTREACH_TEMP
	exterior_atmosphere = OUTREACH_ATMOS

/obj/abstract/level_data/exoplanet/outreach/sky
	name        = "Outreach Sky"
	level_id    = "outreach_sky"
	connects_to = list("outreach_surface" = DOWN)
	level_flags = ZLEVEL_STATION | ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_SAVED
	base_turf   = /turf/exterior/open

/////////////////////////////////////////////////////////////////////////////
// Adjacent Mining levels
/////////////////////////////////////////////////////////////////////////////
/obj/abstract/level_data/exoplanet/outreach/underground/abyss/south
	name           = "Outreach Southern Abyss"
	level_id       = "outreach_south_abyss"
	connects_to    = list("outreach_abyss" = NORTH, "outreach_south_underground" = UP)
	level_flags    = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_MINING
	level_gen_type = /datum/random_map/automata/cave_system/outreach/abyss
	base_turf      = /turf/exterior/barren/mining

/obj/abstract/level_data/exoplanet/outreach/underground/south
	name           = "Outreach Southern Underground"
	level_id       = "outreach_south_underground"
	connects_to    = list("outreach_underground" = NORTH, "outreach_south_abyss" = DOWN, "outreach_south_mountain" = UP)
	level_flags    = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_MINING
	level_gen_type = /datum/random_map/automata/cave_system/outreach/subterrane
	base_turf      = /turf/exterior/barren/mining

/obj/abstract/level_data/exoplanet/outreach/south
	name           = "Outreach Southern Mountain"
	level_id       = "outreach_south_mountain"
	connects_to    = list("outreach_surface" = NORTH, "outreach_south_underground" = DOWN)
	level_flags    = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_MINING
	level_gen_type = /datum/random_map/automata/cave_system/outreach/mountain
	base_turf      = /turf/exterior/barren/mining
