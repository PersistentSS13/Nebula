/datum/map/kleibkhar
	name = "Kleibkhar"
	full_name = "Kleibkhar Colony"
	path = "kleibkhar"

	station_name  = "Kleibkhar Colony"
	station_short = "Kleibkhar Colony"

	evac_controller_type = /datum/evacuation_controller/lifepods

	radiation_detected_message = "High levels of radiation have been detected near the surface of %STATION_NAME%. Please move to a shielded area."

	allowed_spawns = list(/decl/spawnpoint/cryo)
	default_spawn = /decl/spawnpoint/cryo
	shuttle_docked_message = "The shuttle has docked."
	shuttle_leaving_dock = "The shuttle has departed from home dock."
	shuttle_called_message = "A scheduled transfer shuttle has been sent."
	shuttle_recall_message = "The shuttle has been recalled"
	emergency_shuttle_docked_message = "The emergency escape shuttle has docked."
	emergency_shuttle_leaving_dock = "The emergency escape shuttle has departed from %dock_name%."
	emergency_shuttle_called_message = "An emergency escape shuttle has been sent."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled"

	lobby_screens = list(
		'maps/kleibkhar/lobby/KleibkharTitle.gif'
	)
	lobby_tracks = list(
		/decl/music_track/inorbit
	)

	starting_money = 5000
	department_money = 0
	salary_modifier = 0.2

#ifndef UNIT_TEST
	station_levels = list(1, 2, 3, 4)
	contact_levels = list(1, 2, 3, 4)
	player_levels = list(1, 2, 3, 4)
	saved_levels = list(3, 4)
	mining_levels = list(1, 2)

	// Hotloading module
	default_levels = list(
		"1" = "maps/kleibkhar/kleibkhar-1.dmm",
		"2" = "maps/kleibkhar/kleibkhar-2.dmm",
		"3" = "maps/kleibkhar/kleibkhar-3.dmm",
		"4" = "maps/kleibkhar/kleibkhar-4.dmm",
		"5" = "maps/utility/cargo_shuttle_tmpl.dmm",
	)

	// A list of turfs and their default turfs for serialization optimization.
	base_turf_by_z = list(
		"1" = /turf/exterior/barren/mining,
		"2" = /turf/exterior/barren/mining,
		"3" = /turf/exterior/kleibkhar_grass,
		"4" = /turf/exterior/open,
		"5" = /turf/space,
	)
#else
	station_levels = list(4, 5, 6, 7)
	contact_levels = list(4, 5, 6, 7)
	player_levels = list(4, 5, 6, 7)
	saved_levels = list(6, 7)
	mining_levels = list(4, 5)

	default_levels = list(
		"4" = "maps/kleibkhar/kleibkhar-1.dmm",
		"5" = "maps/kleibkhar/kleibkhar-2.dmm",
		"6" = "maps/kleibkhar/kleibkhar-3.dmm",
		"7" = "maps/kleibkhar/kleibkhar-4.dmm",
		"8" = "maps/utility/cargo_shuttle_tmpl.dmm",
	)

	// A list of turfs and their default turfs for serialization optimization.
	base_turf_by_z = list(
		"4" = /turf/exterior/barren/mining,
		"5" = /turf/exterior/barren/mining,
		"6" = /turf/exterior/kleibkhar_grass,
		"7" = /turf/exterior/open,
		"8" = /turf/space,
	)
#endif

/datum/map/kleibkhar/get_map_info()
	return "Kleibkhar Independent Colony. A diverse new commercial venture on the fringe of known space."

//No point increase over time
/datum/controller/subsystem/supply/Initialize()
	. = ..()
	points = 0
	points_per_process = 0