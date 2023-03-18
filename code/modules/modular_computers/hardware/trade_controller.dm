/datum/extension/network_device/trade_controller
	var/obj/effect/overmap/trade_beacon/linked_beacon
	var/import_tax = 0
	var/export_tax = 0
	var/beacon_restrict = 0 // Restriction to ALL beacon functions, import/export/log. 0 = no restricton, 1 = restricted to the network
	var/log_restrict = 0	// Restriction of the transaction log. 0 = no restricton, 1 = restricted to the network
	var/access = 0 // Which access will allow for general beacon functions
	var/log_access = 0 // which access will allow for viewing the transaction log

/datum/extension/network_device/trade_controller/proc/Unlink()
	if(linked_beacon)
		linked_beacon.linked_controller = null
		linked_beacon = null
/datum/extension/network_device/trade_controller/Destroy()
	Unlink()
	. = ..()

/datum/extension/network_device/trade_controller/disconnect(net_down)
	Unlink()
	. = ..()

/datum/extension/network_device/trade_controller/proc/toggle_beacon_restrict()
	if(!linked_beacon)
		beacon_restrict = 0
		return
	beacon_restrict = !beacon_restrict
	var/datum/computer_network/network = get_network()
	if(network.trade_controller == src)
		network.add_log("Trade Control Device toggled beacon restriction for [linked_beacon.name].", network_tag)
	return 1


/datum/extension/network_device/trade_controller/proc/select_beacon_access(var/mob/M, var/obj/machinery/network/trade_controller/machine)
	var/list/access_choices = list()
	var/datum/computer_network/network = get_network()
	var/datum/extension/network_device/acl/D
	if(network)
		D = network.access_controller
	if(!linked_beacon)
		access = 0
		return
	if(!D)
		to_chat(M, SPAN_WARNING("Cannot restrict access! No access controller detected on network!"))
		return
	for(var/parent_group in D.group_dict)
		access_choices |= parent_group
		for(var/child_group in D.group_dict[parent_group])
			access_choices |= child_group
	access_choices |= "*NONE*"
	var/chosen = input(M, "Select an Access for the Trade Beacon.", "Beacon Access Selection") as null|anything in access_choices
	if(chosen && (!machine || machine.CanUseTopic(M)))
		if(chosen == "*NONE*")
			access = 0
			network.add_log("Trade Control Device unset beacon access for [linked_beacon.name].", network_tag)
		else
			access = chosen
			network.add_log("Trade Control Device set beacon access to [chosen] for [linked_beacon.name].", network_tag)
	return 1
/datum/extension/network_device/trade_controller/proc/select_import_tax(var/mob/M, var/obj/machinery/network/trade_controller/machine)
	var/datum/computer_network/network = get_network()
	if(!linked_beacon)
		import_tax = 0
		return
	var/chosen_tax = input(M, "Enter the import tax% to charge for this beacon. (30% MAX)", "Import Tax") as num|null
	if(!machine || machine.CanUseTopic(M))
		import_tax = clamp(chosen_tax, 0, 30)
		network.add_log("Trade Control Device changed the import tax rate to [import_tax] for [linked_beacon.name].", network_tag)
	return 1

/datum/extension/network_device/trade_controller/proc/select_export_tax(var/mob/M, var/obj/machinery/network/trade_controller/machine)
	var/datum/computer_network/network = get_network()
	if(!linked_beacon)
		export_tax = 0
		return
	var/chosen_tax = input(M, "Enter the export tax% to charge for this beacon. (30% MAX)", "Export Tax") as num|null
	if(!machine || machine.CanUseTopic(M))
		export_tax = clamp(chosen_tax, 0, 30)
		network.add_log("Trade Control Device changed the export tax rate to [export_tax] for [linked_beacon.name].", network_tag)
	return 1

/datum/extension/network_device/trade_controller/proc/toggle_log_restrict()
	if(!linked_beacon)
		log_restrict = 0
		return
	log_restrict = !log_restrict
	var/datum/computer_network/network = get_network()
	if(network.trade_controller == src)
		network.add_log("Trade Control Device toggled transaction log restriction for [linked_beacon.name].", network_tag)
	return 1