/obj/machinery/atmospherics/unary/outlet_injector/cabled
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/radio/transmitter/on_event/buildable,
	)

/obj/machinery/atmospherics/unary/outlet_injector/cabled/populate_parts(full_populate)
	if(persistent_id) // Only objects that have been loaded with have this var set at creation, so we prevent recreating additional components.
		return
	. = ..()
	var/obj/item/stock_parts/power/terminal/term = get_component_of_type(/obj/item/stock_parts/power/terminal)
	term.terminal_dir = dir
	term.make_terminal(src) // intentional crash if there is no terminal
	queue_icon_update()

/obj/machinery/atmospherics/unary/outlet_injector/cabled/on
	icon_state = "on"
	use_power = POWER_USE_IDLE