#define MAX_PATTERNS 10

/obj/item/stock_parts/network_receiver/network_lock
	name = "network access lock"
	desc = "An id-based access lock preventing tampering with a machine's hardware and software. Connects wirelessly to network."
	icon_state = "net_lock"
	part_flags = PART_FLAG_QDEL
	base_type = /obj/item/stock_parts/network_receiver/network_lock

	var/requires_network = FALSE					// Set this to TRUE to deny all access attempts if network connection is lost.
	var/initial_network_id							// The address to the network
	var/initial_network_key							// network KEY
	var/selected_parent_group						// Current selected parent_group for access assignment.

	var/list/access_keys							// List of lists of groups and account logins.
													// In order to access the device, users must have membership in at least one
													// of the groups or accounts in each list. Account logins are denoted with an @ at the end.

	var/selected_pattern							// Index of the access key pattern selected.
	var/viewing_accounts = FALSE

	var/emagged										// Whether or not this has been emagged.
	var/error

	var/interact_sounds = list("keyboard", "keystroke")
	var/interact_sound_volume = 40
	var/static/legacy_compatibility_mode = TRUE     // Makes legacy access on ids play well with mapped devices with network locks. Override if your server is fully using network-enabled ids or has no mapped access.

/obj/item/stock_parts/network_receiver/network_lock/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(initial_network_id, map_hash)

/obj/item/stock_parts/network_receiver/network_lock/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	if(istype(loc, /obj/machinery)) // Don't emag it outside; you can just cut access without it anyway.
		emagged = TRUE
		to_chat(user, SPAN_NOTICE("You slide the card into \the [src]. It flashes purple briefly, then disengages."))
		. = max(., 1)

// Override. This checks the network and builds a dynamic req_access list for the device it's attached to.
/obj/item/stock_parts/network_receiver/network_lock/get_req_access()
	// Broken network locks require no access.
	if(!is_functional())
		return list()

	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = D?.get_network(NET_FEATURE_ACCESS)
	var/datum/extension/network_device/acl/access_controller = network?.access_controller

	var/list/all_groups = access_controller?.get_all_groups()
	var/list/all_logins = network?.get_all_logins()

	if(requires_network)
		// Network locks require no access if the network is down and requires_network is toggled on
		if(!network || !access_controller)
			return list()

	LAZYINITLIST(access_keys)
	var/list/resulting_access = list()
	for(var/list/pattern in access_keys)
		var/list/resulting_pattern = list()
		for(var/access_key in pattern)
			// This is an account login.
			if(text_ends_with(access_key, "@"))
				if(all_logins && !(copytext(access_key, 1, -1) in all_logins)) // This account doesn't exist anymore - delete it
					pattern -= access_key
					continue
				resulting_pattern |= "[access_key][D.network_id]" // The @ is included in the pattern.
			else
				if(all_groups && !(access_key in all_groups))  // Ditto for groups
					pattern -= access_key
					continue
				resulting_pattern |= "[access_key].[D.network_id]"
		if(resulting_pattern.len)
			resulting_access += list(resulting_pattern)
	if(!length(resulting_access))
		return
	return resulting_access

/obj/item/stock_parts/network_receiver/network_lock/examine(mob/user)
	. = ..()
	if(emagged && user.skill_check_multiple(list(SKILL_FORENSICS = SKILL_EXPERT, SKILL_COMPUTER = SKILL_EXPERT)))
		to_chat(user, SPAN_WARNING("On close inspection, there is something odd about the interface. You suspect it may have been tampered with."))

/obj/item/stock_parts/network_receiver/network_lock/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, /obj/item/card/id))
		if(check_access(W))
			playsound(src, 'sound/machines/ping.ogg', 20, 0)
		else
			playsound(src, 'sound/machines/buzz-two.ogg', 20, 0)

/obj/item/stock_parts/network_receiver/network_lock/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(istype(target, /obj/item/stock_parts/network_receiver/network_lock))
		var/obj/item/stock_parts/network_receiver/network_lock/other_lock = target
		if(length(other_lock.access_keys)) // Prevent mistakingly copying from a blank lock instead of vice versa.
			access_keys = other_lock.access_keys.Copy()
			playsound(src, 'sound/machines/ping.ogg', 20, 0)
			to_chat(user, SPAN_NOTICE("\The [src] pings as it successfully copies its access requirements from the other network lock."))


/obj/item/stock_parts/network_receiver/network_lock/attack_self(var/mob/user)
	ui_interact(user)

/obj/item/stock_parts/network_receiver/network_lock/ui_data(mob/user, ui_key)
	var/list/data[0]
	. = data

	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(!istype(D))
		error = "HARDWARE FAILURE: NETWORK DEVICE NOT FOUND"
		data["error"] = error
		return
	data["error"] = error
	data += D.ui_data(user, ui_key)

	var/datum/computer_network/network = D.get_network(NET_FEATURE_ACCESS)
	if(!network)
		data["connected"] = FALSE
		return
	data["connected"] = TRUE
	data["req_network"] = requires_network
	if(!network.access_controller)
		return

	data["patterns"] = list()
	var/pattern_index = 0
	for(var/list/pattern in access_keys)
		pattern_index++
		data["patterns"].Add(list(list(
			"index" = "[pattern_index]",
			"access" = english_list(pattern, "No access assigned!", and_text = " or ")
			)))

	var/list/parent_groups_data
	var/list/child_groups_data
	var/list/account_data
	var/list/pattern = LAZYACCESS(access_keys, selected_pattern)

	if(pattern)
		if(viewing_accounts)
			data["viewing_accounts"] = TRUE
			var/list/login_list = network.get_all_logins()
			if(length(login_list))
				account_data = list()
				for(var/login in login_list)
					account_data.Add(list(list(
						"login" = login,
						"assigned" = (LAZYISIN(pattern, (login + "@")))
					)))
		else
			var/list/group_dictionary = network.access_controller.get_group_dict()
			if(selected_parent_group)
				if(!(selected_parent_group in group_dictionary))
					selected_parent_group = null
				else
					var/list/child_groups = group_dictionary[selected_parent_group]
					if(length(child_groups))
						child_groups_data = list()
						for(var/child_group in child_groups)
							child_groups_data.Add(list(list(
								"child_group" = child_group,
								"assigned" = (LAZYISIN(pattern, child_group))
							)))
			if(!selected_parent_group) // Check again in case we ended up with a non-existent selected parent group instead of breaking the UI.
				parent_groups_data = list()
				for(var/parent_group in group_dictionary)
					parent_groups_data.Add(list(list(
						"parent_group" = parent_group,
						"assigned" = (LAZYISIN(pattern, parent_group))
					)))
	data["parent_groups"] = parent_groups_data
	data["child_groups"] = child_groups_data
	data["accounts"] = account_data
	data["selected_parent_group"] = selected_parent_group
	data["selected_pattern"] = "[selected_pattern]"

/obj/item/stock_parts/network_receiver/network_lock/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return
	. = TOPIC_HANDLED

	if(href_list["refresh"])
		error = null
		return TOPIC_REFRESH

	if(href_list["back"])
		viewing_accounts = FALSE
		selected_parent_group = null
		return TOPIC_REFRESH

	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(!D)
		return

	if(href_list["settings"])
		D.ui_interact(user)
		return TOPIC_REFRESH

	if(href_list["req_network"])
		requires_network = !requires_network
		return TOPIC_REFRESH

	if(href_list["add_pattern"])
		if(length(access_keys) >= MAX_PATTERNS)
			to_chat(usr, SPAN_WARNING("You cannot add more than [MAX_PATTERNS] patterns to \the [src]!"))
			return TOPIC_HANDLED
		LAZYADD(access_keys, list(list()))
		return TOPIC_REFRESH

	if(href_list["remove_pattern"])
		var/pattern_index = text2num(href_list["remove_pattern"])
		LAZYREMOVE(access_keys, list(LAZYACCESS(access_keys, pattern_index))) // We have to encapsulate the pattern in another list to actually delete it.
		if(selected_pattern == pattern_index)
			selected_pattern = null
		else if(selected_pattern > pattern_index)
			selected_pattern--
		return TOPIC_REFRESH

	if(href_list["select_pattern"])
		var/pattern_index = text2num(href_list["select_pattern"])
		if(pattern_index > LAZYLEN(access_keys))
			return TOPIC_HANDLED
		selected_pattern = pattern_index
		return TOPIC_REFRESH

	if(href_list["view_accounts"])
		viewing_accounts = TRUE
		return TOPIC_REFRESH

	if(href_list["select_parent_group"])
		selected_parent_group = href_list["select_parent_group"]
		return TOPIC_REFRESH

	if(href_list["info"])
		switch(href_list["info"])
			if("pattern")
				to_chat(user, SPAN_NOTICE("In order to access the device, users must be a member of at least one group or account in each access pattern."))
			if("parent_groups")
				to_chat(user, SPAN_NOTICE("Assigning a parent group to an access pattern will permit any member of its child groups access to the pattern."))
			if("req_network")
				to_chat(user, SPAN_NOTICE("If toggled on, the network lock will automatically allow all access attempts if the network goes down. This should rarely be used."))

		return TOPIC_HANDLED

	var/list/pattern_list = LAZYACCESS(access_keys, selected_pattern)
	if(!pattern_list)
		return TOPIC_REFRESH


	var/datum/computer_network/network = D.get_network()
	if(!network)
		return TOPIC_REFRESH

	var/datum/extension/network_device/acl/acl = network.access_controller
	if(!acl)
		return TOPIC_REFRESH


	if(href_list["assign_group"])
		var/list/valid_groups = acl.get_all_groups()
		if(!(href_list["assign_group"] in valid_groups))
			return TOPIC_REFRESH
		pattern_list |= href_list["assign_group"]
		return TOPIC_REFRESH

	if(href_list["remove_group"])
		pattern_list -= href_list["remove_group"]
		return TOPIC_REFRESH

	if(href_list["assign_account"])
		var/list/valid_accounts = network.get_all_logins()
		if(!(href_list["assign_account"] in valid_accounts))
			return TOPIC_REFRESH
		pattern_list |= (href_list["assign_account"] + "@")
		return TOPIC_REFRESH

	if(href_list["remove_account"])
		pattern_list -= (href_list["remove_account"] + "@")
		return TOPIC_REFRESH

/obj/item/stock_parts/network_receiver/network_lock/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "network_lock.tmpl", capitalize(name), 500, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/item/stock_parts/network_receiver/network_lock/CouldUseTopic(var/mob/user)
	..()
	if(LAZYLEN(interact_sounds) && CanPhysicallyInteract(user))
		playsound(src, pick(interact_sounds), interact_sound_volume)

/obj/item/stock_parts/network_receiver/network_lock/CanUseTopic()
	return STATUS_INTERACTIVE

/obj/item/stock_parts/network_receiver/network_lock/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

// Prevent tampering with machinery you don't have access to.
/obj/machinery/cannot_transition_to(state_path, mob/user)
	var/decl/machine_construction/state = GET_DECL(state_path)
	if(state && !state.locked && construct_state && construct_state.locked)
		for(var/obj/item/stock_parts/network_receiver/network_lock/lock in get_all_components_of_type(/obj/item/stock_parts/network_receiver/network_lock))
			if(!lock.check_access(user))
				return SPAN_WARNING("\The [lock] flashes red! You lack the access to unlock this.")
	return ..()

#undef MAX_PATTERNS