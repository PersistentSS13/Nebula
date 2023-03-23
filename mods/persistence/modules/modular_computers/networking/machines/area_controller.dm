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
	var/selected_parent_group

	var/list/owned_areas = list() // List of areas->req_access list that are protected or were created by this controller.
	var/protected = 0			  // Number of areas actually being protected by the server i.e. those that have groups attached.
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

	var/list/req_access = list(owned_areas[checked_area]) // List of a list for OR type access check.

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
		area_eye.look(user, list(SSmapping.get_connected_levels(z), "AREA CONTROLLER", src))
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
		selected_parent_group = null
		return TOPIC_REFRESH

	if(href_list["add_group"])
		if(!selected_area)
			return TOPIC_HANDLED
		if(!(selected_area in owned_areas))
			selected_area = null
			return TOPIC_REFRESH
		if(!length(owned_areas[selected_area]) && protected >= max_protected_areas)
			to_chat(user, SPAN_WARNING("Error: Cannot add any more protected areas!"))
			return
		var/group_name = href_list["add_group"]
		if(!(group_name in access_controller.get_all_groups())) // Safety check to ensure this group actually exists
			return TOPIC_HANDLED
		owned_areas[selected_area] |= "[group_name].[net_device.network_id]" // Add the actual access string to the list.
		update_protected_count()
		recalculate_power()
		return TOPIC_REFRESH

	if(href_list["remove_group"])
		if(!selected_area)
			return TOPIC_HANDLED
		if(!(selected_area in owned_areas))
			selected_area = null
			return TOPIC_REFRESH
		var/group_name = href_list["remove_group"]
		owned_areas[selected_area] -= "[group_name].[net_device.network_id]"
		recalculate_power()
		update_protected_count()
		return TOPIC_REFRESH

	if(href_list["clear_groups"])
		if(!selected_area)
			return TOPIC_HANDLED
		owned_areas[selected_area] = list()
		recalculate_power()
		update_protected_count()
		return TOPIC_REFRESH

	if(href_list["select_parent_group"])
		if(!(href_list["selected_parent_group"] in access_controller.get_group_dict()))
			return TOPIC_HANDLED
		selected_parent_group = href_list["selected_parent_group"]

	if(href_list["toggle_power"])
		toggle_active()
		return TOPIC_REFRESH

	if(href_list["view_area"])
		var/index = text2num(href_list["view_area"])
		if(!isnum(index) || LAZYLEN(owned_areas) < index)
			return TOPIC_HANDLED
		selected_area = owned_areas[index]
		return TOPIC_REFRESH

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
		// Looking at an area and selecting the groups permitted to modify the area.
		var/list/group_dictionary = access_controller.get_group_dict()
		var/list/parent_groups_data
		var/list/child_groups_data

		var/list/current_groups = owned_areas[selected_area]

		.["area_name"] = selected_area.name
		.["area_index"] = owned_areas.Find(selected_area)

		if(selected_parent_group)
			if(!(selected_parent_group in group_dictionary))
				selected_parent_group = null
			else
				var/list/child_groups = group_dictionary[selected_parent_group]
				if(child_groups)
					child_groups_data = list()
					for(var/child_group in child_groups)
						child_groups_data.Add(list(list(
							"child_group" = child_group,
							"assigned" = (LAZYISIN(current_groups, "[child_group].[net_device.network_id]"))
						)))
		if(!selected_parent_group) // Check again in case we ended up with a non-existent selected parent group instead of breaking the UI.
			parent_groups_data = list()
			for(var/parent_group in group_dictionary)
				parent_groups_data.Add(list(list(
					"parent_group" = parent_group,
					"assigned" = (LAZYISIN(current_groups, "[parent_group].[net_device.network_id]"))
				)))
		.["parent_groups"] = parent_groups_data
		.["child_groups"] = child_groups_data

	else
		// Selecting area for modification.
		var/list/areas[0]
		for(var/i in 1 to LAZYLEN(owned_areas))
			var/area/A = owned_areas[i]
			areas.Add(list(list(
				"area_index" = i,
				"area_name" = A.name,
				"group_count" = length(owned_areas[A]),
			)))
		.["areas"] = areas

/obj/machinery/network/area_controller/proc/recalculate_power()
	var/protected = 0
	for(var/A in owned_areas)
		var/list/L = owned_areas[A]
		if(LAZYLEN(L)) // No upkeep requirement for areas with no required groups.
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
	if(!(ac.z in SSmapping.get_connected_levels(z))) // Area controller must be in the same sector.
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

SAVED_VAR(/obj/machinery/network/area_controller, owned_areas)