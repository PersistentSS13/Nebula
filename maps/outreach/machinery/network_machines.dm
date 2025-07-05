
///////////////////////////////////////////////////////////////////////////////////////
// Receiver presets
///////////////////////////////////////////////////////////////////////////////////////

#define OUTREACH_FAX_CARGO       "oh_cargo"
#define OUTREACH_FAX_COMMAND     "oh_command"
#define OUTREACH_FAX_MEDICAL     "oh_medical"
#define OUTREACH_FAX_SECURITY    "oh_security"
#define OUTREACH_FAX_MINING      "oh_mining"
#define OUTREACH_FAX_ENGINEERING "oh_engineering"
#define OUTREACH_FAX_RESEARCH    "oh_research"
#define OUTREACH_FAX_ARRIVAL     "oh_arrival"

/decl/stock_part_preset/network_receiver/outreach/fax/cargo
	network_tag = OUTREACH_FAX_CARGO
/decl/stock_part_preset/network_receiver/outreach/fax/command
	network_tag = OUTREACH_FAX_COMMAND
/decl/stock_part_preset/network_receiver/outreach/fax/medical
	network_tag = OUTREACH_FAX_MEDICAL
/decl/stock_part_preset/network_receiver/outreach/fax/security
	network_tag = OUTREACH_FAX_SECURITY
/decl/stock_part_preset/network_receiver/outreach/fax/mining
	network_tag = OUTREACH_FAX_MINING
/decl/stock_part_preset/network_receiver/outreach/fax/engineering
	network_tag = OUTREACH_FAX_ENGINEERING
/decl/stock_part_preset/network_receiver/outreach/fax/research
	network_tag = OUTREACH_FAX_RESEARCH
/decl/stock_part_preset/network_receiver/outreach/fax/arrival
	network_tag = OUTREACH_FAX_ARRIVAL


///////////////////////////////////////////////////////////////////////////////////////
// Fax Machines
///////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/faxmachine/mapped/outreach
	uncreated_component_parts = list(
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/access_lock,
		/decl/stock_part_preset/network_receiver/outreach,
		/decl/stock_part_preset/network_lock/outreach,
	)

/obj/machinery/faxmachine/mapped/outreach/LateInitialize()
	..()
	//Add all existing quick dial locations on the map
	add_quick_dial_contact("cargo",          "[OUTREACH_FAX_CARGO].[OUTREACH_NETWORK_NAME]")
	add_quick_dial_contact("administration", "[OUTREACH_FAX_COMMAND].[OUTREACH_NETWORK_NAME]")
	add_quick_dial_contact("medical",        "[OUTREACH_FAX_MEDICAL].[OUTREACH_NETWORK_NAME]")
	add_quick_dial_contact("security",       "[OUTREACH_FAX_SECURITY].[OUTREACH_NETWORK_NAME]")
	add_quick_dial_contact("mining",         "[OUTREACH_FAX_MINING].[OUTREACH_NETWORK_NAME]")
	add_quick_dial_contact("engineering",    "[OUTREACH_FAX_ENGINEERING].[OUTREACH_NETWORK_NAME]")
	add_quick_dial_contact("research",       "[OUTREACH_FAX_RESEARCH].[OUTREACH_NETWORK_NAME]")
	add_quick_dial_contact("arrival",        "[OUTREACH_FAX_ARRIVAL].[OUTREACH_NETWORK_NAME]")

/obj/machinery/faxmachine/mapped/outreach/cargo
	stock_part_presets = list(
		/decl/stock_part_preset/access_lock,
		/decl/stock_part_preset/network_receiver/outreach/fax/cargo,
		/decl/stock_part_preset/network_lock/outreach/cargo,
	)
/obj/machinery/faxmachine/mapped/outreach/command
	stock_part_presets = list(
		/decl/stock_part_preset/access_lock,
		/decl/stock_part_preset/network_receiver/outreach/fax/command,
		/decl/stock_part_preset/network_lock/outreach/command,
	)
/obj/machinery/faxmachine/mapped/outreach/medical
	stock_part_presets = list(
		/decl/stock_part_preset/access_lock,
		/decl/stock_part_preset/network_receiver/outreach/fax/medical,
		/decl/stock_part_preset/network_lock/outreach/medical,
	)
/obj/machinery/faxmachine/mapped/outreach/security
	stock_part_presets = list(
		/decl/stock_part_preset/access_lock,
		/decl/stock_part_preset/network_receiver/outreach/fax/security,
		/decl/stock_part_preset/network_lock/outreach/security,
	)
/obj/machinery/faxmachine/mapped/outreach/mining
	stock_part_presets = list(
		/decl/stock_part_preset/access_lock,
		/decl/stock_part_preset/network_receiver/outreach/fax/mining,
		/decl/stock_part_preset/network_lock/outreach/mining,
	)
/obj/machinery/faxmachine/mapped/outreach/engineering
	stock_part_presets = list(
		/decl/stock_part_preset/access_lock,
		/decl/stock_part_preset/network_receiver/outreach/fax/engineering,
		/decl/stock_part_preset/network_lock/outreach/engineering,
	)
/obj/machinery/faxmachine/mapped/outreach/research
	stock_part_presets = list(
		/decl/stock_part_preset/access_lock,
		/decl/stock_part_preset/network_receiver/outreach/fax/research,
		/decl/stock_part_preset/network_lock/outreach/research,
	)
/obj/machinery/faxmachine/mapped/outreach/arrival
	stock_part_presets = list(
		/decl/stock_part_preset/access_lock,
		/decl/stock_part_preset/network_receiver/outreach/fax/arrival,
		/decl/stock_part_preset/network_lock/outreach/command,
	)