SAVED_VAR(/datum/extension/network_device/money_cube, stored_money)

/datum/extension/network_device/money_cube/after_deserialize()
	if(network_id && key)
		SSnetworking.queue_connection(src)