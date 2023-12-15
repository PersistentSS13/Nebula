#define ADMIN_PROTECTED_NET_GROUP "custodians"

/datum/map/outreach
	spawn_network = OUTREACH_NETWORK_NAME

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
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/computer/internet_uplink/outreach
	initial_id_tag     = OUTREACH_INTERNET_UPLINK_ID
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

#undef OUTREACH_INTERNET_UPLINK_ID

////////////////////////////////////////////////////////////////////////
// Area Controller
////////////////////////////////////////////////////////////////////////

/obj/machinery/network/area_controller/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_actrl"
	use_power          = POWER_USE_ACTIVE
	maximum_component_parts = list(
		/obj/item/stock_parts = 200,
	)
	uncreated_component_parts = list(
		/obj/item/stock_parts/smes_coil = 7,
	)
	req_access = list(
		list(access_ce),
		list(access_bridge),
	)

/obj/machinery/network/area_controller/outreach/Initialize(mapload, d, populate_parts)
	. = ..()
	for(var/area/A in world)
		if(A.name in global.outreach_initial_protected_areas)
			add_protected_area(A)
	update_use_power(POWER_USE_ACTIVE)

/obj/machinery/network/area_controller/outreach/proc/add_protected_area(var/area/A)
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	add_area(A)
	owned_areas[A] |= "[ADMIN_PROTECTED_NET_GROUP].[D.network_id]"
	update_protected_count()
	recalculate_power()

////////////////////////////////////////////////////////////////////////
// Access Controller
////////////////////////////////////////////////////////////////////////

/obj/machinery/network/acl/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_acl"
	preset_groups      = list(
		ADMIN_PROTECTED_NET_GROUP = list(
		)
	)
	req_access = list(
		list(access_ce),
		list(access_bridge),
	)

////////////////////////////////////////////////////////////////////////
// Networking Systems
////////////////////////////////////////////////////////////////////////

/obj/machinery/network/router/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
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
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_files"
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/network/mainframe/account/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_accounts"
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/network/mainframe/logs/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_logs"
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/network/mainframe/records/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_records"
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

/obj/machinery/network/mainframe/software/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_mfrm_softwares"
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)

////////////////////////////////////////////////////////////////////////
// Telecomms
////////////////////////////////////////////////////////////////////////

/obj/machinery/network/telecomms_hub/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_hub"
	req_access         = list(
		list(access_ce),
		list(access_tcomsat),
	)
	channels           = list(
		COMMON_FREQUENCY_DATA,
		list("name" = "Science",       "key" = "n", "frequency" = 1351, "color" = COMMS_COLOR_SCIENCE,   "span_class" = "sciradio", "secured" = list(access_research)),
		list("name" = "Medical",       "key" = "m", "frequency" = 1355, "color" = COMMS_COLOR_MEDICAL,   "span_class" = "medradio", "secured" = list(access_medical)),
		list("name" = "Supply",        "key" = "u", "frequency" = 1347, "color" = COMMS_COLOR_SUPPLY,    "span_class" = "supradio", "secured" = list(access_cargo)),
		list("name" = "Service",       "key" = "v", "frequency" = 1349, "color" = COMMS_COLOR_SERVICE,   "span_class" = "srvradio", "secured" = list(access_bar)),
		list("name" = "AI Private",    "key" = "p", "frequency" = 1343, "color" = COMMS_COLOR_AI,        "span_class" = "airadio",  "secured" = list(access_ai_upload)),
		list("name" = "Entertainment", "key" = "z", "frequency" = 1461, "color" = COMMS_COLOR_ENTERTAIN, "span_class" = CSS_CLASS_RADIO, "receive_only" = TRUE),
		list("name" = "Command",       "key" = "c", "frequency" = 1353, "color" = COMMS_COLOR_COMMAND,   "span_class" = "comradio", "secured" = list(access_bridge)),
		list("name" = "Engineering",   "key" = "e", "frequency" = 1357, "color" = COMMS_COLOR_ENGINEER,  "span_class" = "engradio", "secured" = list(access_engine)),
		list("name" = "Security",      "key" = "s", "frequency" = 1359, "color" = COMMS_COLOR_SECURITY,  "span_class" = "secradio", "secured" = list(access_security)),
	)

#undef ADMIN_PROTECTED_NET_GROUP