/datum/map/kleibkhar
	default_levels = list(
		"maps/kleibkhar/kleibkhar-1.dmm" = null,
		"maps/kleibkhar/kleibkhar-2.dmm" = null,
		"maps/kleibkhar/kleibkhar-3.dmm" = /obj/abstract/level_data/exoplanet/kleibkhar,
		"maps/kleibkhar/kleibkhar-4.dmm" = /obj/abstract/level_data/exoplanet/kleibkhar/sky,
		"maps/utility/cargo_shuttle_tmpl.dmm" = null
	)
/obj/abstract/level_data/exoplanet/kleibkhar
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER|ZLEVEL_SAVED|ZLEVEL_NONDYNAMIC)
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