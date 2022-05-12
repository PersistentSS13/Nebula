//Vent working directly with cable power instead of apcs
/obj/machinery/atmospherics/unary/vent_pump/cabled
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/radio/transmitter/on_event/buildable,
	)

/obj/machinery/atmospherics/unary/vent_pump/cabled/populate_parts(full_populate)
	if(persistent_id) // Only objects that have been loaded with have this var set at creation, so we prevent recreating additional components.
		return
	. = ..()
	var/obj/item/stock_parts/power/terminal/term = get_component_of_type(/obj/item/stock_parts/power/terminal)
	term.terminal_dir = dir
	term.make_terminal(src) // intentional crash if there is no terminal
	queue_icon_update()

/obj/machinery/atmospherics/unary/vent_pump/cabled/on
	use_power = POWER_USE_IDLE
	icon_state = "map_vent_in"

/obj/machinery/atmospherics/unary/vent_pump/cabled/siphon
	pump_direction = 0
	external_pressure_bound = 0
	external_pressure_bound_default = 0
	internal_pressure_bound = MAX_PUMP_PRESSURE
	internal_pressure_bound_default = MAX_PUMP_PRESSURE
	pressure_checks = 2
	pressure_checks_default = 2

/obj/machinery/atmospherics/unary/vent_pump/cabled/siphon/on
	use_power = POWER_USE_IDLE
	icon_state = "map_vent_in"
