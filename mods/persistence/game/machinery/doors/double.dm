/obj/machinery/door/airlock/double/before_save()
	. = ..()
	var/turf/T = loc
	if(isturf(T))
		CUSTOM_SV_LIST("orig_x" = T.x, "orgi_y" = T.y)

/obj/machinery/door/airlock/double/after_deserialize()
	. = ..()
	var/orig_x = LOAD_CUSTOM_SV("orig_x")
	var/orig_y = LOAD_CUSTOM_SV("orig_y")
	if(orig_x && orig_y)
		loc = locate(orig_x, orig_y, z) //Don't forceMove before init
	CLEAR_SV("orig_x")
	CLEAR_SV("orgi_y")
	//Doors do really dumb stuff on init and move around a bunch, so this is necessary