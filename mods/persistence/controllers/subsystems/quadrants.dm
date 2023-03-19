SUBSYSTEM_DEF(quadrants)
	name = "Quadrants"
	wait = 1 MINUTE
	priority = SS_PRIORITY_QUADRANTS
	var/list/all_quadrants = list()
	var/list/wanted_quadrants = list(/datum/overmap_quadrant) // list(//obj/effect/overmap/trade_beacon/example, /obj/effect/overmap/trade_beacon/steel, /obj/effect/overmap/trade_beacon/xandahar)


/datum/controller/subsystem/quadrants/proc/get_quadrant(var/turf/T) // turf must be off the overmap
	for(var/datum/overmap_quadrant/quadrant in all_quadrants)
		if(quadrant.check_tile(T))
			return quadrant

/datum/controller/subsystem/quadrants/Destroy()
	QDEL_NULL_LIST(all_quadrants)
	. = ..()

/datum/controller/subsystem/quadrants/Initialize()
	all_quadrants = list()
#ifndef UNIT_TEST
	for(var/x in wanted_quadrants)
		var/datum/overmap_quadrant/quadrant = new x()
		all_quadrants |= quadrant
#endif
	. = ..()

/datum/controller/subsystem/quadrants/fire(resumed = FALSE)
	for(var/datum/overmap_quadrant/x in all_quadrants)
		x.regenerate_imports()
		x.regenerate_exports()
