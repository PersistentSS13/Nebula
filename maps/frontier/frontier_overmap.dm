// These defines are moved here, as we don't want this to generate or require these paths when testing other maps.
/datum/map/kleibkhar
	overmap_ids = list(OVERMAP_ID_SPACE = /datum/overmap/frontier)

/datum/overmap/frontier
	event_areas = 0
	map_size_x = 50
	map_size_y = 50
	assigned_z = 4
	var/map_file = "maps/kleibkhar/frontier-overmap.dmm"

var/global/overmap_z

/obj/effect/overmap/overmap_marker

/obj/effect/overmap/overmap_marker/New()
	if(z)
		overmap_z = z
	loc = null
	qdel(src)
/datum/overmap/frontier/generate_overmap()
	if(overmap_z)
		assigned_z = overmap_z

	return ..()
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
