//Add to the default areas
/datum/map/outreach/New()
	. = ..()
	apc_test_exempt_areas[/area/turbolift/outreach/f1]                       = NO_SCRUBBER|NO_VENT|NO_APC
	apc_test_exempt_areas[/area/outreach/outpost/airlock]                    = NO_SCRUBBER|NO_VENT
	apc_test_exempt_areas[/area/outreach/outpost/maint/passage/f1/southwest] = NO_SCRUBBER|NO_VENT
	apc_test_exempt_areas[/area/outreach/outpost/maint/passage/f1/northwest] = NO_SCRUBBER|NO_VENT
	apc_test_exempt_areas[/area/outreach/outpost/storage_shed]               = NO_SCRUBBER|NO_VENT
	apc_test_exempt_areas[/area/outreach/outpost/maint/outer_wall]           = NO_SCRUBBER|NO_VENT|NO_APC
	apc_test_exempt_areas[/area/outreach/outpost/vacant]                     = NO_SCRUBBER|NO_VENT
	apc_test_exempt_areas[/area/outreach/outpost/vacant/ground/depot]        = 0
	apc_test_exempt_areas[/area/outreach/outpost/vacant/b1/south/east]       = 0
	apc_test_exempt_areas[/area/outreach/outpost/vacant/f1/swroom]           = NO_SCRUBBER|NO_VENT|NO_APC
	apc_test_exempt_areas[/area/outreach/outpost/vacant/ground/swroom]       = NO_SCRUBBER|NO_VENT|NO_APC
	apc_test_exempt_areas[/area/outreach/outpost/hangar/north/shuttle_area]  = NO_SCRUBBER|NO_VENT|NO_APC
	apc_test_exempt_areas[/area/outreach/outpost/control/servers]            = NO_SCRUBBER|NO_VENT

	apc_test_excluded_areas = list(
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

/datum/map_template/planetoid/persistent/outreach/get_spawn_weight()
	return 100
