/obj/machinery/light/Initialize(mapload, d, populate_parts)
	if(persistent_id)
		return ..(mapload, d, FALSE) //Prevent the lights from breaking on init
	. = ..()
	