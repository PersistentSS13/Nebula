/datum/map/outreach
	lobby_tracks = list(
		/decl/music_track/dirtyoldfrogg
	)

/datum/map_template/persistent/outreach
	name                 = "planet outreach"
	template_flags       = TEMPLATE_FLAG_SPAWN_GUARANTEED | TEMPLATE_FLAG_NO_RUINS
	modify_tag_vars      = FALSE
	template_categories  = list(MAP_TEMPLATE_CATEGORY_MAIN_SITE) //Templates must have a category, or they won't spawn
	tallness             = 4
	mappaths             = list(
		"maps/outreach/outreach-1.dmm",
		"maps/outreach/outreach-2.dmm",
		"maps/outreach/outreach-3.dmm",
		"maps/outreach/outreach-4.dmm"
	)

/datum/level_data/exoplanet/outreach
	level_flags = ZLEVEL_PLAYER | ZLEVEL_SEALED | ZLEVEL_SAVED
	base_turf = /turf/exterior/barren
	exterior_atmosphere = list(
		/decl/material/gas/chlorine = MOLES_CELLSTANDARD,
		/decl/material/gas/nitrogen = MOLES_CELLSTANDARD,
	)

/datum/exoplanet/outreach/mining
	level_flags = ZLEVEL_PLAYER | ZLEVEL_SEALED | ZLEVEL_SAVED | ZLEVEL_MINING
	base_turf = /turf/exterior/barren

/obj/abstract/level_data_spawner/exoplanet/outreach
	level_data_type = /datum/level_data/exoplanet/outreach

/obj/abstract/level_data_spawner/exoplanet/outreach/mining
	level_data_type = /datum/exoplanet/outreach/mining