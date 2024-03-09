////////////////////////////////////////////////////////////////////////
// Area Controller
////////////////////////////////////////////////////////////////////////

/obj/machinery/network/area_controller/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_actrl"
	use_power          = POWER_USE_ACTIVE
	maximum_component_parts = list(
		/obj/item/stock_parts = 200,
	)
	uncreated_component_parts = list(
		/obj/item/stock_parts/smes_coil = 7,
	)
	req_access = list(
		list(access_ce),
		list(access_bridge),
	)

/obj/machinery/network/area_controller/outreach/Initialize(mapload, d, populate_parts)
	. = ..()
	for(var/area/A in world)
		if(A.name in global.outreach_initial_protected_areas)
			add_protected_area(A)
	update_use_power(POWER_USE_ACTIVE)

/obj/machinery/network/area_controller/outreach/proc/add_protected_area(var/area/A)
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	add_area(A)
	owned_areas[A] |= "[OUTREACH_USR_GRP_COMMAND].[D.network_id]"
	update_protected_count()
	recalculate_power()
