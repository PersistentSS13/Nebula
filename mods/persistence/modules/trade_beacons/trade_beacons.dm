/atom/proc/get_adjacent_trade_beacons()
	var/list/adjacent_trade_beacons = list()
	var/atom/target = src
	if(!istype(src, /turf))
		target = get_turf(src)
	var/obj/ob = target.get_owning_overmap_object()
	if(ob)
		var/turf/T = get_turf(ob)
		if(T)
			for(var/obj/beacon in SStrade_beacons.all_trade_beacons)
				var/turf/beacon_turf = get_turf(beacon)
				if(beacon_turf && beacon_turf.Adjacent(T))
					adjacent_trade_beacons |= beacon
	return adjacent_trade_beacons

/obj/effect/overmap/trade_beacon
	name = "Trade Beacon"
	var/list/possible_imports = list() // structure is list(/datum/beacon_import/example = 100) list(type = percentage chance of appearing).
	var/list/possible_exports = list()
	var/list/active_imports = list()
	var/list/active_exports = list()
	icon = 'icons/obj/supplybeacon.dmi'
	icon_state = "beacon_active"
	var/datum/extension/network_device/trade_controller/linked_controller
	var/datum/money_account/beacon_account
	var/start_x = 0
	var/start_y = 0


/obj/effect/overmap/trade_beacon/Destroy()
	if(SStrade_beacons && SStrade_beacons.all_trade_beacons)
		SStrade_beacons.all_trade_beacons.Remove(src)
	QDEL_NULL(beacon_account)
	QDEL_NULL_LIST(active_imports)
	QDEL_NULL_LIST(active_exports)
	..()


/obj/effect/overmap/trade_beacon/proc/move_to_starting_location()
	var/datum/overmap/overmap = global.overmaps_by_name[overmap_id]
	var/location
	if(!overmap)
		return
	if(start_x && start_y)
		location = locate(start_x, start_y, overmap.assigned_z)
	else
		var/list/candidate_turfs = block(
		locate(OVERMAP_EDGE, OVERMAP_EDGE, overmap.assigned_z),
		locate(overmap.map_size_x - OVERMAP_EDGE, overmap.map_size_y - OVERMAP_EDGE, overmap.assigned_z)
		)

		candidate_turfs = where(candidate_turfs, /proc/can_not_locate, /obj/effect/overmap)
		location = SAFEPICK(candidate_turfs) || locate(
			rand(OVERMAP_EDGE, overmap.map_size_x - OVERMAP_EDGE),
			rand(OVERMAP_EDGE, overmap.map_size_y - OVERMAP_EDGE),
			overmap.assigned_z
		)

	forceMove(location)


/obj/effect/overmap/trade_beacon/Initialize()
	beacon_account = new()
	beacon_account.account_name = name
	move_to_starting_location()
	regenerate_imports()
	regenerate_exports()
	. = ..()

/obj/effect/overmap/trade_beacon/proc/regenerate_imports()
	if(!active_imports) active_imports = list()
	active_imports.Cut()
	for(var/import in possible_imports)
		if(!prob(possible_imports[import])) continue
		active_imports |= new import()



/obj/effect/overmap/trade_beacon/proc/regenerate_exports()
	if(!active_exports) active_exports = list()
	active_exports.Cut()
	for(var/export in possible_exports)
		if(!prob(possible_exports[export])) continue
		active_exports |= new export()

//////////////////////////////// BEACONS


/obj/effect/overmap/trade_beacon/test_beacon
	start_x = 28
	start_y = 23
	possible_imports = list(
		/datum/beacon_import/example = 100,
		/datum/beacon_import/steel = 100
		)
	possible_exports = list(
		/datum/beacon_export/example = 100,
		/datum/beacon_export/xanaducrystal = 100
		)
	name = "Kleibkhar Debug Trade Beacon"

/obj/effect/overmap/trade_beacon/test_beacon2
	start_x = 27
	start_y = 22
	possible_imports = list(
		/datum/beacon_import/example = 100,
		/datum/beacon_import/steel = 100
		)
	possible_exports = list(
		/datum/beacon_export/example = 100,
		/datum/beacon_export/xanaducrystal = 100
		)
	name = "Kleibkhar Debug Trade Beacon Secondus"
