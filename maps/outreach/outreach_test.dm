/datum/map/outreach
#ifndef UNIT_TEST
	station_levels = list(1, 2, 3, 4)
	contact_levels = list(1, 2, 3, 4)
	player_levels = list(1, 2, 3, 4)
	saved_levels = list(3, 4)
	mining_areas = list(1, 2)

	// Hotloading module
	default_levels = list(
		"1" = 'maps/outreach/outreach-1.dmm',
		"2" = 'maps/outreach/outreach-2.dmm',
		"3" = 'maps/outreach/outreach-3.dmm',
		"4" = 'maps/outreach/outreach-4.dmm'
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
	mining_areas = list(4, 5)

	default_levels = list(
		"4" = 'maps/outreach/outreach-1.dmm',
		"5" = 'maps/outreach/outreach-2.dmm',
		"6" = 'maps/outreach/outreach-3.dmm',
		"7" = 'maps/outreach/outreach-4.dmm'
	)

	// A list of turfs and their default turfs for serialization optimization.
	base_turf_by_z = list(
		"4" = /turf/exterior/barren,
		"5" = /turf/exterior/barren,
		"6" = /turf/exterior/barren,
		"7" = /turf/simulated/open
	)
#endif

	overmap_size = 100
	overmap_event_areas = 250

	allowed_spawns = list("Cryogenic Storage")
	default_spawn = "Cryogenic Storage"

	shuttle_docked_message = "The shuttle has docked."
	shuttle_leaving_dock = "The shuttle has departed from home dock."
	shuttle_called_message = "A scheduled transfer shuttle has been sent."
	shuttle_recall_message = "The shuttle has been recalled"
	emergency_shuttle_docked_message = "The emergency escape shuttle has docked."
	emergency_shuttle_leaving_dock = "The emergency escape shuttle has departed from %dock_name%."
	emergency_shuttle_called_message = "An emergency escape shuttle has been sent."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled"

	lobby_screens = list(
		'maps/outreach/lobby/exoplanet.png'
	)
	lobby_tracks = list(
		/decl/music_track/dirtyoldfrogg
	)

	starting_money = 5000
	department_money = 0
	salary_modifier = 0.2

	use_overmap = TRUE
