/////////////////////////////////////////////////////////////////////////////
// Station Building Levels
/////////////////////////////////////////////////////////////////////////////
/datum/level_data/planetoid/outreach
	name                = "Outreach Surface"
	level_id            = OUTREACH_LEVEL_ID_SURFACE
	level_flags         = ZLEVEL_STATION | ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_SAVED | ZLEVEL_SEALED
	parent_planetoid    = OUTREACH_PLANETOID_ID
	base_area           = /area/exoplanet/outreach
	base_turf           = OUTREACH_SURFACE_TURF
	loop_turf_type      = /turf/exterior/mimic_edge/transition/loop
	border_filler       = /turf/unsimulated/dark_border
	ambient_light_level = 0.7
	ambient_light_color = COLOR_GREEN_GRAY
	exterior_atmos_temp = OUTREACH_TEMP
	exterior_atmosphere = OUTREACH_ATMOS
	connected_levels    = list(
		OUTREACH_LEVEL_ID_SKY            = UP,
		OUTREACH_LEVEL_ID_UNDERGROUND    = DOWN,
		OUTREACH_LEVEL_ID_SOUTH_MOUNTAIN = SOUTH,
	)

/datum/level_data/planetoid/outreach/sky
	name             = "Outreach Sky"
	level_id         = OUTREACH_LEVEL_ID_SKY
	base_turf        = /turf/exterior/open
	base_area        = /area/exoplanet/outreach/sky
	connected_levels = list(
		OUTREACH_LEVEL_ID_SURFACE = DOWN,
	)

/datum/level_data/planetoid/outreach/underground
	name                = "Outreach Underground"
	level_id            = OUTREACH_LEVEL_ID_UNDERGROUND
	base_turf           = /turf/exterior/barren/subterrane/outreach
	base_area           = /area/exoplanet/outreach/underground/d1
	ambient_light_level = 0.2
	ambient_light_color = COLOR_YELLOW_GRAY
	border_filler       = /turf/unsimulated/mineral
	connected_levels    = list(
		OUTREACH_LEVEL_ID_SURFACE           = UP,
		OUTREACH_LEVEL_ID_ABYSS             = DOWN,
		OUTREACH_LEVEL_ID_SOUTH_UNDERGROUND = SOUTH,
	)

/datum/level_data/planetoid/outreach/underground/abyss
	name             = "Outreach Depths"
	level_id         = OUTREACH_LEVEL_ID_ABYSS
	base_turf        = /turf/exterior/volcanic/outreach/abyss
	base_area        = /area/exoplanet/outreach/underground/d2
	connected_levels = list(
		OUTREACH_LEVEL_ID_UNDERGROUND = UP,
		OUTREACH_LEVEL_ID_SOUTH_ABYSS = SOUTH,
	)

/////////////////////////////////////////////////////////////////////////////
// Adjacent Mining levels
/////////////////////////////////////////////////////////////////////////////
/datum/level_data/planetoid/outreach/underground/abyss/south
	name             = "Outreach Southern Abyss"
	level_id         = OUTREACH_LEVEL_ID_SOUTH_ABYSS
	level_flags      = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_MINING | ZLEVEL_SAVED | ZLEVEL_SEALED
	level_gen_type   = /datum/random_map/automata/cave_system/outreach/abyss
	base_turf        = /turf/exterior/volcanic/mining/outreach/abyss
	base_area        = /area/exoplanet/outreach/underground/mines/b2
	connected_levels = list(
		OUTREACH_LEVEL_ID_SOUTH_UNDERGROUND = UP,
		OUTREACH_LEVEL_ID_ABYSS             = NORTH,
	)

/datum/level_data/planetoid/outreach/underground/south
	name             = "Outreach Southern Underground"
	level_id         = OUTREACH_LEVEL_ID_SOUTH_UNDERGROUND
	level_flags      = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_MINING | ZLEVEL_SAVED | ZLEVEL_SEALED
	level_gen_type   = /datum/random_map/automata/cave_system/outreach/subterrane
	base_turf        = /turf/exterior/barren/mining/outreach/subterrane
	base_area        = /area/exoplanet/outreach/underground/mines/b1
	connected_levels = list(
		OUTREACH_LEVEL_ID_SOUTH_MOUNTAIN = UP,
		OUTREACH_LEVEL_ID_SOUTH_ABYSS    = DOWN,
		OUTREACH_LEVEL_ID_UNDERGROUND    = NORTH,
	)

/datum/level_data/planetoid/outreach/south
	name             = "Outreach Southern Mountain"
	level_id         = OUTREACH_LEVEL_ID_SOUTH_MOUNTAIN
	level_flags      = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_MINING | ZLEVEL_SAVED | ZLEVEL_SEALED
	level_gen_type   = /datum/random_map/automata/cave_system/outreach/mountain
	base_turf        = /turf/exterior/barren/mining/outreach/mountain
	base_area        = /area/exoplanet/outreach/underground/mines/gf
	connected_levels = list(
		OUTREACH_LEVEL_ID_SURFACE           = NORTH,
		OUTREACH_LEVEL_ID_SOUTH_UNDERGROUND = DOWN,
	)

/////////////////////////////////////////////////////////////////////////////
// Outreach level data spawners
/////////////////////////////////////////////////////////////////////////////

/obj/abstract/level_data_spawner/exoplanet/outreach
	name            = "outreach surface (level data spawner)"
	level_data_type = /datum/level_data/planetoid/outreach

/obj/abstract/level_data_spawner/exoplanet/outreach/sky
	name            = "outreach sky (level data spawner)"
	level_data_type = /datum/level_data/planetoid/outreach/sky

/obj/abstract/level_data_spawner/exoplanet/outreach/underground
	name            = "outreach underground (level data spawner)"
	level_data_type = /datum/level_data/planetoid/outreach/underground

/obj/abstract/level_data_spawner/exoplanet/outreach/underground/abyss
	name            = "outreach depths (level data spawner)"
	level_data_type = /datum/level_data/planetoid/outreach/underground/abyss

/////////////////////////////////////////////////////////////////////////////
// Outreach south level data spawners
/////////////////////////////////////////////////////////////////////////////

/obj/abstract/level_data_spawner/exoplanet/outreach/south
	name            = "outreach southern mountain (level data spawner)"
	level_data_type = /datum/level_data/planetoid/outreach/south

/obj/abstract/level_data_spawner/exoplanet/outreach/underground/south
	name            = "outreach southern underground (level data spawner)"
	level_data_type = /datum/level_data/planetoid/outreach/underground/south

/obj/abstract/level_data_spawner/exoplanet/outreach/underground/abyss/south
	name            = "outreach southern abyss (level data spawner)"
	level_data_type = /datum/level_data/planetoid/outreach/underground/abyss/south