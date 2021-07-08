/obj/machinery/power/apc
	initial_access = list()

/obj/machinery/power/apc/Initialize(mapload, var/ndir, var/populate_parts = TRUE)
	var/cur_operating = operating
	. = ..()
	operating = cur_operating
	queue_icon_update()

	if(loc && operating)
		force_update_channels()
	power_change()

/obj/machinery/power/apc/init_round_start()
	if(persistent_id) // Check if this is a loaded APC.
		return
	. = ..()