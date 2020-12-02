/datum/map/persistence
	name = "Outreach"
	full_name = "Outreach Outpost"
	path = "persistence"

	station_levels = list(1, 2, 3, 4)
	contact_levels = list(1, 2, 3, 4)
	player_levels = list(1, 2, 3, 4)
	saved_levels = list(3, 4)
	mining_areas = list(1, 2)

	// Hotloading module
	default_levels = list(
		"1" = 'maps/persistence/outreach_1_mine_2.dmm',
		"2" = 'maps/persistence/outreach_2_mine_1.dmm',
		"3" = 'maps/persistence/outreach_3_ground.dmm',
		"4" = 'maps/persistence/outreach_4_sky.dmm'
	)

	// A list of turfs and their default turfs for serialization optimization.
	base_turf_by_z = list(
		"1" = /turf/exterior/barren,
		"2" = /turf/exterior/barren,
		"3" = /turf/exterior/barren,
		"4" = /turf/simulated/open
	)

	overmap_size = 100
	overmap_event_areas = 250

	allowed_spawns = list("Cyrogenic Storage")
	default_spawn = "Cyrogenic Storage"

	shuttle_docked_message = "The shuttle has docked."
	shuttle_leaving_dock = "The shuttle has departed from home dock."
	shuttle_called_message = "A scheduled transfer shuttle has been sent."
	shuttle_recall_message = "The shuttle has been recalled"
	emergency_shuttle_docked_message = "The emergency escape shuttle has docked."
	emergency_shuttle_leaving_dock = "The emergency escape shuttle has departed from %dock_name%."
	emergency_shuttle_called_message = "An emergency escape shuttle has been sent."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled"

	lobby_screens = list(
		'maps/persistence/lobby/exoplanet.png'
	)
	lobby_tracks = list(
		/music_track/dirtyoldfrogg
	)

	starting_money = 5000
	department_money = 0
	salary_modifier = 0.2

	use_overmap = TRUE
