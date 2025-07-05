////////////////////////////////////////////////////////////////////////
// Access Controller
////////////////////////////////////////////////////////////////////////

/obj/machinery/network/acl/outreach
	initial_network_id = OUTREACH_NETWORK_NAME
	tag_network_tag    = "oh_acl"
	preset_groups      = list(
		OUTREACH_USR_GRP_COMMAND = list(
			OUTREACH_USR_GRP_COMMAND_TCOM = list(
				access_ai_upload,
				access_network,
				access_tcomsat,
			),
			OUTREACH_USR_GRP_COMMAND_FINANCES = list(
				access_heads_vault,
			),
			OUTREACH_USR_GRP_COMMAND_RECORDS = list(
				access_hop,
				access_heads,
				access_change_ids,
			),
			access_bridge,
		),
		OUTREACH_USR_GRP_CARGO = list(
			OUTREACH_USR_GRP_CARGO_HEAD = list(
				access_qm,
			),
			OUTREACH_USR_GRP_CARGO_REQ = list(
				access_crate_cash,
			),
			OUTREACH_USR_GRP_CARGO_VAULT,
			access_cargo,
			access_cargo_bot,
		),
		OUTREACH_USR_GRP_MEDICAL = list(
			OUTREACH_USR_GRP_MEDICAL_HEAD = list(
				access_cmo,
			),
			OUTREACH_USR_GRP_MEDICAL_STORAGE = list(
				access_medical_equip,
			),
			OUTREACH_USR_GRP_MEDICAL_MORGUE = list(
				access_morgue,
				access_crematorium,
			),
			access_medical,
		),
		OUTREACH_USR_GRP_SECURITY = list(
			OUTREACH_USR_GRP_SECURITY_HEAD = list(
				access_hos,
			),
			OUTREACH_USR_GRP_SECURITY_ARMORY = list(
				access_armory,
			),
			OUTREACH_USR_GRP_SECURITY_FORENSICS = list(
				access_forensics_lockers,
			),
			OUTREACH_USR_GRP_SECURITY_BRIG = list(
				access_brig,
			),
			access_sec_doors,
			access_security,
		),
		OUTREACH_USR_GRP_MINING = list(
			OUTREACH_USR_GRP_MINING_HEAD = list(
				access_mining_office,
			),
			OUTREACH_USR_GRP_MINING_PROCESSING = list(
				access_manufacturing,
			),
			access_mining,
		),
		OUTREACH_USR_GRP_ENGINEERING = list(
			OUTREACH_USR_GRP_ENGINEERING_HEAD = list(
				access_ce, //Work-around to get access ce as engineering head. The access group system isn't very flexible
			),
			OUTREACH_USR_GRP_ENGINEERING_STORAGE = list(
				access_tech_storage,
				access_engine_equip,
				access_construction,
			),
			OUTREACH_USR_GRP_ENGINEERING_ATMOS = list(
				access_atmospherics,
			),
			OUTREACH_USR_GRP_ENGINEERING_GEN = list(
				access_engine,
			),
		),
		OUTREACH_USR_GRP_RESEARCH = list(
			OUTREACH_USR_GRP_RESEARCH_HEAD = list(
				access_rd,
			),
			OUTREACH_USR_GRP_RESEARCH_CHEM = list(
				access_chemistry,
			),
			OUTREACH_USR_GRP_RESEARCH_DB,
			access_research,
		),
		OUTREACH_USR_GRP_EXTERIOR = list(
			OUTREACH_USR_GRP_EVA = list(
				access_eva,
			),
			access_external_airlocks,
		),
		OUTREACH_USR_GRP_MAINT = list(
			access_maint_tunnels,
		),
		OUTREACH_USR_GRP_JANITOR = list(
			access_janitor,
		),
	)
	req_access = list(
		list(access_ce),
		list(access_bridge),
	)
