/obj/item/stock_parts/network_receiver/network_lock/before_save()
	. = ..()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	initial_network_id = D.network_id
	initial_network_key = D.key

/obj/item/stock_parts/network_receiver/network_lock/after_save()
	. = ..()
	initial_network_id = null
	initial_network_key = null

SAVED_VAR(/obj/item/stock_parts/network_receiver/network_lock, access_keys)
SAVED_VAR(/obj/item/stock_parts/network_receiver/network_lock, initial_network_id)
SAVED_VAR(/obj/item/stock_parts/network_receiver/network_lock, initial_network_key)
SAVED_VAR(/obj/item/stock_parts/network_receiver/network_lock, emagged)