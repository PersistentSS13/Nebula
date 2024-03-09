/datum/map/outreach
	spawn_network = OUTREACH_NETWORK_NAME

////////////////////////////////////////////////////////////////////////
// Network Receiver Presets
////////////////////////////////////////////////////////////////////////

/decl/stock_part_preset/network_receiver
	expected_part_type = /obj/item/stock_parts/network_receiver
	var/network_tag
	var/network_id
	var/network_passkey

/decl/stock_part_preset/network_receiver/do_apply(obj/machinery/machine, obj/item/stock_parts/network_receiver/part)
	var/datum/extension/network_device/dev = get_extension(part, /datum/extension/network_device)
	if(!dev)
		CRASH("No net device initialized")
	dev.disconnect()
	dev.network_id = network_id
	if(length(network_passkey))
		dev.key = network_passkey
	if(length(network_tag))
		dev.set_network_tag(network_tag)
	dev.connect()

/// Receiver Presets

/decl/stock_part_preset/network_receiver/outreach
	network_id = OUTREACH_NETWORK_NAME

////////////////////////////////////////////////////////////////////////
// Network Locks Presets
////////////////////////////////////////////////////////////////////////

/decl/stock_part_preset/network_lock/outreach
	network_id = OUTREACH_NETWORK_NAME

///Access to command
/decl/stock_part_preset/network_lock/outreach/command
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND,
	)
/decl/stock_part_preset/network_lock/outreach/command/tcomm
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND_TCOM,
	)
/decl/stock_part_preset/network_lock/outreach/command/records
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND_TCOM,
		OUTREACH_USR_GRP_COMMAND_RECORDS,
	)
/decl/stock_part_preset/network_lock/outreach/command/finances
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND_FINANCES,
	)

///Access to cargo machinery
/decl/stock_part_preset/network_lock/outreach/cargo
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND,
		OUTREACH_USR_GRP_CARGO,
	)
/decl/stock_part_preset/network_lock/outreach/cargo/head
	allowed_groups = list(
		OUTREACH_USR_GRP_CARGO_HEAD,
		OUTREACH_USR_GRP_CARGO,
	)
/decl/stock_part_preset/network_lock/outreach/cargo/vault
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND,
		OUTREACH_USR_GRP_CARGO_HEAD,
		OUTREACH_USR_GRP_CARGO_VAULT,
	)
/decl/stock_part_preset/network_lock/outreach/cargo/orders
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND,
		OUTREACH_USR_GRP_CARGO_HEAD,
		OUTREACH_USR_GRP_CARGO_REQ,
	)

///Access to security machinery
/decl/stock_part_preset/network_lock/outreach/security
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND,
		OUTREACH_USR_GRP_SECURITY,
	)
/decl/stock_part_preset/network_lock/outreach/security/head
	allowed_groups = list(
		OUTREACH_USR_GRP_SECURITY_HEAD,
	)
/decl/stock_part_preset/network_lock/outreach/security/warden
	allowed_groups = list(
		OUTREACH_USR_GRP_SECURITY_HEAD,
		OUTREACH_USR_GRP_SECURITY_WARDEN,
	)
/decl/stock_part_preset/network_lock/outreach/security/detective
	allowed_groups = list(
		OUTREACH_USR_GRP_SECURITY_HEAD,
		OUTREACH_USR_GRP_SECURITY_WARDEN,
		OUTREACH_USR_GRP_SECURITY_DETECTIVE,
	)
/decl/stock_part_preset/network_lock/outreach/security/forensics
	allowed_groups = list(
		OUTREACH_USR_GRP_SECURITY_HEAD,
		OUTREACH_USR_GRP_SECURITY_WARDEN,
		OUTREACH_USR_GRP_SECURITY_DETECTIVE,
		OUTREACH_USR_GRP_SECURITY_FORENSICS,
		OUTREACH_USR_GRP_MEDICAL_MORGUE,
	)
/decl/stock_part_preset/network_lock/outreach/security/armory
	allowed_groups = list(
		OUTREACH_USR_GRP_SECURITY_HEAD,
		OUTREACH_USR_GRP_SECURITY_ARMORY,
	)
/decl/stock_part_preset/network_lock/outreach/security/brig
	allowed_groups = list(
		OUTREACH_USR_GRP_SECURITY_HEAD,
		OUTREACH_USR_GRP_SECURITY_BRIG,
	)

///Access to mining machinery
/decl/stock_part_preset/network_lock/outreach/mining
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND,
		OUTREACH_USR_GRP_MINING,
	)
/decl/stock_part_preset/network_lock/outreach/mining/head
	allowed_groups = list(
		OUTREACH_USR_GRP_MINING_HEAD,
	)
/decl/stock_part_preset/network_lock/outreach/mining/processing
	allowed_groups = list(
		OUTREACH_USR_GRP_MINING_HEAD,
		OUTREACH_USR_GRP_MINING_PROCESSING,
	)

///Access to medical machinery
/decl/stock_part_preset/network_lock/outreach/medical
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND,
		OUTREACH_USR_GRP_MEDICAL,
		OUTREACH_USR_GRP_SECURITY,
	)
/decl/stock_part_preset/network_lock/outreach/medical/head
	allowed_groups = list(
		OUTREACH_USR_GRP_MEDICAL_HEAD,
	)
/decl/stock_part_preset/network_lock/outreach/medical/morgue
	allowed_groups = list(
		OUTREACH_USR_GRP_MEDICAL_HEAD,
		OUTREACH_USR_GRP_MEDICAL_MORGUE,
		OUTREACH_USR_GRP_SECURITY_FORENSICS,
	)
/decl/stock_part_preset/network_lock/outreach/medical/storage
	allowed_groups = list(
		OUTREACH_USR_GRP_MEDICAL_HEAD,
		OUTREACH_USR_GRP_MEDICAL_STORAGE,
	)

///Access to engineering machinery
/decl/stock_part_preset/network_lock/outreach/engineering
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND,
		OUTREACH_USR_GRP_ENGINEERING,
	)
/decl/stock_part_preset/network_lock/outreach/engineering/head
	allowed_groups = list(
		OUTREACH_USR_GRP_ENGINEERING_HEAD,
	)
/decl/stock_part_preset/network_lock/outreach/engineering/atmos
	allowed_groups = list(
		OUTREACH_USR_GRP_ENGINEERING_HEAD,
		OUTREACH_USR_GRP_ENGINEERING_ATMOS,
	)
/decl/stock_part_preset/network_lock/outreach/engineering/storage
	allowed_groups = list(
		OUTREACH_USR_GRP_ENGINEERING_HEAD,
		OUTREACH_USR_GRP_ENGINEERING_STORAGE,
	)
/decl/stock_part_preset/network_lock/outreach/engineering/power
	allowed_groups = list(
		OUTREACH_USR_GRP_ENGINEERING_HEAD,
		OUTREACH_USR_GRP_ENGINEERING_GEN,
	)

///Access to research machinery
/decl/stock_part_preset/network_lock/outreach/research
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND,
		OUTREACH_USR_GRP_RESEARCH,
	)
/decl/stock_part_preset/network_lock/outreach/research/head
	allowed_groups = list(
		OUTREACH_USR_GRP_RESEARCH_HEAD,
	)
/decl/stock_part_preset/network_lock/outreach/research/db
	allowed_groups = list(
		OUTREACH_USR_GRP_RESEARCH_HEAD,
		OUTREACH_USR_GRP_RESEARCH_DB,
	)
/decl/stock_part_preset/network_lock/outreach/research/chemistry
	allowed_groups = list(
		OUTREACH_USR_GRP_RESEARCH_HEAD,
		OUTREACH_USR_GRP_RESEARCH_CHEM,
	)

///Access to janitorial machinery
/decl/stock_part_preset/network_lock/outreach/janitor
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND,
		OUTREACH_USR_GRP_JANITOR,
	)

///Access to exterior
/decl/stock_part_preset/network_lock/outreach/exterior_airlocks
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND,
		OUTREACH_USR_GRP_EXTERIOR,
		OUTREACH_USR_GRP_ENGINEERING,
		OUTREACH_USR_GRP_MINING,
		OUTREACH_USR_GRP_EVA,
	)

///Access to maintenance
/decl/stock_part_preset/network_lock/outreach/maintenance
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND,
		OUTREACH_USR_GRP_ENGINEERING,
		OUTREACH_USR_GRP_JANITOR,
		OUTREACH_USR_GRP_MAINT,
	)

///Access to eva storage
/decl/stock_part_preset/network_lock/outreach/eva
	allowed_groups = list(
		OUTREACH_USR_GRP_COMMAND,
		OUTREACH_USR_GRP_ENGINEERING,
		OUTREACH_USR_GRP_SECURITY,
		OUTREACH_USR_GRP_MINING,
		OUTREACH_USR_GRP_EVA,
	)

///Access to kitchen
/decl/stock_part_preset/network_lock/outreach/kitchen
	allowed_groups = list(
		OUTREACH_USR_GRP_KITCHEN,
	)

///Access to botany
/decl/stock_part_preset/network_lock/outreach/botany
	allowed_groups = list(
		OUTREACH_USR_GRP_BOTANY,
	)

////////////////////////////////////////////////////////////////////////
// Internet Uplink
////////////////////////////////////////////////////////////////////////
#define OUTREACH_INTERNET_UPLINK_ID "ob_uplink"
/obj/machinery/internet_uplink/outreach
	initial_id_tag     = OUTREACH_INTERNET_UPLINK_ID
	restrict_networks  = TRUE
	permitted_networks = list(
		OUTREACH_NETWORK_NAME
	)
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal,
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup,
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/computer/internet_uplink/outreach
	initial_id_tag     = OUTREACH_INTERNET_UPLINK_ID
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

#undef OUTREACH_INTERNET_UPLINK_ID

////////////////////////////////////////////////////////////////////////
// Networking Systems
////////////////////////////////////////////////////////////////////////

/obj/machinery/network/router/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/network/router/outreach/Initialize(mapload, d, populate_parts)
	if(!length(tag_network_tag))
		tag_network_tag = "oh_router_[global.uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, type, 1)]"
	. = ..()

/obj/machinery/network/modem/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/network/modem/outreach/Initialize(mapload, d, populate_parts)
	if(!length(tag_network_tag))
		tag_network_tag = "oh_modem_[global.uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, type, 1)]"
	. = ..()

/obj/machinery/network/relay/wall_mounted/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
		list(access_engine),
	)

/obj/machinery/network/relay/wall_mounted/outreach/Initialize(mapload, d, populate_parts)
	if(!length(tag_network_tag))
		tag_network_tag = "oh_relay_[global.uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, type, 1)]"
	. = ..()

////////////////////////////////////////////////////////////////////////
// Mainframes
////////////////////////////////////////////////////////////////////////

/obj/machinery/network/mainframe/files/outreach
	name = "network mainframe (files)"
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_files"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/network/mainframe/account/outreach
	name = "network mainframe (user accounts)"
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_accounts"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/network/mainframe/logs/outreach
	name = "network mainframe (logs)"
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_logs"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/network/mainframe/records/outreach
	name = "network mainframe (crew records)"
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_records"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/network/mainframe/software/outreach
	name = "network mainframe (software server)"
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_softwares"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/network/mainframe/empty/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_misc"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

//

/obj/machinery/network/bank/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_bank"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/network/trade_controller/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_trade"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/design_database/outreach
	initial_network_id  = OUTREACH_NETWORK_NAME
	initial_network_tag = "oh_design_db"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/computer/design_console/outreach
	initial_network_id  = OUTREACH_NETWORK_NAME
	initial_network_tag = "oh_design_db"
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
	)
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)
