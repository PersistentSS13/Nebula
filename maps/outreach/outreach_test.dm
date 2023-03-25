/datum/map/outreach
	// Hotloading module
	default_levels = list(
		"maps/outreach/outreach-1.dmm" = null,
		"maps/outreach/outreach-2.dmm" = null,
		"maps/outreach/outreach-3.dmm" = /obj/abstract/level_data/exoplanet/outreach,
		"maps/outreach/outreach-4.dmm" = /obj/abstract/level_data/exoplanet/outreach/sky
	)
	lobby_tracks = list(
		/decl/music_track/dirtyoldfrogg
	)

/obj/abstract/level_data/exoplanet/outreach
	level_flags = ZLEVEL_PLAYER | ZLEVEL_SEALED | ZLEVEL_SAVED | ZLEVEL_NONDYNAMIC
	base_turf = /turf/exterior/barren
	exterior_atmosphere = list(
		/decl/material/gas/chlorine = MOLES_CELLSTANDARD,
		/decl/material/gas/nitrogen = MOLES_CELLSTANDARD,
	)

/obj/abstract/level_data/exoplanet/outreach/sky
	base_turf = /turf/exterior/open

/obj/abstract/level_data/exoplanet/outreach/mining
	level_flags = ZLEVEL_PLAYER | ZLEVEL_SEALED | ZLEVEL_SAVED | ZLEVEL_MINING | ZLEVEL_NONDYNAMIC
	base_turf = /turf/exterior/barren
