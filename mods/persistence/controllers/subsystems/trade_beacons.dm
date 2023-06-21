SUBSYSTEM_DEF(trade_beacons)
	name = "Trade Beacons"
	wait = 2 HOURS
	priority = SS_PRIORITY_TRADE_BEACONS
	var/list/all_trade_beacons = list()

/datum/controller/subsystem/trade_beacons/Destroy()
	QDEL_NULL_LIST(all_trade_beacons)
	. = ..()

/datum/controller/subsystem/trade_beacons/Initialize()
	all_trade_beacons = list()
#ifndef UNIT_TEST
	for(var/obj/effect/overmap/trade_beacon/beacon in world)
		all_trade_beacons |= beacon
#endif
	. = ..()

/datum/controller/subsystem/trade_beacons/fire(resumed = FALSE)
	for(var/obj/effect/overmap/trade_beacon/x in all_trade_beacons)
		x.regenerate_imports()
		x.regenerate_exports()
