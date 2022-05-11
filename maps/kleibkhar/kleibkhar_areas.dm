/datum/map/kleibkhar
	apc_test_exempt_areas = list(
		/area/kleibkhar/atmos_pump = NO_VENT|NO_APC, //Area meant to fool unit tests, because they're being a bit assinine
	)
	area_coherency_test_exempt_areas = list(
		/area/kleibkhar/atmos_pump,
	)

//
// Outpost Interior
//
/area/kleibkhar/outpost
	area_flags = AREA_FLAG_ION_SHIELDED | AREA_FLAG_RAD_SHIELDED

/area/kleibkhar/outpost/sleeproom
	name = "Cyrogenic Storage"
	icon_state = "cryo"

/area/kleibkhar/outpost/hallway
	name = "Hallways"
	icon_state = "hallC1"

/area/kleibkhar/outpost/computer
	name = "Computer Room"
	icon_state = "green"

/area/kleibkhar/outpost/it
	name = "Server Room"
	icon_state = "server"

/area/kleibkhar/outpost/mining
	name = "Ore Processing Room"
	icon_state = "green"

/area/kleibkhar/outpost/cloning
	name = "Cloning Room"
	icon_state = "green"

/area/kleibkhar/outpost/infirmary
	name = "Infirmary"
	icon_state = "medbay"

/area/kleibkhar/outpost/infirmary/exam
	name = "Examination Room"
	icon_state = "exam_room"

/area/kleibkhar/outpost/infirmary/surgery
	name = "Surgery Room"
	icon_state = "surgery"

/area/kleibkhar/outpost/infirmary/storage
	name = "Storage Room"
	icon_state = "storage"

/area/kleibkhar/outpost/solar_array
	name = "Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/kleibkhar/outpost/mess_hall
	name = "Mess Hall"
	icon_state = "cafetaria"

/area/kleibkhar/outpost/custodial
	name = "Custodial Cabinet"
	icon_state = "janitor"

/area/kleibkhar/outpost/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"

/area/kleibkhar/outpost/washroom
	name = "Washroom"
	icon_state = "restrooms"

/area/kleibkhar/atmos_pump
	name = "Atmospheric Exchanger"
	icon_state = "atmos"

//
// Planet Exterior
//
/area/exoplanet/kleibkhar
	name = "Kleibkhar"
	area_flags = AREA_FLAG_IS_BACKGROUND | AREA_FLAG_ION_SHIELDED | AREA_FLAG_RAD_SHIELDED
	dynamic_lighting = FALSE
	base_turf = /turf/exterior/barren

/area/exoplanet/kleibkhar/mines
	name = "Deep Underground"
	icon_state = "unknown"
	ignore_mining_regen = TRUE

/area/exoplanet/kleibkhar/mines/depth_1
	icon_state = "cave"
	ignore_mining_regen = FALSE

/area/exoplanet/kleibkhar/mines/depth_2
	icon_state = "cave"
	ignore_mining_regen = FALSE

/area/exoplanet/kleibkhar/mines/exits
	icon_state = "exit"