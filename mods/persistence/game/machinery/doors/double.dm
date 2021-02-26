/obj/machinery/door/airlock/double/should_save(var/datum/caller)
	if(caller == loc)
		return ..()
	return 0