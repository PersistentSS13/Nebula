SUBSYSTEM_DEF(quadrants)
	name = "Quadrants"
	wait = 3 SECONDS
	priority = SS_PRIORITY_QUADRANTS
	var/list/all_quadrants = list()
	var/list/wanted_quadrants = list() // list(/datum/overmap_quadrant/example, /datum/overmap_quadrant/faljourcorridor)

/atom/proc/get_quadrant()
	var/obj/effect/overmap/visitable/curr_sector = global.overmap_sectors["[z]"]
	if(curr_sector && SSquadrants) return SSquadrants.get_quadrant(curr_sector.loc)

/datum/controller/subsystem/quadrants/proc/get_quadrant(var/turf/T) // turf must be off the overmap
	for(var/datum/overmap_quadrant/quadrant in all_quadrants)
		if(quadrant.check_tile(T))
			return quadrant

/datum/controller/subsystem/quadrants/proc/get_adjacent_quadrants(var/datum/overmap_quadrant/parent) // turf must be off the overmap
	var/list/finished = list()
	for(var/datum/overmap_quadrant/quadrant in all_quadrants)
		if(quadrant.name in parent.adjacent_quadrants)
			finished |= quadrant
	return finished

/datum/controller/subsystem/quadrants/Destroy()
	QDEL_NULL_LIST(all_quadrants)
	. = ..()

/datum/controller/subsystem/quadrants/Initialize()
	all_quadrants = list()
#ifndef UNIT_TEST
	for(var/x in subtypesof(/datum/overmap_quadrant))
		var/datum/overmap_quadrant/quadrant = new x()
		all_quadrants |= quadrant
	for(var/datum/overmap_quadrant/quadrant in all_quadrants)
		var/list/final_adjacent = list()
		for(var/x in quadrant.adjacent_quadrants)
			for(var/datum/overmap_quadrant/quadrant2 in all_quadrants)
				if(x == quadrant2.name) final_adjacent |= quadrant2
		quadrant.adjacent_quadrants = final_adjacent

	for(var/obj/effect/quadrant_border/border in all_quadrant_turfs)
		for(var/datum/overmap_quadrant/quadrant in all_quadrants)
			if(border.name == quadrant.name)
				quadrant.bounds |= get_turf(border)
#endif
	. = ..()

/datum/controller/subsystem/quadrants/fire(resumed = FALSE)
	for(var/datum/overmap_quadrant/x in all_quadrants)
		x.process()
