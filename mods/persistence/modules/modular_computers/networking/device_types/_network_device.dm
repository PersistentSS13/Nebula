/datum/extension/network_device
	should_save = TRUE

// Placeholder fix for refreshing fabricator design cache until fabricator UI rework is done upstream etc.
/datum/extension/network_device/Topic(href, href_list)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!can_interact(user))
		return
	if(href_list["refresh_machine"])
		holder?.handle_post_network_connection()
		return TOPIC_REFRESH

SAVED_VAR(/datum/extension/network_device, network_id)
SAVED_VAR(/datum/extension/network_device, key)
SAVED_VAR(/datum/extension/network_device, command_and_call)
SAVED_VAR(/datum/extension/network_device, command_and_write)
