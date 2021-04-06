/datum/map/outreach
	name = "Outreach"
	full_name = "Outreach Outpost"
	path = "outreach"

	station_name  = "Outreach"
	station_short = "Outreach"

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

	radiation_detected_message = "High levels of radiation have been detected near the surface of %STATION_NAME%. Please move to a shielded area."

	lobby_screens = list(
		'maps/outreach/lobby/exoplanet.png'
	)

	starting_money = 5000
	department_money = 0
	salary_modifier = 0.2

	use_overmap = TRUE

/datum/map/outreach/get_map_info()
	return "You are en route to Outreach, a desolate planet previously targeted for mining operations, but now largely abandoned. Judges - corporate law enforcement - remain in the sector to keep the order. Colonists come from a wide variety of backgrounds, but universally with only the shirt on their backs."