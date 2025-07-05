/obj/machinery/atmospherics/pipe/Initialize()
	. = ..()
	if(persistent_id && leaking)
		leaking = 0
		set_leaking(TRUE)
