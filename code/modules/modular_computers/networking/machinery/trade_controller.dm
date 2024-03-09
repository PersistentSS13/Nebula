/obj/machinery/network/trade_controller
	name = "trade control device"
	desc = "A device used for controlling trade beacons and adding import/export tax. It must remain in a gravity well near the trade beacon"
	icon = 'icons/obj/machines/trade_controller.dmi'
	icon_state = "hub"
	network_device_type =  /datum/extension/network_device/trade_controller
	main_template = "trade_controller.tmpl"
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	base_type = /obj/machinery/network/trade_controller


/obj/machinery/network/trade_controller/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return
	var/datum/extension/network_device/trade_controller/D = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = D.get_network()
	if(!network || network.trade_controller != D)
		error = "NETWORK ERROR: Connection lost. Another trade controller may be active on the network."
		return TOPIC_REFRESH

	if(href_list["connect_beacon"])
		var/list/possible_trade_beacons = get_adjacent_trade_beacons()
		possible_trade_beacons += "*DISCONNECT*"
		var/selected_beacon = input(usr, "Select a nearby trade beacon.", "Pick a beacon") as null|anything in possible_trade_beacons
		if(!CanInteract(user, global.default_topic_state) || !selected_beacon)
			return TOPIC_REFRESH
		if(selected_beacon == "*DISCONNECT*")
			D.Unlink()
		else
			var/obj/effect/overmap/trade_beacon/a = selected_beacon
			if(a.linked_controller)
				to_chat(user, SPAN_NOTICE("This beacon is already connected to a trade control device. The existing trade control device must be removed first."))
				return TOPIC_REFRESH
			else
				a.linked_controller = D
				D.linked_beacon = a
		return TOPIC_REFRESH

	if(href_list["toggle_beacon_restrict"])
		D.toggle_beacon_restrict()
		return TOPIC_REFRESH
	if(href_list["select_beacon_access"])
		D.select_beacon_access(usr, src)
		return TOPIC_REFRESH
	if(href_list["change_import_tax"])
		D.select_import_tax(usr, src)
		return TOPIC_REFRESH
	if(href_list["change_export_tax"])
		D.select_export_tax(usr, src)
		return TOPIC_REFRESH
	if(href_list["toggle_log_restrict"])
		D.toggle_log_restrict()
		return TOPIC_REFRESH

	if(href_list["info"])
		switch(href_list["info"])
			if("connect_beacon")
				to_chat(user, SPAN_NOTICE("The Trade Controller can take control of trade beacons that you are within 1 tile of in space. A beacon can only be controlled by one Trade Controller, and will remaiin controlled until that controller is brought offline."))
			if("restrict_beacon_access")
				to_chat(user, SPAN_NOTICE("If Beacon restriction is turned on, only devices connected to this network and with the appropriate access will be able to use the beacon for imports, exports or viewing the transaction log."))
			if("select_beacon_access")
				to_chat(user, SPAN_NOTICE("You can set this access to any group in the network, in which case it will be required to access the Import/Export/Log functions for the beacon. If this is unset any device on this network will be able to access the beacon."))
			if("import_tax")
				to_chat(user, SPAN_NOTICE("This is a percentage added to the cost of all imports done, except those done by the primary money account on this network. The added percentage will be deposited into the primary money account."))
			if("export_tax")
				to_chat(user, SPAN_NOTICE("This is a percentage taken from the revenue of all exports done, except those done by the primary money account on this network. The added percentage will be deposited into the primary money account."))
			if("restrict_log_access")
				to_chat(user, SPAN_NOTICE("If Transaction Log restriction is turned on, only devices connected to this network and with the appropriate access will be able to view the transaction log."))
			if("select_log_access")
				to_chat(user, SPAN_NOTICE("You can set this access to any group in the network, in which case it will be required to access the Log functions for the beacon. If this is unset any device on this network will be able to access the transaction log."))

/obj/machinery/network/trade_controller/ui_data(mob/user, ui_key)
	. = ..()

	if(error)
		.["error"] = error
		return

	var/datum/extension/network_device/trade_controller/D = get_extension(src, /datum/extension/network_device)
	if(!D.get_network())
		.["connected"] = FALSE
		return
	.["connected"] = TRUE
	if(D.linked_beacon)
		.["connected_beacon"] = D.linked_beacon.name
		.["valid_beacon"] = TRUE
		.["beacon_restrict"] = D.beacon_restrict
		if(D.beacon_restrict)
			if(D.access)
				.["selected_beacon_access"] = D.access
			else
				.["selected_beacon_access"] = "*NONE*"
		.["import_tax"] = D.import_tax
		.["export_tax"] = D.export_tax
		.["log_restrict"] = D.log_restrict
		if(D.log_restrict)
			if(D.log_access)
				.["selected_log_access"] = D.log_access
			else
				.["selected_log_access"] = "*NONE*"
	else
		.["connected_beacon"] = "*DISCONNECTED*"