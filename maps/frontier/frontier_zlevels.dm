///Map template for loading the kelbkhar map
/datum/map_template/persistent/frontier
	name                 = "Xanadu"
	template_flags       = TEMPLATE_FLAG_SPAWN_GUARANTEED | TEMPLATE_FLAG_NO_RUINS
	modify_tag_vars      = FALSE
	template_categories  = list(MAP_TEMPLATE_CATEGORY_MAIN_SITE) //Templates must have a category, or they won't spawn
	tallness             = 4
	mappaths             = list(
		"maps/frontier/frontier-1.dmm",
		"maps/frontier/frontier-2.dmm",
		"maps/frontier/frontier-3.dmm",
		"maps/frontier/frontier-4.dmm",
	)

///////////////////////////////////////////////////////////////////////////////
// Leve Data
///////////////////////////////////////////////////////////////////////////////
/datum/map/frontier


/datum/level_data/exoplanet/kleibkhar
	name                = "kleibkhar surface"
	level_id            = "kleibkhar_surface"
	level_flags         = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_SAVED
	ambient_light_level = 1.0
	base_area           = /area/exoplanet/kleibkhar
	base_turf           = /turf/exterior/kleibkhar_grass
	loop_turf_type      = /turf/exterior/mimic_edge/transition/loop
	border_filler       = /turf/unsimulated/dark_border
	exterior_atmosphere = list(
		/decl/material/gas/oxygen =   MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)

/datum/level_data/exoplanet/kleibkhar/sky
	name                = "kleibkhar sky"
	level_id            = "kleibkhar_sky"
	ambient_light_level = 1.0
	base_area           = /area/exoplanet/kleibkhar/sky
	base_turf           = /turf/exterior/open

/datum/level_data/exoplanet/kleibkhar/underground
	name                = "kleibkhar underground"
	level_id            = "kleibkhar_underground"
	level_flags         = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_MINING | ZLEVEL_SAVED
	ambient_light_level = 0.2
	base_area           = /area/exoplanet/kleibkhar/mines/depth_1
	base_turf           = /turf/exterior/barren/mining
	border_filler       = /turf/unsimulated/mineral

/datum/level_data/exoplanet/kleibkhar/underground/bottom
	name                = "kleibkhar abyss"
	level_id            = "kleibkhar_abyss"
	ambient_light_level = 0.1
	base_area           = /area/exoplanet/kleibkhar/mines/depth_2
	base_turf           = /turf/exterior/barren/mining

///////////////////////////////////////////////////////////////////////////////
// Spawners
///////////////////////////////////////////////////////////////////////////////

/obj/abstract/level_data_spawner/exoplanet/kleibkhar
	name            = "kleibkhar surface (level data spawner)"
	level_data_type = /datum/level_data/exoplanet/kleibkhar

/obj/abstract/level_data_spawner/exoplanet/kleibkhar/sky
	name            = "kleibkhar sky (level data spawner)"
	level_data_type = /datum/level_data/exoplanet/kleibkhar/sky

/obj/abstract/level_data_spawner/exoplanet/kleibkhar/underground
	name            = "kleibkhar underground (level data spawner)"
	level_data_type = /datum/level_data/exoplanet/kleibkhar/underground

/obj/abstract/level_data_spawner/exoplanet/kleibkhar/underground/bottom
	name            = "kleibkhar abyss (level data spawner)"
	level_data_type = /datum/level_data/exoplanet/kleibkhar/underground/bottom