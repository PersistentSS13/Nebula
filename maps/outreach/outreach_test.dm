/datum/map/outreach
#ifndef UNIT_TEST
	// Hotloading module
	default_levels = list(
		"1" = "maps/outreach/outreach-1.dmm",
		"2" = "maps/outreach/outreach-2.dmm",
		"3" = "maps/outreach/outreach-3.dmm",
		"4" = "maps/outreach/outreach-4.dmm"
	)

#else
	default_levels = list(
		"4" = "maps/outreach/outreach-1.dmm",
		"5" = "maps/outreach/outreach-2.dmm",
		"6" = "maps/outreach/outreach-3.dmm",
		"7" = "maps/outreach/outreach-4.dmm"
	)

#endif
	lobby_tracks = list(
		/decl/music_track/dirtyoldfrogg
	)

/obj/abstract/level_data/exoplanet/outreach
	level_flags = ZLEVEL_PLAYER | ZLEVEL_SEALED | ZLEVEL_SAVED
	base_turf = /turf/exterior/barren
	exterior_atmosphere = list(
		/decl/material/gas/chlorine = MOLES_CELLSTANDARD,
		/decl/material/gas/nitrogen = MOLES_CELLSTANDARD,
	)

/obj/abstract/level_data/exoplanet/outreach/mining
	level_flags = ZLEVEL_PLAYER | ZLEVEL_SEALED | ZLEVEL_SAVED | ZLEVEL_MINING
	base_turf = /turf/exterior/barren
