/datum/map/outreach
#ifndef UNIT_TEST
	station_levels = list(1, 2, 3, 4)
	contact_levels = list(1, 2, 3, 4)
	player_levels = list(1, 2, 3, 4)
	saved_levels = list(3, 4)
	mining_levels = list(1, 2)

	// Hotloading module
	default_levels = list(
		"1" = "maps/outreach/outreach-1.dmm",
		"2" = "maps/outreach/outreach-2.dmm",
		"3" = "maps/outreach/outreach-3.dmm",
		"4" = "maps/outreach/outreach-4.dmm"
	)

	// A list of turfs and their default turfs for serialization optimization.
	base_turf_by_z = list(
		"1" = /turf/exterior/barren,
		"2" = /turf/exterior/barren,
		"3" = /turf/exterior/barren,
		"4" = /turf/simulated/open
	)
#else
	station_levels = list(4, 5, 6, 7)
	contact_levels = list(4, 5, 6, 7)
	player_levels = list(4, 5, 6, 7)
	saved_levels = list(6, 7)
	mining_levels = list(4, 5)

	default_levels = list(
		"4" = "maps/outreach/outreach-1.dmm",
		"5" = "maps/outreach/outreach-2.dmm",
		"6" = "maps/outreach/outreach-3.dmm",
		"7" = "maps/outreach/outreach-4.dmm"
	)

	// A list of turfs and their default turfs for serialization optimization.
	base_turf_by_z = list(
		"4" = /turf/exterior/barren,
		"5" = /turf/exterior/barren,
		"6" = /turf/exterior/barren,
		"7" = /turf/simulated/open
	)
#endif
	lobby_tracks = list(
		/decl/music_track/dirtyoldfrogg
	)