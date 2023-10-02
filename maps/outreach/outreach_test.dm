//Add to the default areas
/datum/map/outreach/New()
	. = ..()
	apc_test_exempt_areas |= list(
		/area/turbolift/outreach/f1                       = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/outreach/outpost/airlock                    = NO_SCRUBBER|NO_VENT,
		/area/outreach/outpost/maint/passage/f1/southwest = NO_SCRUBBER|NO_VENT,
		/area/outreach/outpost/maint/passage/f1/northwest = NO_SCRUBBER|NO_VENT,
		/area/outreach/outpost/storage_shed               = NO_SCRUBBER|NO_VENT,
		/area/outreach/outpost/maint/outer_wall           = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/outreach/outpost/vacant                     = NO_SCRUBBER|NO_VENT,
		/area/outreach/outpost/vacant/ground/depot        = 0,
		/area/outreach/outpost/vacant/b1/south/east       = 0,
		/area/outreach/outpost/hangar/north/shuttle_area  = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/outreach/outpost/control/servers            = NO_SCRUBBER|NO_VENT,
	)
	apc_test_excluded_areas |= list(
		/area/exoplanet,
		/area/turbolift,
		/area/outreach/outpost/atmospherics/b2/tank_outer, //Exterior
		/area/outreach/outpost/engineering/b2/geothermals, //Exterior
	)

/datum/map_template/planetoid/persistent/outreach
	name                 = "planet outreach"
	template_flags       = TEMPLATE_FLAG_SPAWN_GUARANTEED | TEMPLATE_FLAG_NO_RUINS
	modify_tag_vars      = FALSE
	template_categories  = list(MAP_TEMPLATE_CATEGORY_MAIN_SITE) //Templates must have a category, or they won't spawn
	planetoid_data_type  = /datum/planetoid_data/outreach
	tallness             = 4
	mappaths             = list(
		"maps/outreach/outreach-1.dmm",
		"maps/outreach/outreach-2.dmm",
		"maps/outreach/outreach-3.dmm",
		"maps/outreach/outreach-4.dmm",
		"maps/outreach/outreach_south-1.dmm",
		"maps/outreach/outreach_south-2.dmm",
		"maps/outreach/outreach_south-3.dmm",
	)

/datum/level_data/planetoid/exoplanet/outreach
	name                = "outreach surface"
	level_id            = "outreach_surface"
	parent_planetoid    = "outreach"
	level_flags         = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_SEALED | ZLEVEL_SAVED
	ambient_light_level = 0.8
	base_area           = /area/exoplanet/outreach
	base_turf           = /turf/exterior/barren
	loop_turf_type      = /turf/exterior/mimic_edge/transition/loop
	border_filler       = /turf/unsimulated/dark_border

/datum/level_data/planetoid/exoplanet/outreach/sky
	name                = "outreach sky"
	level_id            = "outreach_sky"
	base_area           = /area/exoplanet/outreach/sky
	base_turf           = /turf/exterior/open

/datum/level_data/planetoid/exoplanet/outreach/mining
	name                = "outreach mines"
	level_id            = "outreach_mines"
	level_flags         = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_SEALED | ZLEVEL_SAVED | ZLEVEL_MINING
	base_area           = /area/exoplanet/outreach/underground/mines/b1
	base_turf           = /turf/exterior/barren
	border_filler       = /turf/unsimulated/mineral

/datum/level_data/planetoid/exoplanet/outreach/mining/bottom
	name                = "outreach mines bottom"
	level_id            = "outreach_mines_bottom"
	base_area           = /area/exoplanet/outreach/underground/mines/b2

/obj/abstract/level_data_spawner/exoplanet/outreach
	name            = "outreach surface (level data spawner)"
	level_data_type = /datum/level_data/planetoid/exoplanet/outreach

/obj/abstract/level_data_spawner/exoplanet/outreach/sky
	name            = "outreach sky (level data spawner)"
	level_data_type = /datum/level_data/planetoid/exoplanet/outreach/sky

/obj/abstract/level_data_spawner/exoplanet/outreach/mining
	name            = "outreach mines (level data spawner)"
	level_data_type = /datum/level_data/planetoid/exoplanet/outreach/mining

/obj/abstract/level_data_spawner/exoplanet/outreach/mining/bottom
	name            = "outreach mines bottom (level data spawner)"
	level_data_type = /datum/level_data/planetoid/exoplanet/outreach/mining/bottom