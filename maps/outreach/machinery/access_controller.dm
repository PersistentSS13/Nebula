////////////////////////////////////////////////////////////////////////
// Access Controller
////////////////////////////////////////////////////////////////////////

/obj/machinery/network/acl/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_acl"
	preset_groups      = list(
		OUTREACH_USR_GRP_COMMAND = list(
			OUTREACH_USR_GRP_COMMAND_TCOM = list(
				global.access_ai_upload,
				global.access_network,
				global.access_tcomsat,
			),
			OUTREACH_USR_GRP_COMMAND_FINANCES = list(
				global.access_heads_vault,
			),
			OUTREACH_USR_GRP_COMMAND_RECORDS = list(
				global.access_hop,
				global.access_heads,
				global.access_change_ids,
			),
			global.access_bridge,
		),
		OUTREACH_USR_GRP_CARGO = list(
			OUTREACH_USR_GRP_CARGO_HEAD = list(
				global.access_qm,
			),
			OUTREACH_USR_GRP_CARGO_REQ = list(
				global.access_crate_cash,
			),
			OUTREACH_USR_GRP_CARGO_VAULT,
			global.access_cargo,
			global.access_cargo_bot,
		),
		OUTREACH_USR_GRP_MEDICAL = list(
			OUTREACH_USR_GRP_MEDICAL_HEAD = list(
				global.access_cmo,
			),
			OUTREACH_USR_GRP_MEDICAL_STORAGE = list(
				global.access_medical_equip,
			),
			OUTREACH_USR_GRP_MEDICAL_MORGUE = list(
				global.access_morgue,
				global.access_crematorium,
			),
			global.access_medical,
		),
		OUTREACH_USR_GRP_SECURITY = list(
			OUTREACH_USR_GRP_SECURITY_HEAD = list(
				global.access_hos,
			),
			OUTREACH_USR_GRP_SECURITY_ARMORY = list(
				global.access_armory,
			),
			OUTREACH_USR_GRP_SECURITY_FORENSICS = list(
				global.access_forensics_lockers,
			),
			OUTREACH_USR_GRP_SECURITY_BRIG = list(
				global.access_brig,
			),
			global.access_sec_doors,
			global.access_security,
		),
		OUTREACH_USR_GRP_MINING = list(
			OUTREACH_USR_GRP_MINING_HEAD = list(
				global.access_mining_office,
			),
			OUTREACH_USR_GRP_MINING_PROCESSING = list(
				global.access_manufacturing,
			),
			global.access_mining,
		),
		OUTREACH_USR_GRP_ENGINEERING = list(
			OUTREACH_USR_GRP_ENGINEERING_HEAD = list(
				global.access_ce, //Work-around to get access ce as engineering head. The access group system isn't very flexible
			),
			OUTREACH_USR_GRP_ENGINEERING_STORAGE = list(
				global.access_tech_storage,
				global.access_engine_equip,
				global.access_construction,
			),
			OUTREACH_USR_GRP_ENGINEERING_ATMOS = list(
				global.access_atmospherics,
			),
			OUTREACH_USR_GRP_ENGINEERING_GEN = list(
				global.access_engine,
			),
		),
		OUTREACH_USR_GRP_RESEARCH = list(
			OUTREACH_USR_GRP_RESEARCH_HEAD = list(
				global.access_rd,
			),
			OUTREACH_USR_GRP_RESEARCH_CHEM = list(
				global.access_chemistry,
			),
			OUTREACH_USR_GRP_RESEARCH_DB,
			global.access_research,
		),
		OUTREACH_USR_GRP_EXTERIOR = list(
			OUTREACH_USR_GRP_EVA = list(
				global.access_eva,
			),
			global.access_external_airlocks,
		),
		OUTREACH_USR_GRP_MAINT = list(
			global.access_maint_tunnels,
		),
		OUTREACH_USR_GRP_JANITOR = list(
			global.access_janitor,
		),
	)
	req_access = list(
		list(access_ce),
		list(access_bridge),
	)
