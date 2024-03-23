SUBSYSTEM_DEF(trade_beacons)
	name = "Trade Beacons"
	wait = 5 MINUTES
	priority = SS_PRIORITY_MONEY_ACCOUNTS
	var/list/all_trade_beacons = list()
	var/list/wanted_trade_beacons //= list(/obj/effect/overmap/trade_beacon/test_beacon, /obj/effect/overmap/trade_beacon/test_beacon2) // list(//obj/effect/overmap/trade_beacon/example, /obj/effect/overmap/trade_beacon/steel, /obj/effect/overmap/trade_beacon/xandahar)
	var/last_cycle = 0

/datum/controller/subsystem/trade_beacons/Destroy()
	QDEL_NULL_LIST(all_trade_beacons)
	. = ..()

/datum/controller/subsystem/trade_beacons/Initialize()
	all_trade_beacons = list()
#ifndef UNIT_TEST
	for(var/x in wanted_trade_beacons)
		var/obj/effect/overmap/trade_beacon/beacon = new x()
		all_trade_beacons |= beacon
#endif
	. = ..()

/datum/controller/subsystem/trade_beacons/fire(resumed = FALSE)
	if(REALTIMEOFDAY >= (last_cycle + 2 HOURS))
		last_cycle = REALTIMEOFDAY
		for(var/obj/effect/overmap/trade_beacon/x in all_trade_beacons)
			x.regenerate_imports()
			x.regenerate_exports()
	return