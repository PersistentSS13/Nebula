////////////////////////////////////////////////////////////////////////
// Wired airlock sensor
////////////////////////////////////////////////////////////////////////
/obj/machinery/airlock_sensor/wired
	power_channel = LOCAL
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal,
		/obj/item/stock_parts/radio/transmitter/basic/buildable
	)
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup = 1,
		/decl/stock_part_preset/radio/basic_transmitter/airlock_sensor = 1
	)

////////////////////////////////////////////////////////////////////////
// Wired airlock button
////////////////////////////////////////////////////////////////////////
/obj/machinery/button/access/wired
	power_channel = LOCAL
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal,
		/obj/item/stock_parts/radio/transmitter/on_event/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup = 1,
		/decl/stock_part_preset/radio/event_transmitter/access_button = 1,
		/decl/stock_part_preset/radio/receiver/access_button = 1,
	)

/obj/machinery/button/access/wired/interior
	command = "cycle_interior"

/obj/machinery/button/access/wired/exterior
	command = "cycle_exterior"

////////////////////////////////////////////////////////////////////////
// Airlock Door
////////////////////////////////////////////////////////////////////////
/obj/machinery/door/airlock/external/glass/bolted/airlock

/obj/machinery/door/airlock/external/glass/bolted_open/airlock
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock/external_air = 1,
		/decl/stock_part_preset/radio/event_transmitter/airlock/external_air = 1
	)

////////////////////////////////////////////////////////////////////////
// Airlock canister
////////////////////////////////////////////////////////////////////////
/obj/machinery/atmospherics/unary/tank/air/airlock
	name = "Pressure Tank (Air)"
	icon_state = "air_mapped"
	start_pressure = ONE_ATMOSPHERE / 4
	filling = list(
		/decl/material/gas/oxygen   = O2STANDARD,
		/decl/material/gas/nitrogen = N2STANDARD,
	)

/obj/machinery/atmospherics/unary/tank/air/airlock/Initialize(mapload, d, populate_parts)
	. = ..()
	icon_state = "air"

////////////////////////////////////////////////////////////////////////
// High volume air vent
////////////////////////////////////////////////////////////////////////
/obj/machinery/atmospherics/unary/vent_pump/high_volume/airlock
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_pump/airlock = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/airlock = 1
	)

////////////////////////////////////////////////////////////////////////
// Exterior lights
////////////////////////////////////////////////////////////////////////
/obj/machinery/light/wired
	power_channel = LOCAL
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal,
	)
	stock_part_presets = list(/decl/stock_part_preset/terminal_setup)

/obj/machinery/light/small/wired
	power_channel = LOCAL
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal,
	)
	stock_part_presets = list(/decl/stock_part_preset/terminal_setup)

/obj/machinery/light/spot/wired
	power_channel = LOCAL
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal,
	)
	stock_part_presets = list(/decl/stock_part_preset/terminal_setup)

////////////////////////////////////////////////////////////////////////
// Buttons
////////////////////////////////////////////////////////////////////////
/obj/machinery/button/blast_door/wired
	stock_part_presets = list(
		/decl/stock_part_preset/radio/event_transmitter/blast_door_button = 1,
		/decl/stock_part_preset/radio/receiver/blast_door_button = 1,
		/decl/stock_part_preset/terminal_setup = 1,
	)
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal,
		/obj/item/stock_parts/radio/transmitter/on_event/buildable,
		/obj/item/stock_parts/radio/receiver/buildable
	)

////////////////////////////////////////////////////////////////////////
// Doors
////////////////////////////////////////////////////////////////////////
/obj/machinery/door/airlock/external/glass/wired
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup,
		/decl/stock_part_preset/radio/receiver/airlock/external_air,
		/decl/stock_part_preset/radio/event_transmitter/airlock/external_air
	)
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal,
		/obj/item/stock_parts/radio/transmitter/on_event/buildable,
		/obj/item/stock_parts/radio/receiver/buildable
	)

////////////////////////////////////////////////////////////////////////
// Blast Doors
////////////////////////////////////////////////////////////////////////
/obj/machinery/door/blast/regular/wired
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup,
		/decl/stock_part_preset/radio/receiver/blast_door,
	)
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal,
		/obj/item/stock_parts/radio/receiver/buildable,
	)

/obj/machinery/door/blast/regular/wired/open
	icon_state = "pdoor0"
	begins_closed = FALSE


////////////////////////////////////////////////////////////////////////
// Suit Cyclers
////////////////////////////////////////////////////////////////////////
/obj/machinery/suit_cycler/emergency/prepared
	name                    = "work suit cycler unit"
	buildable               = FALSE
	initial_access          = list()
	helmet                  = /obj/item/clothing/head/helmet/space/emergency
	suit                    = /obj/item/clothing/suit/space/emergency
	boots                   = /obj/item/clothing/shoes/workboots
	available_bodytypes     = list(BODYTYPE_HUMANOID, BODYTYPE_MONKEY)
	available_modifications = list(
		/decl/item_modifier/space_suit/engineering,
		/decl/item_modifier/space_suit/mining,
		/decl/item_modifier/space_suit/medical,
		/decl/item_modifier/space_suit/security,
		/decl/item_modifier/space_suit/atmos,
		/decl/item_modifier/space_suit/science,
		/decl/item_modifier/space_suit/pilot,
		/decl/item_modifier/space_suit/salvage,
	)

////////////////////////////////////////////////////////////////////////
// SMES
////////////////////////////////////////////////////////////////////////
/obj/machinery/power/smes/buildable/preset/outreach
	_fully_charged = TRUE
	_input_maxed   = TRUE
	_input_on      = TRUE
	_output_maxed  = FALSE
	_output_on     = TRUE
	output_level   = 150000
	maximum_component_parts = list(
		/obj/item/stock_parts = 20,
	)
	uncreated_component_parts = list(
		/obj/item/stock_parts/smes_coil/super_capacity = 5,
		/obj/item/stock_parts/smes_coil/super_io       = 1,
	)

/obj/machinery/power/smes/buildable/preset/outreach/substation
	_fully_charged = TRUE
	_input_maxed   = TRUE
	_input_on      = TRUE
	_output_maxed  = FALSE
	_output_on     = TRUE
	output_level   = 100000
	uncreated_component_parts = list(
		/obj/item/stock_parts/smes_coil/super_capacity = 2,
		/obj/item/stock_parts/smes_coil/super_io       = 1,
	)

////////////////////////////////////////////////////////////////////////
// Docking Beacon
////////////////////////////////////////////////////////////////////////
/obj/machinery/docking_beacon/mapped
	anchored = TRUE

////////////////////////////////////////////////////////////////////////
// Defense Turret
////////////////////////////////////////////////////////////////////////
/obj/machinery/porta_turret/stationary/stun
	ailock         = TRUE
	lethal         = FALSE
	check_weapons  = TRUE
	auto_repair    = TRUE
	controllock    = FALSE
	maxhealth      = 280
	health         = 280
	installation   = /obj/item/gun/energy/gun/mounted
	initial_access = list(list(access_security), list(access_bridge), list(access_ce))


/obj/machinery/door/airlock/hatch/bolted
	locked = TRUE
