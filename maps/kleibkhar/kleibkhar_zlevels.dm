///Map template for loading the kelbkhar map
/datum/map_template/persistent/kleibkhar
	name     = "planet kleibkhar"
	tallness = 4
	mappaths = list(
		"maps/kleibkhar/kleibkhar-1.dmm",
		"maps/kleibkhar/kleibkhar-2.dmm",
		"maps/kleibkhar/kleibkhar-3.dmm",
		"maps/kleibkhar/kleibkhar-4.dmm",
	)

//
// Leve Data
//

/datum/level_data/exoplanet/kleibkhar
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER|ZLEVEL_SAVED)
	ambient_light_level = 1.0
	base_area = /area/exoplanet/kleibkhar
	base_turf = /turf/exterior/kleibkhar_grass
	exterior_atmosphere = list(
		/decl/material/gas/oxygen =   MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)

/datum/level_data/exoplanet/kleibkhar/sky
	ambient_light_level = 1.0
	base_area = /area/exoplanet/kleibkhar/sky
	base_turf = /turf/exterior/open

/datum/level_data/exoplanet/kleibkhar/underground
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER|ZLEVEL_MINING)
	ambient_light_level = 0.1
	base_area = /area/exoplanet/kleibkhar/mines/depth_1
	base_turf = /turf/exterior/barren/mining

/datum/level_data/exoplanet/kleibkhar/underground/bottom
	ambient_light_level = 0.0
	base_area = /area/exoplanet/kleibkhar/mines/depth_2
	base_turf = /turf/exterior/barren/mining

//
// Spawners
//

/obj/abstract/level_data_spawner/exoplanet/kleibkhar
	level_data_type = /datum/level_data/exoplanet/kleibkhar

/obj/abstract/level_data_spawner/exoplanet/kleibkhar/sky
	level_data_type = /datum/level_data/exoplanet/kleibkhar/sky

/obj/abstract/level_data_spawner/exoplanet/kleibkhar/underground
	level_data_type = /datum/level_data/exoplanet/kleibkhar/underground

/obj/abstract/level_data_spawner/exoplanet/kleibkhar/underground/bottom
	level_data_type = /datum/level_data/exoplanet/kleibkhar/underground/bottom