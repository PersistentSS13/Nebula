/obj/machinery/door/Initialize(mapload, d, populate_parts, obj/structure/door_assembly/assembly)
	if(persistent_id)
		CUSTOM_SV("current_health", current_health) //Health gets overwritten with maxhealth in parent init
	. = ..()
	if(persistent_id)
		current_health = LOAD_CUSTOM_SV("current_health")
		CLEAR_SV("current_health")

/obj/machinery/door/LateInitialize(mapload, dir=0, populate_parts=TRUE)
	// Don't populate parts if this is a saved door
	if(persistent_id)
		return ..(mapload, dir, FALSE)
	return ..()

/obj/machinery/door/update_connections(propagate)
	if(!persistent_id) //Don't let it do this when loading from save
		. = ..()