/obj/machinery/door/airlock/highsecurity/outreach
	icon_state = "closed"

/obj/machinery/door/airlock/hatch/bolted
	locked = TRUE

////////////////////////////////////////////////////////////////////////
// Command
////////////////////////////////////////////////////////////////////////

/obj/machinery/door/airlock/command/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/command,
	)
/obj/machinery/door/airlock/glass/command/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/command,
	)

/obj/machinery/door/airlock/highsecurity/outreach/telecom
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)

/obj/machinery/door/airlock/hatch/maintenance/outreach/command
	stripe_color = COLOR_COMMAND_BLUE

/obj/machinery/door/airlock/vault/outreach
	name = "archive vault door"
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/command/records,
	)

////////////////////////////////////////////////////////////////////////
// Security
////////////////////////////////////////////////////////////////////////

/obj/machinery/door/airlock/security/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/security,
	)
/obj/machinery/door/airlock/security/outreach/public
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
	)
/obj/machinery/door/airlock/glass/security/outreach/bolted
	locked = TRUE
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
	)

/obj/machinery/door/airlock/glass/security/outreach/bolted/cell_door
/obj/machinery/door/airlock/glass/security/outreach/bolted/cell_door/c1
	id_tag = "oh_b1_security_door_cell_1"
/obj/machinery/door/airlock/glass/security/outreach/bolted/cell_door/c2
	id_tag = "oh_b1_security_door_cell_2"
/obj/machinery/door/airlock/glass/security/outreach/bolted/cell_door/c3
	id_tag = "oh_b1_security_door_cell_3"

/obj/machinery/door/airlock/security/outreach/forensics
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/security/forensics,
	)
/obj/machinery/door/airlock/security/outreach/brig
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/security/brig,
	)

/obj/machinery/door/airlock/glass/security/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/security,
	)
/obj/machinery/door/airlock/glass/security/outreach/public
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
	)
/obj/machinery/door/airlock/glass/security/outreach/head
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/security/head,
	)
/obj/machinery/door/airlock/glass/security/outreach/warden
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/security/warden,
	)
/obj/machinery/door/airlock/glass/security/outreach/detective
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/security/detective,
	)
/obj/machinery/door/airlock/glass/security/outreach/forensics
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/security/forensics,
	)
/obj/machinery/door/airlock/glass/security/outreach/brig
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/security/brig,
	)

/obj/machinery/door/airlock/highsecurity/outreach/armory
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/security/armory,
	)
/obj/machinery/door/airlock/highsecurity/outreach/evidence
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/security/forensics,
	)

/obj/machinery/door/airlock/highsecurity/outreach/sec_chief_storage
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/security/head,
	)

////////////////////////////////////////////////////////////////////////
// Medical
////////////////////////////////////////////////////////////////////////

/obj/machinery/door/airlock/medical/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/medical,
	)
/obj/machinery/door/airlock/medical/outreach/head
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/medical/head,
	)
/obj/machinery/door/airlock/medical/outreach/morgue
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/medical/morgue,
	)


/obj/machinery/door/airlock/glass/medical/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/medical,
	)
/obj/machinery/door/airlock/glass/medical/outreach/head
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/medical/head,
	)
/obj/machinery/door/airlock/glass/medical/outreach/storage
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/medical/storage,
	)
/obj/machinery/door/airlock/glass/medical/outreach/public
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
	)

/obj/machinery/door/airlock/hatch/maintenance/outreach/medical
	icon_state = "closed"
	stripe_color = COLOR_DEEP_SKY_BLUE

/obj/machinery/door/airlock/double/glass/outreach
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)

/obj/machinery/door/airlock/double/glass/medical/outreach
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/medical,
	)

////////////////////////////////////////////////////////////////////////
// Engineering
////////////////////////////////////////////////////////////////////////

/obj/machinery/door/airlock/engineering/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/engineering,
	)

/obj/machinery/door/airlock/glass/engineering/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/engineering,
	)
/obj/machinery/door/airlock/glass/engineering/outreach/head
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/engineering/head,
	)
/obj/machinery/door/airlock/glass/engineering/outreach/storage
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/engineering/storage,
	)
/obj/machinery/door/airlock/glass/engineering/outreach/atmos
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/engineering/atmos,
	)
/obj/machinery/door/airlock/glass/engineering/outreach/power
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/engineering/power,
	)

////////////////////////////////////////////////////////////////////////
// Mining
////////////////////////////////////////////////////////////////////////

/obj/machinery/door/airlock/mining/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/mining,
	)
/obj/machinery/door/airlock/glass/mining/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/mining,
	)

/obj/machinery/door/airlock/glass/mining/outreach/qm
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/mining/head,
	)

/obj/machinery/door/airlock/glass/mining/outreach/processing
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/mining/processing,
	)

/obj/machinery/door/airlock/hatch/maintenance/outreach/mining
	stripe_color = COLOR_BEASTY_BROWN

/obj/machinery/door/airlock/double/glass/mining/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/mining,
	)

/obj/machinery/door/airlock/double/mining/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/mining,
	)

////////////////////////////////////////////////////////////////////////
// Cargo
////////////////////////////////////////////////////////////////////////

/obj/machinery/door/airlock/cargo
	icon_state = "closed"
	stripe_color = COLOR_BEASTY_BROWN

/obj/machinery/door/airlock/glass/cargo
	icon_state = "closed"
	stripe_color = COLOR_BEASTY_BROWN

/obj/machinery/door/airlock/cargo/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/cargo,
	)


/obj/machinery/door/airlock/glass/cargo/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/cargo,
	)
/obj/machinery/door/airlock/glass/cargo/outreach/public
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
	)
/obj/machinery/door/airlock/glass/cargo/outreach/head
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/cargo/head,
	)

/obj/machinery/door/airlock/highsecurity/outreach/cargo_warehouse
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/cargo/vault,
	)

////////////////////////////////////////////////////////////////////////
// Atmos
////////////////////////////////////////////////////////////////////////

/obj/machinery/door/airlock/atmos/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/engineering/atmos,
	)
/obj/machinery/door/airlock/glass/atmos/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/engineering/atmos,
	)

////////////////////////////////////////////////////////////////////////
// Research
////////////////////////////////////////////////////////////////////////

/obj/machinery/door/airlock/research/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/research,
	)
/obj/machinery/door/airlock/glass/research/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/research,
	)

/obj/machinery/door/airlock/research/outreach/chemistry
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/research/chemistry,
	)
/obj/machinery/door/airlock/glass/research/outreach/chemistry
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/research/chemistry,
	)

////////////////////////////////////////////////////////////////////////
// Maintenance
////////////////////////////////////////////////////////////////////////

/obj/machinery/door/airlock/maintenance/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/maintenance,
	)
/obj/machinery/door/airlock/glass/maintenance/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/maintenance,
	)

/obj/machinery/door/airlock/hatch/maintenance/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/maintenance,
	)

////////////////////////////////////////////////////////////////////////
// Exterior
////////////////////////////////////////////////////////////////////////

/obj/machinery/door/airlock/external/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/exterior_airlocks,
	)
/obj/machinery/door/airlock/external/glass/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/exterior_airlocks,
	)
/obj/machinery/door/airlock/external/glass/outreach/bolted
	locked = TRUE

////////////////////////////////////////////////////////////////////////
// Civilian
////////////////////////////////////////////////////////////////////////

/obj/machinery/door/airlock/glass/civilian/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/research,
	)

/obj/machinery/door/airlock/glass/civilian/outreach/eva
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/eva,
	)

/obj/machinery/door/airlock/glass/civilian/outreach/kitchen
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/kitchen,
	)
/obj/machinery/door/airlock/civilian/outreach/kitchen
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/kitchen,
	)
/obj/machinery/door/airlock/freezer/outreach
	icon_state = "closed"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/kitchen,
	)


/obj/machinery/door/airlock/glass/civilian/outreach/botany
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/botany,
	)
/obj/machinery/door/airlock/civilian/outreach/botany
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/receiver/airlock,
		/decl/stock_part_preset/radio/event_transmitter/airlock,
		/decl/stock_part_preset/network_lock/outreach/botany,
	)



////////////////////////////////////////////////////////////////////////
// Shutters
////////////////////////////////////////////////////////////////////////

/obj/machinery/door/blast/shutters/open/cafetaria
	id_tag = "oh_b1_cafetaria_shutters"
/obj/machinery/button/blast_door/cafetaria
	name   = "cafetaria shutters control"
	id_tag = "oh_b1_cafetaria_shutters"

/obj/machinery/door/blast/shutters/engineering
	id_tag = "oh_gf_engineering_warehouse_shutters"
/obj/machinery/button/blast_door/engineering
	name   = "warehouse shutters button"
	id_tag = "oh_gf_engineering_warehouse_shutters"

/obj/machinery/door/blast/shutters/cargo_warehouse
	id_tag = "oh_gf_supply_warehouse_shutters"
/obj/machinery/button/blast_door/cargo_warehouse
	name   = "warehouse shutters button"
	id_tag = "oh_gf_supply_warehouse_shutters"

/obj/machinery/door/blast/shutters/open/cargo
	id_tag = "oh_gf_supply_shutters"
/obj/machinery/button/blast_door/cargo
	name   = "office shutters button"
	id_tag = "oh_gf_supply_shutters"

/obj/machinery/door/blast/shutters/open/arrival
	id_tag = "oh_f1_arrival_shutters"
/obj/machinery/button/blast_door/arrival
	name   = "office shutters button"
	id_tag = "oh_f1_arrival_shutters"

/obj/machinery/door/blast/shutters/server_cooling
	id_tag = "oh_b1_server_cooling_shutters"
/obj/machinery/button/blast_door/server_cooling
	name   = "shutters button"
	id_tag = "oh_b1_server_cooling_shutters"

////////////////////////////////////////////////////////////////////////
// Window Door
////////////////////////////////////////////////////////////////////////

/obj/machinery/door/window/reinforced
	name = "secure door"
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "leftsecure"
	base_state = "leftsecure"
	maxhealth = 300
	health = 300.0 //Stronger doors for prison (regular window door health is 150)
	pry_mod = 0.65
	autoclose = FALSE
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
/obj/machinery/door/window/reinforced/right
	icon_state = "rightsecure"
	base_state = "rightsecure"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)


/obj/machinery/door/window/outreach
	autoclose = FALSE
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
/obj/machinery/door/window/right/outreach
	autoclose  = FALSE
	icon_state = "right"
	base_state = "right"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)


/obj/machinery/door/window/reinforced/outreach/cargo
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/cargo,
	)
/obj/machinery/door/window/reinforced/right/outreach/cargo
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/cargo,
	)


/obj/machinery/door/window/reinforced/outreach/security
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/security,
	)
/obj/machinery/door/window/reinforced/right/outreach/security
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/security,
	)
/obj/machinery/door/window/reinforced/outreach/security/warden
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/security/warden,
	)
/obj/machinery/door/window/reinforced/right/outreach/security/warden
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/security/warden,
	)


/obj/machinery/door/window/reinforced/outreach/chemistry
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/research/chemistry,
	)
/obj/machinery/door/window/reinforced/right/outreach/chemistry
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/research/chemistry,
	)


/obj/machinery/door/window/outreach/arrivals
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command,
	)
/obj/machinery/door/window/right/outreach/arrivals
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command,
	)

/obj/machinery/door/window/outreach/botany
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/botany,
	)
/obj/machinery/door/window/right/outreach/botany
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/botany,
	)