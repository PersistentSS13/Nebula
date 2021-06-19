#define ENERGY_PER_AREA 15 KILOWATTS

/obj/machinery/network/area_controller
	name = "area control server"
	desc = "A large machine used to create and control areas. It prevents unpermitted tampering via a complex magnetic interdiction field."
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	base_type = /obj/machinery/network/area_controller
	main_template = "network_area_controller.tmpl"
	idle_power_usage = 30
	maximum_component_parts = list(
		/obj/item/stock_parts = 10,
		/obj/item/stock_parts/smes_coil = 5
	)
	anchored = TRUE
	var/area/selected_area
	var/list/owned_areas = list() // List of areas->req_access list that are protected or were created by this controller.
	var/protected = 0			  // Number of areas actually being protected by the server i.e. those that have grants attached.
	var/max_protected_areas = 0   // No area protection without SMES coils.
	use_power = POWER_USE_IDLE

/obj/machinery/network/area_controller/Initialize()
	. = ..()

	set_extension(src, /datum/extension/eye/blueprints/area_control)
	for(var/A in owned_areas)
		global.protected_areas[A] = src
	
	recalculate_power()
	update_protected_count()

/obj/machinery/network/area_controller/Destroy()
	. = ..()
	for(var/A in owned_areas)
		if(global.protected_areas[A] == src)
			global.protected_areas -= A
	selected_area = null
	owned_areas.Cut()

/obj/machinery/network/area_controller/Process()
	. = ..()
	if(use_power == POWER_USE_ACTIVE)
		var/datum/extension/network_device/net_device = get_extension(src, /datum/extension/network_device)
		if(!net_device.get_network() || !powered())
			toggle_active()
		if(protected > max_protected_areas) // Safety check, something broke.
			toggle_active()

/obj/machinery/network/area_controller/proc/toggle_active()
	if(use_power == POWER_USE_ACTIVE)
		visible_message(SPAN_NOTICE("\The [src] shuts down, emitting a sad whistle."))
		update_use_power(POWER_USE_IDLE)
	else
		visible_message(SPAN_NOTICE("\The [src] begins its boot sequence, emitting a whistle tone!"))
		recalculate_power()
		update_use_power(POWER_USE_ACTIVE)

/obj/machinery/network/area_controller/proc/check_area_access(var/mob/user, var/area/checked_area)
	if(!(checked_area in owned_areas))
		return TRUE
	
	// Area controller needs to be active to work.
	if(use_power != POWER_USE_ACTIVE)
		return TRUE
	if(stat & (NOPOWER|BROKEN)) 
		return TRUE

	var/list/req_access = owned_areas[checked_area]

	return has_access(req_access, user.GetAccess())

/obj/machinery/network/area_controller/proc/add_area(var/area/A)
	owned_areas[A] = list()
	global.protected_areas[A] = src
	recalculate_power()

/obj/machinery/network/area_controller/proc/remove_area(var/area/A)
	owned_areas -= A
	global.protected_areas -= A
	recalculate_power()

/obj/machinery/network/area_controller/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return
		
	if(href_list["create_area"])
		var/datum/extension/eye/area_eye = get_extension(src, /datum/extension/eye)
		area_eye.look(user, list(GetConnectedZlevels(z), "AREA CONTROLLER", src))
		return TOPIC_REFRESH

	var/datum/extension/network_device/net_device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/net = net_device.get_network()
	if(!net)
		return
	var/datum/extension/network_device/acl/access_controller = net.access_controller
	if(!access_controller)
		return

	if(href_list["back"])
		selected_area = null
		return TOPIC_REFRESH

	if(href_list["add_grant"])
		if(!selected_area)
			return TOPIC_HANDLED
		if(!(selected_area in owned_areas))
			selected_area = null
			return TOPIC_REFRESH
		if(!length(owned_areas[selected_area]) && protected >= max_protected_areas)
			to_chat(user, SPAN_WARNING("Error: Cannot add any more protected areas!"))
			return
		var/datum/computer_file/data/grant_record/grant = access_controller.get_grant(href_list["add_grant"])
		if(!grant) // Safety check to ensure this grant actually exists
			return TOPIC_HANDLED
		owned_areas[selected_area] |= uppertext("[net_device.network_id].[grant.stored_data]") // Add the actual access string to the list.
		update_protected_count()
		recalculate_power()
		return TOPIC_REFRESH

	if(href_list["remove_grant"])
		if(!selected_area)
			return TOPIC_HANDLED
		if(!(selected_area in owned_areas))
			selected_area = null
			return TOPIC_REFRESH
		var/datum/computer_file/data/grant_record/grant = access_controller.get_grant(href_list["remove_grant"])
		if(!grant)
			return TOPIC_HANDLED
		owned_areas[selected_area] -= uppertext("[net_device.network_id].[grant.stored_data]")
		recalculate_power()
		update_protected_count()
		return TOPIC_REFRESH

	if(href_list["clear_grants"])
		if(!selected_area)
			return TOPIC_HANDLED
		owned_areas[selected_area] = list()
		recalculate_power()
		update_protected_count()
		return TOPIC_REFRESH

	if(href_list["toggle_power"])
		toggle_active()
		return TOPIC_REFRESH

	if(href_list["view_area"])
		var/index = text2num(href_list["view_area"])
		if(!isnum(index) || LAZYLEN(owned_areas) < index)
			return TOPIC_HANDLED
		selected_area = owned_areas[index]

/obj/machinery/network/area_controller/ui_data(mob/user, ui_key)
	. = ..()
	
	var/datum/extension/network_device/net_device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/net = net_device.get_network()
	if(!net)
		.["no_network"] = TRUE
		return
	.["powered"] = (use_power == POWER_USE_ACTIVE)
	.["power_usage"] = "[((use_power == POWER_USE_ACTIVE) ? active_power_usage : idle_power_usage)/1000] KW"
	var/datum/extension/network_device/acl/access_controller = net.access_controller
	if(!access_controller)
		.["no_network"] = TRUE
		return
	.["protected"] = protected
	.["max_protected"] = max_protected_areas
	.["selected_area"] = !!selected_area
	if(selected_area)
		// Looking at an area and selecting the grants permitted to modify the area.
		var/list/grants[0]
		// We're editing a user, so we only need to build a subset of data.
		.["area_name"] = selected_area.name
		.["area_index"] = owned_areas.Find(selected_area)
		var/list/current_grants = owned_areas[selected_area]
		for(var/datum/computer_file/data/grant_record/GR in access_controller.get_all_grants())
			grants.Add(list(list(
				"grant_name" = GR.stored_data,
				"assigned" = (uppertext("[net_device.network_id].[GR.stored_data]") in current_grants)
			)))
		.["grants"] = grants
	else
		// Selecting area for modification.
		var/list/areas[0]
		for(var/i in 1 to LAZYLEN(owned_areas))
			var/area/A = owned_areas[i]
			areas.Add(list(list(
				"area_index" = i,
				"area_name" = A.name,
				"grant_count" = length(owned_areas[A]),
			)))
		.["areas"] = areas

/obj/machinery/network/area_controller/proc/recalculate_power()
	var/protected = 0
	for(var/A in owned_areas)
		var/list/L = owned_areas[A]
		if(LAZYLEN(L)) // No upkeep requirement for areas with no required grants.
			protected++
	change_power_consumption((protected*ENERGY_PER_AREA) + idle_power_usage, POWER_USE_ACTIVE)

/obj/machinery/network/area_controller/proc/update_protected_count()
	protected = 0
	for(var/A in owned_areas)
		var/list/L = owned_areas[A]
		if(LAZYLEN(L))
			protected++

/obj/machinery/network/area_controller/RefreshParts()
	// SMES coils allow for additional area protections.
	max_protected_areas = initial(max_protected_areas)
	for(var/obj/item/stock_parts/smes_coil/S in component_parts)
		if(istype(S, /obj/item/stock_parts/smes_coil/super_capacity))
			max_protected_areas += 3
		else
			max_protected_areas +=2
	
	. = ..()

/atom/proc/check_area_protection(var/mob/user, var/area/checked_area)
	if(!checked_area)
		checked_area = get_area(src)
	if(!(checked_area in global.protected_areas))
		return TRUE
	if(!user)
		return TRUE
	var/obj/machinery/network/area_controller/ac = global.protected_areas[checked_area]
	if(!ac)
		global.protected_areas -= checked_area
		return TRUE
	if(!(ac.z in GetConnectedZlevels(z))) // Area controller must be in the same sector.
		return TRUE
	
	return ac.check_area_access(user, checked_area)

/obj/item/stock_parts/circuitboard/area_controller
	name = "circuitboard (area control server)"
	build_path = /obj/machinery/network/area_controller
	board_type = "machine"
	origin_tech = "{'programming':1, 'engineering':2}"
	req_components = list(
		/obj/item/stack/cable_coil = 30,
		/obj/item/stock_parts/capacitor = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1
	)

/datum/fabricator_recipe/imprinter/circuit/area_controller
	path = /obj/item/stock_parts/circuitboard/area_controller

#undef ENERGY_PER_AREA