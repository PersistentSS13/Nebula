/obj/machinery/atmospherics/omni/initialize_ports(initial)
	if(initial && persistent_id && length(ports))
		return

	return ..()