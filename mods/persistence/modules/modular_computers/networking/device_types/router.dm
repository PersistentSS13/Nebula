/datum/extension/network_device/broadcaster/router/before_save()
	. = ..()
	var/datum/computer_network/network = SSnetworking.networks[network_id]
	if(network && network.router == src)
		CUSTOM_SV("was_router", TRUE)

/datum/extension/network_device/broadcaster/router/after_deserialize()
	// TODO: Doing this late will cause additional logs to be generated on load, probably.
	var/datum/computer_network/network = SSnetworking.networks[network_id]
	if(network && LOAD_CUSTOM_SV("was_router"))
		network.set_router(src)

	. = ..()