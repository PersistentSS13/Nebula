/obj/machinery/atmospherics/unary/fission_core/before_save()
	. = ..()
	var/datum/extension/local_network_member/fission = get_extension(src, /datum/extension/local_network_member)
	initial_id_tag = fission.id_tag