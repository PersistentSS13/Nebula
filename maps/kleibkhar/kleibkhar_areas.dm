//
// Outpost Interior
//
/area/kleibkhar
	name = "DONT USE ME"
	icon_state = "toilet"
	area_flags = AREA_FLAG_ION_SHIELDED | AREA_FLAG_RAD_SHIELDED

/area/kleibkhar/outpost
	name = "Outpost"
	base_turf = /turf/exterior/barren

/area/kleibkhar/outpost/arrivals
	name = "Arrivals"
	icon_state = "start"

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
	icon_state = "crew_quarters"

/area/kleibkhar/outpost/custodial
	name = "Custodial Cabinet"
	icon_state = "janitor"

/area/kleibkhar/outpost/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"

/area/kleibkhar/outpost/washroom
	name = "Washroom"
	icon_state = "restrooms"

/area/kleibkhar/outpost/cargo
	name = "Cargo Office"
	icon_state = "quart"

/area/kleibkhar/outpost/cargo/warehouse
	name = "Warehouse"
	icon_state = "quartstorage"

/area/kleibkhar/atmos_pump
	name = "Atmospheric Exchanger"
	icon_state = "atmos"
	is_outside = OUTSIDE_YES

//
// Planet Exterior
//
/area/exoplanet/kleibkhar
	name = "Kleibkhar"
	icon_state = "green"
	area_flags = AREA_FLAG_IS_BACKGROUND | AREA_FLAG_ION_SHIELDED | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_EXTERNAL
	base_turf = /turf/exterior/barren
	open_turf = /turf/exterior/barren //For now
	is_outside = OUTSIDE_YES

/area/exoplanet/kleibkhar/sky
	name = "Up Above"
	icon_state = "blueold"
	base_turf = /turf/open
	open_turf = /turf/open

/area/exoplanet/kleibkhar/mines
	name = "Deep Underground"
	icon_state = "cave"
	ignore_mining_regen = TRUE
	is_outside = OUTSIDE_NO
	base_turf = /turf/exterior/barren
	open_turf = /turf/open
	area_flags = AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_BACKGROUND | AREA_FLAG_ION_SHIELDED | AREA_FLAG_RAD_SHIELDED

/area/exoplanet/kleibkhar/mines/depth_1
	icon_state = "cave"
	ignore_mining_regen = FALSE

/area/exoplanet/kleibkhar/mines/depth_2
	name = "Deepest Underground"
	icon_state = "cave"
	ignore_mining_regen = FALSE

/area/exoplanet/kleibkhar/mines/exits
	name = "Mine Exit"
	icon_state = "exit"
	area_flags = AREA_FLAG_IS_BACKGROUND | AREA_FLAG_ION_SHIELDED | AREA_FLAG_RAD_SHIELDED

/area/exoplanet/kleibkhar/supply_shuttle_dock
	name = "Supply Shuttle Dock"
	icon_state = "yellow"
	base_turf = /turf/simulated/floor/plating //Needed for shuttles
	open_turf = /turf/exterior/barren
	area_flags = AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_BACKGROUND | AREA_FLAG_ION_SHIELDED | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_EXTERNAL
