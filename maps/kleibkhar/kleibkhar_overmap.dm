// These defines are moved here, as we don't want this to generate or require these paths when testing other maps.
/datum/map/kleibkhar
	overmap_ids = list(OVERMAP_ID_SPACE = /datum/overmap/kleibkhar)

// Dummy object for the star at the center of the solar system.
/obj/effect/overmap/star/oesepilus
	name  = "Oesepilos"
	desc  = "A yellow dwarf star late in its life cycle, approaching the end of its main sequence."
	color = "#e4e684"

/datum/overmap/kleibkhar
	event_areas = 12
	map_size_x  = 64
	map_size_y  = 64

/datum/overmap/kleibkhar/populate_overmap()
	. = ..()
	var/turf/overmap_center = locate(round(map_size_x/2), round(map_size_y/2), assigned_z)
	new /obj/effect/overmap/star/oesepilus(overmap_center)
