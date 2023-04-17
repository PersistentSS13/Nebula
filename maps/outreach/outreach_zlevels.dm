/////////////////////////////////////////////////////////////////////////////
// Station Building Levels
/////////////////////////////////////////////////////////////////////////////
/datum/level_data/exoplanet/outreach/underground/abyss
	name             = "Outreach Depths"
	level_id         = "outreach_abyss"
	connected_levels = list("outreach_south_abyss" = SOUTH, "outreach_underground" = UP)
	base_turf        = /turf/exterior/volcanic/outreach/abyss
	base_area        = /area/exoplanet/outreach/underground/d2

/datum/level_data/exoplanet/outreach/underground
	name                = "Outreach Underground"
	level_id            = "outreach_underground"
	connected_levels    = list("outreach_south_underground" = SOUTH, "outreach_abyss" = DOWN, "outreach_surface" = UP)
	base_turf           = /turf/exterior/barren/subterrane/outreach
	base_area           = /area/exoplanet/outreach/underground/d1
	ambient_light_level = 0.2
	ambient_light_color = COLOR_YELLOW_GRAY
	border_filler       = /turf/unsimulated/mineral

/datum/level_data/exoplanet/outreach
	name                = "Outreach Surface"
	level_id            = "outreach_surface"
	level_flags         = ZLEVEL_STATION | ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_SAVED | ZLEVEL_SEALED
	connected_levels    = list("outreach_south_mountain" = SOUTH, "outreach_underground" = DOWN, "outreach_sky" = UP)
	base_area           = /area/exoplanet/outreach
	base_turf           = OUTREACH_SURFACE_TURF
	loop_turf_type      = /turf/exterior/mimic_edge/transition/loop
	border_filler       = /turf/unsimulated/dark_border
	ambient_light_level = 0.7
	ambient_light_color = COLOR_GREEN_GRAY
	exterior_atmos_temp = OUTREACH_TEMP
	exterior_atmosphere = OUTREACH_ATMOS

/datum/level_data/exoplanet/outreach/sky
	name             = "Outreach Sky"
	level_id         = "outreach_sky"
	connected_levels = list("outreach_surface" = DOWN)
	base_turf        = /turf/exterior/open
	base_area        = /area/exoplanet/outreach/sky

/////////////////////////////////////////////////////////////////////////////
// Adjacent Mining levels
/////////////////////////////////////////////////////////////////////////////
/datum/level_data/exoplanet/outreach/underground/abyss/south
	name             = "Outreach Southern Abyss"
	level_id         = "outreach_south_abyss"
	connected_levels = list("outreach_abyss" = NORTH, "outreach_south_underground" = UP)
	level_gen_type   = /datum/random_map/automata/cave_system/outreach/abyss
	base_turf        = /turf/exterior/volcanic/mining/outreach/abyss
	base_area        = /area/exoplanet/outreach/underground/mines/b2

/datum/level_data/exoplanet/outreach/underground/south
	name             = "Outreach Southern Underground"
	level_id         = "outreach_south_underground"
	connected_levels = list("outreach_underground" = NORTH, "outreach_south_abyss" = DOWN, "outreach_south_mountain" = UP)
	level_gen_type   = /datum/random_map/automata/cave_system/outreach/subterrane
	base_turf        = /turf/exterior/barren/mining/outreach/subterrane
	base_area        = /area/exoplanet/outreach/underground/mines/b1

/datum/level_data/exoplanet/outreach/south
	name             = "Outreach Southern Mountain"
	level_id         = "outreach_south_mountain"
	connected_levels = list("outreach_surface" = NORTH, "outreach_south_underground" = DOWN)
	level_flags      = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_MINING | ZLEVEL_SEALED | ZLEVEL_SAVED
	level_gen_type   = /datum/random_map/automata/cave_system/outreach/mountain
	base_turf        = /turf/exterior/barren/mining/outreach/mountain
	base_area        = /area/exoplanet/outreach/underground/mines/gf

/////////////////////////////////////////////////////////////////////////////
// Outreach level data spawners
/////////////////////////////////////////////////////////////////////////////

/obj/abstract/level_data_spawner/exoplanet/outreach
	name            = "outreach surface (level data spawner)"
	level_data_type = /datum/level_data/exoplanet/outreach

/obj/abstract/level_data_spawner/exoplanet/outreach/sky
	name            = "outreach sky (level data spawner)"
	level_data_type = /datum/level_data/exoplanet/outreach/sky

/obj/abstract/level_data_spawner/exoplanet/outreach/underground
	name            = "outreach underground (level data spawner)"
	level_data_type = /datum/level_data/exoplanet/outreach/underground

/obj/abstract/level_data_spawner/exoplanet/outreach/underground/abyss
	name            = "outreach depths (level data spawner)"
	level_data_type = /datum/level_data/exoplanet/outreach/underground/abyss

/////////////////////////////////////////////////////////////////////////////
// Outreach south level data spawners
/////////////////////////////////////////////////////////////////////////////

/obj/abstract/level_data_spawner/exoplanet/outreach/south
	name            = "outreach southern mountain (level data spawner)"
	level_data_type = /datum/level_data/exoplanet/outreach/south

/obj/abstract/level_data_spawner/exoplanet/outreach/underground/south
	name            = "outreach southern underground (level data spawner)"
	level_data_type = /datum/level_data/exoplanet/outreach/underground/south

/obj/abstract/level_data_spawner/exoplanet/outreach/underground/abyss/south
	name            = "outreach southern abyss (level data spawner)"
	level_data_type = /datum/level_data/exoplanet/outreach/underground/abyss/south