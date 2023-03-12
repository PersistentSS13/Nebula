
#define ADMIN_PROTECTED_NET_GROUP "custodians"
#define OUTREACH_NETWORK_NAME     "outnet"
#define OUTREACH_TCOMM_NET_NAME   "outcom"

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
	filling = list(/decl/material/gas/oxygen = O2STANDARD, /decl/material/gas/nitrogen = N2STANDARD)

/obj/machinery/atmospherics/unary/tank/air/airlock/Initialize()
	. = ..()
	icon_state = "air"

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
// High volume air vent
////////////////////////////////////////////////////////////////////////
/obj/machinery/atmospherics/unary/vent_pump/high_volume/airlock
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/vent_pump/airlock = 1,
		/decl/stock_part_preset/radio/event_transmitter/vent_pump/airlock = 1
	)

////////////////////////////////////////////////////////////////////////
// Network
////////////////////////////////////////////////////////////////////////
/obj/machinery/internet_uplink/outreach
	initial_id_tag     = "ob_uplink"
	overmap_range      = 1
	restrict_networks  = TRUE
	permitted_networks = list(OUTREACH_NETWORK_NAME)

/obj/machinery/computer/internet_uplink/outreach
	initial_id_tag = "ob_uplink"

/obj/machinery/network/area_controller/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag = "oh_actrl"
	use_power = POWER_USE_ACTIVE
	maximum_component_parts = list(
		/obj/item/stock_parts = 200,
	)
	uncreated_component_parts = list(
		/obj/item/stock_parts/smes_coil = 7,
	)
	var/list/area_names = list(
		"OB 1B Servers Room",
		"OB 1B Cyrogenic Storage",
		"OB 1B Control Room",
		"OB 2B Power Storage",
		"OB 2B Geothermals",
		"OB 2B Atmos Tanks Perimeter",
		"OB 1B Atmospherics Hall",
	)

/obj/machinery/network/area_controller/outreach/Initialize()
	. = ..()
	//Thanks nata :c
	for(var/area/A in world)
		if(A.name in area_names)
			add_protected_area(A)
	update_use_power(POWER_USE_ACTIVE)

/obj/machinery/network/area_controller/outreach/proc/add_protected_area(var/area/A)
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	add_area(A)
	owned_areas[A] |= "[ADMIN_PROTECTED_NET_GROUP].[D.network_id]"
	update_protected_count()
	recalculate_power()

/obj/machinery/network/acl/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_acl"
	preset_groups      = list(
		ADMIN_PROTECTED_NET_GROUP = list()
	)

/obj/machinery/network/router/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_router"

/obj/machinery/network/modem/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_modem"

/obj/machinery/network/mainframe/files/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_files"

/obj/machinery/network/mainframe/account/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_accounts"

/obj/machinery/network/mainframe/logs/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_logs"

/obj/machinery/network/mainframe/records/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_records"

/obj/machinery/network/mainframe/software/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_softwares"

/obj/machinery/network/relay/wall_mounted/outreach
	initial_network_id = OUTREACH_NETWORK_NAME

////////////////////////////////////////////////////////////////////////
// Telecomms
////////////////////////////////////////////////////////////////////////
/obj/machinery/telecomms/bus/preset_one/outreach
	id = "ob_bus"
	network = OUTREACH_TCOMM_NET_NAME
	freq_listening = list()
	autolinkers = list(
		"ob_processor",
		"ob_tcomm_server",
		"ob_hub"
	)

/obj/machinery/telecomms/processor/preset_one/outreach
	id = "ob_processor"
	network = OUTREACH_TCOMM_NET_NAME
	autolinkers = list(
		"ob_processor",
		"ob_hub"
	)

/obj/machinery/telecomms/server/presets/outreach
	id = "ob_tcomm_server"
	freq_listening = list()
	channel_tags = list(
		list(SCI_FREQ,  "Science",       COMMS_COLOR_SCIENCE),
		list(MED_FREQ,  "Medical",       COMMS_COLOR_MEDICAL),
		list(SUP_FREQ,  "Supply",        COMMS_COLOR_SUPPLY),
		list(SRV_FREQ,  "Service",       COMMS_COLOR_SERVICE),
		list(PUB_FREQ,  "Common",        COMMS_COLOR_COMMON),
		list(AI_FREQ,   "AI Private",    COMMS_COLOR_AI),
		list(ENT_FREQ,  "Entertainment", COMMS_COLOR_ENTERTAIN),
		list(COMM_FREQ, "Command",       COMMS_COLOR_COMMAND),
		list(ENG_FREQ,  "Engineering",   COMMS_COLOR_ENGINEER),
		list(SEC_FREQ,  "Security",      COMMS_COLOR_SECURITY)
		)
	autolinkers = list(
		"ob_tcomm_server",
		"ob_bus"
	)

/obj/machinery/telecomms/hub/preset/outreach
	id = "ob_hub"
	network = OUTREACH_TCOMM_NET_NAME
	autolinkers = list(
		"ob_hub",
		"ob_receiver",
		"ob_broadcaster"
	)

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

#undef ADMIN_PROTECTED_NET_GROUP
#undef OUTREACH_NETWORK_NAME
#undef OUTREACH_TCOMM_NET_NAME