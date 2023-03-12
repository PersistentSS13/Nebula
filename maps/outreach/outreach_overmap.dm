// These defines are moved here, as we don't want this to generate or require these paths when testing other maps.
/datum/map/outreach
	overmap_ids = list(OVERMAP_ID_SPACE = /datum/overmap/outreach)

/obj/effect/overmap/star/outreach
	name = "Castor"

/////////////////////////////////////////////////////////////////////////////////
// Overmap Details
/////////////////////////////////////////////////////////////////////////////////
/datum/overmap/outreach
	event_areas = 10
	map_size_x  = 50
	map_size_y  = 50

/datum/overmap/outreach/populate_overmap()
	. = ..()
	var/turf/overmap_center = locate(round(map_size_x/2), round(map_size_y/2), assigned_z)
	new /obj/effect/overmap/star/outreach(overmap_center)
