/obj/item/stock_parts/power/terminal/Initialize(ml, material_key)
	. = ..()
	if(persistent_id && terminal && istype(loc, /obj/machinery))
		set_terminal(loc, terminal)