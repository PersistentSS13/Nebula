// These defines are moved here, as we don't want this to generate or require these paths when testing other maps.
/datum/map/kleibkhar
	overmap_ids = list(OVERMAP_ID_SPACE = /datum/overmap/kleibkhar)

/datum/map/kleibkhar/create_overmaps()
	if(!SSmapping.loaded_maps) // Don't do this during the startup phase since we haven't actually loaded the overmap yet.
		return
	. = ..()

/datum/overmap/kleibkhar
	event_areas = 0
	map_size_x = 50
	map_size_y = 50

	var/map_file = "maps/kleibkhar/kleibkhar-overmap.dmm"

/datum/overmap/kleibkhar/generate_overmap()
	testing("Building overmap [name]...")
	INCREMENT_WORLD_Z_SIZE
	assigned_z = world.maxz
	testing("Putting [name] on [assigned_z].")
	maploader.load_map(file(map_file), 1, 1, assigned_z)

	global.using_map.sealed_levels |= assigned_z
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