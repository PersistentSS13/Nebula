/obj/machinery/internet_uplink/before_save()
	. = ..()
	var/datum/extension/local_network_member/local_network = get_extension(src, /datum/extension/local_network_member)
	if(local_network)
		initial_id_tag = local_network.id_tag

SAVED_VAR(/obj/machinery/internet_uplink, overmap_range)
SAVED_VAR(/obj/machinery/internet_uplink, restrict_networks)
SAVED_VAR(/obj/machinery/internet_uplink, permitted_networks)