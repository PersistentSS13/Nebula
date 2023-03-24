/datum/map/kleibkhar
#ifndef UNIT_TEST
	// Hotloading module
	default_levels = list(
		"1" = "maps/kleibkhar/kleibkhar-1.dmm",
		"2" = "maps/kleibkhar/kleibkhar-2.dmm",
		"3" = "maps/kleibkhar/kleibkhar-3.dmm",
		"4" = "maps/kleibkhar/kleibkhar-4.dmm",
		"5" = "maps/utility/cargo_shuttle_tmpl.dmm",
	)

#else
	default_levels = list(
		"4" = "maps/kleibkhar/kleibkhar-1.dmm",
		"5" = "maps/kleibkhar/kleibkhar-2.dmm",
		"6" = "maps/kleibkhar/kleibkhar-3.dmm",
		"7" = "maps/kleibkhar/kleibkhar-4.dmm",
		"8" = "maps/utility/cargo_shuttle_tmpl.dmm",
	)
#endif

/obj/abstract/level_data/exoplanet/kleibkhar
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER|ZLEVEL_SAVED)
	ambient_light_level = 1.0
	base_turf = /turf/exterior/kleibkhar_grass
	exterior_atmosphere = list(
		/decl/material/gas/oxygen =   MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)

/obj/abstract/level_data/exoplanet/kleibkhar/sky
	ambient_light_level = 1.0
	base_turf = /turf/exterior/open

/obj/abstract/level_data/exoplanet/kleibkhar/underground
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER|ZLEVEL_MINING)
	ambient_light_level = 0.1
	base_turf = /turf/exterior/barren/mining

/obj/abstract/level_data/exoplanet/kleibkhar/underground/bottom
	ambient_light_level = 0.0
	base_turf = /turf/exterior/barren/mining