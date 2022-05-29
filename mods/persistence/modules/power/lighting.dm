/obj/machinery/light/Initialize(mapload, d, populate_parts)
	if(persistent_id)
		return ..(mapload, d, FALSE) //Prevent the lights from breaking on init
	. = ..()

/obj/machinery/light/small/emergency/cabled
	power_channel = LOCAL
	on = TRUE
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup,
	)

//#TODO: This is a temporary fix for the issue upstream, where components don't allow lights to draw power from cables + terminal if the area has no power.
/obj/machinery/light/small/emergency/cabled/powered()
	return !(stat & NOPOWER)

/obj/machinery/light/small/emergency/cabled/populate_parts(full_populate)
	if(persistent_id) // Only objects that have been loaded with have this var set at creation, so we prevent recreating additional components.
		return
	. = ..()
	var/obj/item/stock_parts/power/terminal/term = get_component_of_type(/obj/item/stock_parts/power/terminal)
	term.make_terminal(src) // intentional crash if there is no terminal
	queue_icon_update()
