/obj/item/stock_parts/computer/battery_module/Initialize()
	// Painful override to stop attempting to create a type rather than a path on load.
	var/old_battery
	if(istype(battery))
		old_battery = battery
		battery = /obj/item/cell/
	. = ..()
	QDEL_NULL(battery)
	battery = old_battery
	