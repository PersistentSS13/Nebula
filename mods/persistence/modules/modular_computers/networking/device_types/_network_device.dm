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