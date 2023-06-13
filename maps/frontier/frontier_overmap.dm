// These defines are moved here, as we don't want this to generate or require these paths when testing other maps.
/datum/map/kleibkhar
	overmap_ids = list(OVERMAP_ID_SPACE = /datum/overmap/frontier)

/datum/overmap/frontier
	event_areas = 0
	map_size_x = 50
	map_size_y = 50

	var/map_file = "maps/kleibkhar/frontier-overmap.dmm"

/datum/overmap/frontier/generate_overmap()
	..()
	log_and_message_admins("assigned_z : [assigned_z]")

	maploader.load_map(file("maps/frontier/frontier-overmap.dmm"), 1, 1, assigned_z)
	testing("Overmap build for [name] complete.")

/obj/effect/shuttle_landmark/supply/station
	landmark_tag = "nav_cargo_station"
	docking_controller = "cargo_bay"
	base_area = /area/exoplanet/kleibkhar/supply_shuttle_dock
	base_turf = /turf/simulated/floor/plating

//supply
/datum/shuttle/autodock/ferry/supply/cargo
	name = "Supply"
	warmup_time = 10
	location = 1
	dock_target = "supply_shuttle"
	waypoint_station = "nav_cargo_station"
