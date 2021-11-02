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

/datum/overmap/kleibkhar/generate_overmap()
	// Since the Kleibkhar Overmap is premapped, we just locate it here and set the appropriate vars.
	// TODO: This can probably be done without having an external .dmm using a few map templates.
	var/area/overmap_area = locate(map_area_type) in global.areas
	for(var/turf/T in overmap_area)
		assigned_z = T.z
		break
	if(!assigned_z)
		CRASH("Kleibkhar Overmap could not locate its assigned z-level!")
	
	global.using_map.sealed_levels |= assigned_z
	testing("Overmap build for [name] complete.")