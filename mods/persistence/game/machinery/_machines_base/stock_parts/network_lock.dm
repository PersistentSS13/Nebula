/obj/item/stock_parts/network_lock/before_save()
	. = ..()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	initial_network_id = D.network_id
	initial_network_key = D.key

/obj/item/stock_parts/network_lock/after_save()
	. = ..()
	initial_network_id = null
	initial_network_key = null