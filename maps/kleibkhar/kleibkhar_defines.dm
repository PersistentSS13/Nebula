/datum/map/kleibkhar
	name = "Kleibkhar"
	full_name = "Kleibkhar Colony"
	path = "kleibkhar"

	station_name  = "Kleibkhar Colony"
	station_short = "Kleibkhar Colony"

	use_overmap = TRUE
	evac_controller_type = /datum/evacuation_controller/lifepods

	starting_money = 5000
	department_money = 0
	salary_modifier = 0.2

	radiation_detected_message = "High levels of radiation have been detected near the surface of %STATION_NAME%. Please move to a shielded area."

/datum/map/kleibkhar/get_map_info()
	return "You're a colonist in the sector of the planet Kleibkhar, a lush planet targeted by a distant corporation to create a new consumer base. No government has authority in this sector, and colonists come from a wide variety of backgrounds, but universally with only the shirt on their backs."