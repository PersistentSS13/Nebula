/obj/item/stock_parts/Initialize(ml, material_key)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/stock_parts/LateInitialize()
	. = ..()
	if(persistent_id && istype(loc, /obj/machinery))
		var/obj/machinery/M = loc
		M.install_component(src, FALSE, TRUE)