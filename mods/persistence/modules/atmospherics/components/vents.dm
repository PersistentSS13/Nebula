//Vent working directly with cable power instead of apcs
/obj/machinery/atmospherics/unary/vent_pump/cabled
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/radio/transmitter/on_event/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_pump = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump = 1,
		/decl/stock_part_preset/terminal_setup/offset_dir,
	)

/obj/machinery/atmospherics/unary/vent_pump/cabled/populate_parts(full_populate)
	if(persistent_id) // Only objects that have been loaded with have this var set at creation, so we prevent recreating additional components.
		return
	. = ..()
	//#FIXME: What is going on here? This is kind of dangerous and a weird way to go about things??
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

/obj/machinery/atmospherics/unary/vent_pump/cabled/airlock
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_pump/airlock = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/airlock = 1,
		/decl/stock_part_preset/terminal_setup/offset_dir,
	)