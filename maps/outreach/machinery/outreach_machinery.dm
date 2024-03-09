//
// Airlock controllers Outreach
//

/obj/machinery/embedded_controller/radio/airlock/advanced_airlock_controller/outreach
	cycle_to_external_air = TRUE
	req_access            = list(list(access_external_airlocks))

/obj/machinery/embedded_controller/radio/airlock/scrubbers/outreach
	cycle_to_external_air = TRUE
	req_access            = list(list(access_external_airlocks))

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
	command    = "cycle_interior"
	req_access = list(list(access_external_airlocks))

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
	controlled         = FALSE
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_pump/airlock,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/airlock,
	)

/obj/machinery/atmospherics/unary/vent_pump/high_volume/cabled
	power_channel = LOCAL
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/radio/transmitter/on_event/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup/offset_dir,
		/decl/stock_part_preset/radio/receiver/vent_pump,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump,
	)

/obj/machinery/atmospherics/unary/vent_pump/high_volume/cabled/airlock
	controlled         = FALSE
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup/offset_dir,
		/decl/stock_part_preset/radio/receiver/vent_pump/airlock,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/airlock,
	)

/obj/machinery/atmospherics/unary/vent_pump/high_volume/cabled/siphon
	controlled                      = FALSE
	pump_direction                  = 0
	pressure_checks                 = VENT_PRESSURE_CHECK_FLAG_INTERNAL
	pressure_checks_default         = VENT_PRESSURE_CHECK_FLAG_INTERNAL
	external_pressure_bound         = VENT_DEFAULT_EXTERNAL_PRESSURE_SIPHON
	external_pressure_bound_default = VENT_DEFAULT_EXTERNAL_PRESSURE_SIPHON
	internal_pressure_bound         = VENT_DEFAULT_INTERNAL_PRESSURE_SIPHON
	internal_pressure_bound_default = VENT_DEFAULT_INTERNAL_PRESSURE_SIPHON

/obj/machinery/atmospherics/unary/vent_pump/high_volume/cabled/siphon/on
	use_power = POWER_USE_IDLE
	icon_state = "map_vent_in"

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

/obj/machinery/light/small/red/wired
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

//#TODO: Make this light not burn out on its own and resistant to melee hits breaking the bulb
/obj/machinery/light/small/reinforced
	name = "reinforced light"
	base_type = /obj/machinery/light/small/reinforced

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

/obj/machinery/button/alternate/door/sec_checkpoint
	name = "open checkpoint doors button"
	id_tag = "oh_b1_sec_checkpoint_doors"
	stock_part_presets = list(
			/decl/stock_part_preset/radio/basic_transmitter/button/door
		)
/obj/machinery/door/airlock/glass/security/outreach/checkpoint
	id_tag = "oh_b1_sec_checkpoint_doors"

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
// Security Desk Flashers
////////////////////////////////////////////////////////////////////////

/obj/machinery/flasher/security_desk
	id_tag = "oh_b1_security_desk_flashers"

/obj/machinery/button/flasher/security_desk
	id_tag = "oh_b1_security_desk_flashers"

////////////////////////////////////////////////////////////////////////
// Suit Cyclers
////////////////////////////////////////////////////////////////////////

/obj/machinery/suit_cycler/emergency/prepared
	name                    = "work suit cycler unit"
	buildable               = FALSE
	locked                  = TRUE
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

/obj/machinery/power/smes/batteryrack/outreach
	mode = PSU_INPUT
	equalise = TRUE
	uncreated_component_parts = list(
		/obj/item/stock_parts/shielding/electric = 1,
		/obj/item/stock_parts/capacitor/super = 3,
		/obj/item/stock_parts/matter_bin/super = 1,
		/obj/item/stock_parts/power/battery/buildable/turbo = 9,
		/obj/item/cell/super = 9,
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


///////////////////////////////////////////////////////////////////////////////////////
// Telepads
///////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/telepad_cargo/Initialize(mapload, d, populate_parts)
	var/pre_id = telepad_id
	. = ..() //Base class replaces the telepad id on init
	if(pre_id)
		telepad_id = pre_id

/obj/machinery/telepad_cargo/desk_delivery
	telepad_id = "oh_gf_cargo_desk"

/obj/machinery/telepad_cargo/sorting_hall
	telepad_id = "oh_gf_cargo_sorting_hall"

///////////////////////////////////////////////////////////////////////////////////////
// Atmos
///////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/atmospherics/omni/filter/material_extractor
	name                 = "material extractor output filter"
	tag_north            = ATM_INPUT
	tag_south            = ATM_FILTER
	tag_east             = ATM_FILTER
	tag_west             = ATM_OUTPUT
	tag_filter_gas_north = null
	tag_filter_gas_south = "gas_nitrogen"
	tag_filter_gas_east  = "gas_oxygen"
	tag_filter_gas_west  = null

/obj/machinery/atmospherics/omni/filter/o2canister_refill
	name  = "o2 refill filter"
	color = COLOR_CYAN

/obj/machinery/atmospherics/omni/filter/o2canister_refill/mining_eva
	tag_north            = ATM_FILTER
	tag_south            = ATM_FILTER
	tag_east             = ATM_INPUT
	tag_west             = ATM_NONE
	tag_filter_gas_north = "gas_oxygen"
	tag_filter_gas_south = "gas_nitrogen"
	tag_filter_gas_east  = null
	tag_filter_gas_west  = null

/obj/machinery/atmospherics/omni/filter/o2canister_refill/south_b1_eva
	tag_north            = ATM_NONE
	tag_south            = ATM_OUTPUT
	tag_east             = ATM_INPUT
	tag_west             = ATM_FILTER
	tag_filter_gas_north = null
	tag_filter_gas_south = null
	tag_filter_gas_east  = null
	tag_filter_gas_west  = "gas_oxygen"

/obj/machinery/atmospherics/omni/filter/o2canister_refill/east_b1_eva
	tag_north            = ATM_INPUT
	tag_south            = ATM_NONE
	tag_east             = ATM_OUTPUT
	tag_west             = ATM_FILTER
	tag_filter_gas_north = null
	tag_filter_gas_south = null
	tag_filter_gas_east  = null
	tag_filter_gas_west  = "gas_oxygen"

/obj/machinery/atmospherics/omni/filter/airlock_filter
	name  = "airlock contaminants filter"
	color = COLOR_RED

/obj/machinery/atmospherics/omni/filter/airlock_filter/geo
	tag_north            = ATM_FILTER
	tag_south            = ATM_FILTER
	tag_east             = ATM_OUTPUT
	tag_west             = ATM_INPUT
	tag_filter_gas_north = "gas_oxygen"
	tag_filter_gas_south = "gas_nitrogen"
	tag_filter_gas_east  = null
	tag_filter_gas_west  = null

/obj/machinery/atmospherics/omni/mixer/airmix
	name = "omni gas mixer (airmix)"

/obj/machinery/atmospherics/omni/mixer/airmix/airlock
	tag_north     = ATM_INPUT
	tag_south     = ATM_INPUT
	tag_east      = ATM_OUTPUT
	tag_west      = ATM_NONE
	tag_north_con = 0.21
	tag_south_con = 0.78

//
// Gas Harvest Vents
//



/obj/machinery/atmospherics/unary/vent_pump/high_volume/cabled/siphon/on/harvester
	name = "harvesting vent"

/obj/machinery/atmospherics/unary/vent_pump/high_volume/cabled/siphon/on/harvester/nb1
	id_tag = "oh_gf_vent_harvest_1"
/obj/machinery/atmospherics/unary/vent_pump/high_volume/cabled/siphon/on/harvester/nb2
	id_tag = "oh_gf_vent_harvest_2"
/obj/machinery/atmospherics/unary/vent_pump/high_volume/cabled/siphon/on/harvester/nb3
	id_tag = "oh_gf_vent_harvest_3"

//Buttons

/obj/machinery/button/toggle/alternate/harvesters
	name = "harvester toggle switch"
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal/buildable,
		/obj/item/stock_parts/radio/transmitter/basic/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/basic_transmitter/button/door,
		/decl/stock_part_preset/terminal_setup
	)
/decl/stock_part_preset/radio/basic_transmitter/button/vent/harvester
	frequency = EXTERNAL_AIR_FREQ
	transmit_on_change = list("power_toggle" = /decl/public_access/public_variable/button_active)

/obj/machinery/button/toggle/alternate/harvesters/nb1
	id_tag = "oh_gf_vent_harvest_1"
/obj/machinery/button/toggle/alternate/harvesters/nb2
	id_tag = "oh_gf_vent_harvest_2"
/obj/machinery/button/toggle/alternate/harvesters/nb3
	id_tag = "oh_gf_vent_harvest_3"

//Helper types for whenever we have cryo networks
/obj/machinery/cryopod/despawner/main
/obj/machinery/cryopod/despawner/arrival


//
// Crematorium
//

/obj/structure/crematorium/outreach
	id_tag = "ob_med_crema"
/obj/machinery/button/crematorium/outreach
	id_tag = "ob_med_crema"

//
// Bot Patrol Nav Beacons
//

/obj/machinery/navbeacon/outreach
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/engineering,
	)

// Basement #2
/obj/machinery/navbeacon/outreach/patrol/b2_stairwell
	location = "OH B2 Stairwell"
	codes = list("patrol" = TRUE, "next_patrol" = "OH B2 North Hallway")

/obj/machinery/navbeacon/outreach/patrol/b2_hallway_north
	location = "OH B2 North Hallway"
	codes = list("patrol" = TRUE, "next_patrol" = "OH B2 East Hallway")
/obj/machinery/navbeacon/outreach/patrol/b2_hallway_east
	location = "OH B2 East Hallway"
	codes = list("patrol" = TRUE, "next_patrol" = "OH B2 South Hallway")
/obj/machinery/navbeacon/outreach/patrol/b2_hallway_south
	location = "OH B2 South Hallway"
	codes = list("patrol" = TRUE, "next_patrol" = "OH B2 Stairwell")

// Basement #1
/obj/machinery/navbeacon/outreach/patrol/b1_stairwell
	location = "OH B1 Stairwell"
	codes = list("patrol" = TRUE, "next_patrol" = "OH B1 Security")

/obj/machinery/navbeacon/outreach/patrol/security
	location = "OH B1 Security"
	codes    = list("patrol" = TRUE, "next_patrol" = "OH B1 Cafeteria")
/obj/machinery/navbeacon/outreach/patrol/cafeteria
	location = "OH B1 Cafeteria"
	codes    = list("patrol" = TRUE, "next_patrol" = "OH B1 Bathroom")
/obj/machinery/navbeacon/outreach/patrol/bathroom
	location = "OH B1 Bathroom"
	codes    = list("patrol" = TRUE, "next_patrol" = "OH B1 Botany")
/obj/machinery/navbeacon/outreach/patrol/botany
	location = "OH B1 Botany"
	codes    = list("patrol" = TRUE, "next_patrol" = "OH B1 Kitchen")
/obj/machinery/navbeacon/outreach/patrol/kitchen
	location = "OH B1 Kitchen"
	codes    = list("patrol" = TRUE, "next_patrol" = "OH B1 Mining Lobby")
/obj/machinery/navbeacon/outreach/patrol/mining_lobby
	location = "OH B1 Mining Lobby"
	codes    = list("patrol" = TRUE, "next_patrol" = "OH EVA B1 SOUTH")
/obj/machinery/navbeacon/outreach/patrol/EVA_b1_south
	location = "OH EVA B1 SOUTH"
	codes = list("patrol" = TRUE, "next_patrol" = "OH B1 Medical Lobby")
/obj/machinery/navbeacon/outreach/patrol/medical_lobby
	location = "OH B1 Medical Lobby"
	codes = list("patrol" = TRUE, "next_patrol" = "OH EVA B1 EAST")
/obj/machinery/navbeacon/outreach/patrol/EVA_b1_east
	location = "OH EVA B1 EAST"
	codes = list("patrol" = TRUE, "next_patrol" = "OH B1 Cryo")
/obj/machinery/navbeacon/outreach/patrol/EVA_b1_cryo
	location = "OH B1 Cryo"
	codes = list("patrol" = TRUE, "next_patrol" = "OH B1 North Hall")
/obj/machinery/navbeacon/outreach/patrol/b1_north_hall
	location = "OH B1 North Hall"
	codes = list("patrol" = TRUE, "next_patrol" = "OH B1 Chemistry Lobby")
/obj/machinery/navbeacon/outreach/patrol/chemistry_lobby
	location = "OH B1 Chemistry Lobby"
	codes = list("patrol" = TRUE, "next_patrol" = "OH B1 Atmos Lobby")
/obj/machinery/navbeacon/outreach/patrol/atmos_lobby
	location = "OH B1 Atmos Lobby"
	codes = list("patrol" = TRUE, "next_patrol" = "OH B1 West Hall")
/obj/machinery/navbeacon/outreach/patrol/b1_west_hall
	location = "OH B1 West Hall"
	codes = list("patrol" = TRUE, "next_patrol" = "OH B1 Stairwell")

// Ground Floor
/obj/machinery/navbeacon/outreach/patrol/gf_stairwell
	location = "OH GF Stairwell"
	codes = list("patrol" = TRUE, "next_patrol" = "OH GF Supply Lobby")

/obj/machinery/navbeacon/outreach/patrol/supply_lobby
	location = "OH GF Supply Lobby"
	codes = list("patrol" = TRUE, "next_patrol" = "OH GF West Hallway")
/obj/machinery/navbeacon/outreach/patrol/gf_west
	location = "OH GF West Hallway"
	codes = list("patrol" = TRUE, "next_patrol" = "OH GF Engineering Lobby")
/obj/machinery/navbeacon/outreach/patrol/engineering_lobby
	location = "OH GF Engineering Lobby"
	codes = list("patrol" = TRUE, "next_patrol" = "OH GF Hangar")
/obj/machinery/navbeacon/outreach/patrol/hangar
	location = "OH GF Hangar"
	codes = list("patrol" = TRUE, "next_patrol" = "OH EVA GF EAST NORTH")
/obj/machinery/navbeacon/outreach/patrol/EVA_gf_east_north
	location = "OH EVA GF EAST NORTH"
	codes = list("patrol" = TRUE, "next_patrol" = "OH EVA GF EAST SOUTH")
/obj/machinery/navbeacon/outreach/patrol/EVA_gf_east_south
	location = "OH EVA GF EAST SOUTH"
	codes = list("patrol" = TRUE, "next_patrol" = "OH GF South Hallway")
/obj/machinery/navbeacon/outreach/patrol/gf_south
	location = "OH GF South Hallway"
	codes = list("patrol" = TRUE, "next_patrol" = "OH GF Stairwell")

// First Floor
/obj/machinery/navbeacon/outreach/patrol/f1_stairwell
	location = "OH 1F Stairwell"
	codes = list("patrol" = TRUE, "next_patrol" = "OH 1F Hallway North")

/obj/machinery/navbeacon/outreach/patrol/f1_hallway_north
	location = "OH 1F Hallway North"
	codes = list("patrol" = TRUE, "next_patrol" = "OH 1F Hallway East")
/obj/machinery/navbeacon/outreach/patrol/f1_hallway_east
	location = "OH 1F Hallway East"
	codes = list("patrol" = TRUE, "next_patrol" = "OH 1F Hallway South")
/obj/machinery/navbeacon/outreach/patrol/f1_hallway_south
	location = "OH 1F Hallway South"
	codes = list("patrol" = TRUE, "next_patrol" = "OH 1F Hallway South West")
/obj/machinery/navbeacon/outreach/patrol/f1_hallway_south_west
	location = "OH 1F Hallway South West"
	codes = list("patrol" = TRUE, "next_patrol" = "OH 1F Hallway West")
/obj/machinery/navbeacon/outreach/patrol/f1_hallway_south_west
	location = "OH 1F Hallway West"
	codes = list("patrol" = TRUE, "next_patrol" = "OH 1F Stairwell")

//
// Bot Delivery Nav Beacons
//

/obj/machinery/navbeacon/outreach/delivery/supply/one
	location = "Supply Delivery #1"
	codes    = list("delivery" = TRUE, "dir" = WEST)

/obj/machinery/navbeacon/outreach/delivery/supply/two
	location = "Supply Delivery #2"
	codes    = list("delivery" = TRUE, "dir" = WEST)

/obj/machinery/navbeacon/outreach/delivery/supply/three
	location = "Supply Delivery #3"
	codes    = list("delivery" = TRUE, "dir" = WEST)

/obj/machinery/navbeacon/outreach/delivery/supply/four
	location = "Supply Delivery #4"
	codes    = list("delivery" = TRUE, "dir" = WEST)

/obj/machinery/navbeacon/outreach/delivery/chemistry
	location = "Chemistry"
	codes = list("delivery" = TRUE, "dir" = WEST)

/obj/machinery/navbeacon/outreach/delivery/janitor
	location = "Janitor"
	codes = list("delivery" = TRUE, "dir" = WEST)

/obj/machinery/navbeacon/outreach/delivery/security
	location = "Security"
	codes = list("delivery" = TRUE, "dir" = WEST)

/obj/machinery/navbeacon/outreach/delivery/engineer_storage
	location = "Tool Storage"
	codes = list("delivery" = TRUE, "dir" = WEST)

/obj/machinery/navbeacon/outreach/delivery/medbay
	location = "Medbay"
	codes = list("delivery" = TRUE, "dir" = EAST)

/obj/machinery/navbeacon/outreach/delivery/engineering
	location = "Engineering"
	codes = list("delivery" = TRUE, "dir" = EAST)

/obj/machinery/navbeacon/outreach/delivery/kitchen
	location = "Kitchen"
	codes = list("delivery" = TRUE, "dir" = SOUTH)

/obj/machinery/navbeacon/outreach/delivery/hydroponics
	location = "Hydroponics"
	codes = list("delivery" = TRUE, "dir" = SOUTH)


/obj/machinery/portable_atmospherics/powered/scrubber/huge/outreach
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc/buildable,
		/obj/item/stock_parts/network_receiver/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
	)
	stock_part_presets = null

/obj/machinery/portable_atmospherics/powered/scrubber/huge/outreach/cabled
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal/buildable,
		/obj/item/stock_parts/network_receiver/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup,
	)

/obj/machinery/portable_atmospherics/powered/scrubber/huge/outreach/gas_tanks
	id_tag = "oh_atmos_tank_emergency_scrubber"