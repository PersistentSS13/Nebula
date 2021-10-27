/datum/overmap/kleibkhar
	event_areas = 0
	map_size_x = 50
	map_size_y = 50

/datum/overmap/kleibkhar/generate_overmap()
	log_world("Max-z is [world.maxz]")
	// Since the Kleibkhar Overmap is premapped, we just locate it here and set the appropriate vars.
	// TODO: This can probably be done without having an external .dmm using a few map templates.
	var/area/overmap_area = locate(map_area_type) in world
	for(var/turf/T in overmap_area)
		assigned_z = T.z
		break
	if(!assigned_z)
		CRASH("Kleibkhar Overmap could not locate its assigned z-level!")
	
	global.using_map.sealed_levels |= assigned_z
	testing("Overmap build for [name] complete.")

/datum/map/kleibkhar/create_overmaps()
	if(!SSmapping.loaded_maps) // Don't do this during the startup phase since we haven't actually loaded the overmap yet.
		return
	. = ..()
	