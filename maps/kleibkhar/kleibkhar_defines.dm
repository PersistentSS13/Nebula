/datum/map/kleibkhar
	name = "Kleibkhar"
	full_name = "Kleibkhar Colony"
	path = "kleibkhar"

	station_name  = "Kleibkhar Colony"
	station_short = "Kleibkhar Colony"

	use_overmap = TRUE
	evac_controller_type = /datum/evacuation_controller/lifepods

	radiation_detected_message = "High levels of radiation have been detected near the surface of %STATION_NAME%. Please move to a shielded area."

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
		'maps/kleibkhar/lobby/KleibkharTitle.gif'
	)
	lobby_tracks = list(
		/decl/music_track/inorbit
	)

	starting_money = 5000
	department_money = 0
	salary_modifier = 0.2

/datum/map/kleibkhar/get_map_info()
	return "You're a colonist on the planet Kleibkhar, a lush planet targeted for development by corporation to create a new consumer base. No government has authority in this sector. Colonists come from a wide variety of backgrounds, but universally with only the shirt on their backs."