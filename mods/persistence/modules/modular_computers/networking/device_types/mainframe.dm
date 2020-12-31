/datum/extension/network_device/mainframe/update_roles()
	. = ..()
	var/obj/machinery/network/mainframe/M = holder
	if(istype(M))
		M.initial_roles = roles