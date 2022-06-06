/obj/item/stock_parts/computer/battery_module
	var/obj/item/cell/old_battery

/obj/item/stock_parts/computer/battery_module/before_save()
	. = ..()
	if(istype(battery))
		old_battery = battery
		battery = old_battery.type
		CUSTOM_SV("charge", old_battery.charge)

/obj/item/stock_parts/computer/battery_module/after_save()
	if(istype(old_battery))
		battery = old_battery
		old_battery = null
	. = ..()

/obj/item/stock_parts/computer/battery_module/Initialize()
	. = ..()
	if(persistent_id)
		var/old_charge = LOAD_CUSTOM_SV("charge")
		battery.charge = old_charge