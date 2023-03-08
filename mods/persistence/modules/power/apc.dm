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

///////////////////////////////////////////////////
// Saved Var Define
///////////////////////////////////////////////////
SAVED_VAR(/obj/machinery/power/apc, shorted)
SAVED_VAR(/obj/machinery/power/apc, lighting)
SAVED_VAR(/obj/machinery/power/apc, equipment)
SAVED_VAR(/obj/machinery/power/apc, environ)
SAVED_VAR(/obj/machinery/power/apc, operating)
SAVED_VAR(/obj/machinery/power/apc, chargemode)
SAVED_VAR(/obj/machinery/power/apc, locked)
SAVED_VAR(/obj/machinery/power/apc, aidisabled)
SAVED_VAR(/obj/machinery/power/apc, lastused_light)
SAVED_VAR(/obj/machinery/power/apc, lastused_equip)
SAVED_VAR(/obj/machinery/power/apc, lastused_environ)
SAVED_VAR(/obj/machinery/power/apc, lastused_charging)
SAVED_VAR(/obj/machinery/power/apc, lastused_total)
SAVED_VAR(/obj/machinery/power/apc, main_status)
SAVED_VAR(/obj/machinery/power/apc, beenhit)
SAVED_VAR(/obj/machinery/power/apc, is_critical)
SAVED_VAR(/obj/machinery/power/apc, autoflag)
