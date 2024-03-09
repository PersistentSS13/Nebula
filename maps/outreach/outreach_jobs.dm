/datum/map/outreach
	default_job_type = /datum/job/colonist
	allowed_jobs     = list(/datum/job/colonist)

///////////////////////////////////////////////////////////////////
// Spawn Jobs
///////////////////////////////////////////////////////////////////

/**
	The default starter job for the outreach colony.
 */
/datum/job/colonist
	title             = "Colonist"
	department_types  = list(/decl/department/civilian)
	outfit_type       = /decl/hierarchy/outfit/job/outreach
	hud_icon          = "hudcolonist"
	total_positions   = -1 //Infinite slots
	skill_points      = 30 //They spawn with 30
	announced         = FALSE
	forced_spawnpoint = /decl/spawnpoint/chargen //Makes colonists spawn in the chargen rooms
	minimal_access    = list(
		access_eva,
		access_external_airlocks
	)

///////////////////////////////////////////////////////////////////
// Post-Spawn Jobs
///////////////////////////////////////////////////////////////////
// A bunch of typical jobs with typical access, icons, and coloring so changing someone's job to one of these actually
// applies the job icon and etc..

/datum/job/councilor
	title            = "Councilor"
	alt_titles       = list("Administrator", "Bureaucrat")
	hud_icon         = "hudinternalaffairsagent"
	head_position    = 1
	department_types = list(/decl/department/command)
	total_positions  = -1
	selection_color  = "#1d1d4f"
	req_admin_notify = 1
	minimal_access   = list(
		access_bridge,
		access_captain,
		access_heads,
		access_heads_vault,
		access_hop,
		access_security,
		access_sec_doors,
		access_change_ids,
		access_network,
		access_keycard_auth,
	)

/datum/job/merchant
	title            = "Merchant"
	alt_titles       = list("Salesman", "Wholesaler")
	hud_icon         = "hudmerchant"
	supervisors      = "money"
	department_types = list(/decl/department/civilian)
	total_positions  = -1

/datum/job/chaplain
	title            = "Chaplain"
	alt_titles       = list("Priest", "Preacher")
	hud_icon         = "hudchaplain"
	department_types = list(/decl/department/civilian)
	total_positions  = -1
	minimal_access   = list(access_chapel_office, access_morgue)

/datum/job/librarian
	title            = "Librarian"
	alt_titles       = list("Journalist", "Curator")
	hud_icon         = "hudlibrarian"
	department_types = list(/decl/department/civilian)
	total_positions  = -1
	minimal_access   = list(access_library)

/datum/job/librarian
	title            = "Clown"
	alt_titles       = list("Entertainer", "Comedian")
	hud_icon         = "hudclown"
	department_types = list(/decl/department/civilian)
	total_positions  = -1
	minimal_access   = list(access_psychiatrist)

/datum/job/bartender
	title            = "Bartender"
	alt_titles       = list("Barista")
	hud_icon         = "hudbartender"
	department_types = list(/decl/department/service)
	total_positions  = -1 //Infinite slots
	minimal_access   = list(access_bar)

/datum/job/chef
	title            = "Chef"
	alt_titles       = list("Cook")
	hud_icon         = "hudchef"
	department_types = list(/decl/department/service)
	total_positions  = -1
	minimal_access   = list(access_kitchen)

/datum/job/hydro
	title            = "Gardener"
	alt_titles       = list("Hydroponicist", "Botanist")
	hud_icon         = "hudgardener"
	department_types = list(/decl/department/service)
	event_categories = list(ASSIGNMENT_GARDENER)
	total_positions  = -1
	minimal_access   = list(access_hydroponics)

/datum/job/janitor
	title            = "Janitor"
	alt_titles       = list("Custodian","Sanitation Technician")
	hud_icon         = "hudjanitor"
	department_types = list(/decl/department/service)
	total_positions  = -1
	event_categories = list(ASSIGNMENT_JANITOR)
	minimal_access   = list(access_janitor)

/datum/job/qm
	title            = "Quartermaster"
	hud_icon         = "hudquartermaster"
	department_types = list(/decl/department/supply)
	total_positions  = -1
	minimal_access   = list(
		access_qm,
		access_cargo,
		access_mailsorting,
		access_crate_cash,
		access_manufacturing,
		access_cargo_bot,
		access_mining_office,
		access_mining_station,
		access_change_ids,
		access_eva,
		access_external_airlocks,
	)

/datum/job/cargo_tech
	title            = "Cargo Technician"
	hud_icon         = "hudcargotechnician"
	department_types = list(/decl/department/supply)
	total_positions  = -1
	minimal_access   = list(
		access_cargo,
		access_mailsorting,
		access_crate_cash,
		access_manufacturing,
		access_cargo_bot,
	)

/datum/job/mining
	title            = "Shaft Miner"
	alt_titles       = list("Drill Technician", "Prospector")
	hud_icon         = "hudshaftminer"
	department_types = list(/decl/department/supply)
	total_positions  = -1
	minimal_access   = list(
		access_mining,
		access_mining_station,
		access_manufacturing,
		access_eva,
		access_external_airlocks
	)

/datum/job/lawyer
	title            = "Internal Affairs Agent"
	hud_icon         = "hudlawyer"
	supervisors      = "the galactic law"
	department_types = list(/decl/department/support)
	total_positions  = -1
	minimal_access   = list(access_lawyer)

/datum/job/chief_engineer
	title            = "Chief Engineer"
	hud_icon         = "hudchiefengineer"
	head_position    = TRUE
	department_types = list(/decl/department/engineering, /decl/department/command)
	total_positions  = 1
	selection_color  = "#7f6e2c"
	req_admin_notify = 1
	event_categories = list(ASSIGNMENT_ENGINEER)
	minimal_access   = list(
		access_ce,
		access_atmospherics,
		access_construction,
		access_engine,
		access_engine_equip,
		access_change_ids,
		access_eva,
		access_external_airlocks,
	)

/datum/job/engineer
	title      = "Engineer"
	hud_icon   = "hudengineer"
	alt_titles = list(
		"Maintenance Technician",
		"Electrician",
		"Mechanic",
		"Atmospheric Technician",
	)
	department_types  = list(/decl/department/engineering)
	total_positions   = -1
	supervisors       = "the chief engineer"
	selection_color   = "#5b4d20"
	event_categories  = list(ASSIGNMENT_ENGINEER)
	minimal_access   = list(
		access_engine,
		access_engine_equip,
		access_construction,
		access_atmospherics,
		access_eva,
		access_external_airlocks,
	)

/datum/job/cmo
	title            = "Chief Medical Officer"
	alt_titles       = list("Head Doctor")
	hud_icon         = "hudchiefmedicalofficer"
	head_position    = TRUE
	department_types = list(
		/decl/department/medical,
		/decl/department/command
	)
	total_positions  = 1
	selection_color  = "#026865"
	req_admin_notify = 1
	event_categories = list(ASSIGNMENT_MEDICAL)
	minimal_access   = list(
		access_cmo,
		access_medical,
		access_medical_equip,
		access_morgue,
		access_change_ids,
	)

/datum/job/doctor
	title      = "Medical Doctor"
	hud_icon   = "hudmedicaldoctor"
	alt_titles = list(
		"Paramedic",
		"Surgeon",
		"Physician",
		"Nurse",
	)
	department_types = list(/decl/department/medical)
	total_positions  = -1
	supervisors      = "the chief medical officer"
	selection_color  = "#013d3b"
	event_categories = list(ASSIGNMENT_MEDICAL)
	minimal_access   = list(
		access_medical,
		access_medical_equip,
		access_morgue,
	)

/datum/job/chemist
	title            = "Pharmacist"
	hud_icon         = "hudpharmacist"
	department_types = list(/decl/department/medical)
	total_positions  = -1
	supervisors      = "the chief medical officer"
	selection_color  = "#013d3b"
	minimal_access   = list(
		access_chemistry,
		access_medical_equip,
	)

/datum/job/counselor
	title            = "Counselor"
	hud_icon         = "hudcounselor"
	alt_titles       = list("Mentalist")
	department_types = list(/decl/department/medical)
	total_positions  = -1
	supervisors      = "the chief medical officer"
	selection_color  = "#013d3b"
	minimal_access   = list(
		access_medical,
	)

/datum/job/hos
	title            = "Head of Security"
	alt_titles       = list("Sheriff", "Security Chief")
	hud_icon         = "hudheadofsecurity"
	head_position    = TRUE
	department_types = list(/decl/department/security, /decl/department/command)
	total_positions  = 1
	supervisors      = "the law"
	selection_color  = "#8e2929"
	req_admin_notify = 1
	event_categories = list(ASSIGNMENT_SECURITY)
	minimal_access   = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_armory,
		access_heads,
		access_forensics_lockers,
		access_morgue,
		access_maint_tunnels,
		access_all_personal_lockers,
		access_research,
		access_engine,
		access_mining,
		access_medical,
		access_construction,
		access_mailsorting,
		access_bridge,
		access_hos,
		access_RC_announce,
		access_keycard_auth,
		access_gateway,
		access_external_airlocks
	)

/datum/job/warden
	title            = "Warden"
	alt_titles       = list("Deputy", "Sergent")
	hud_icon         = "hudwarden"
	department_types = list(/decl/department/security)
	total_positions  = -1
	supervisors      = "the head of security"
	selection_color  = "#601c1c"
	minimal_access   = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_armory,
		access_maint_tunnels,
		access_external_airlocks
	)

/datum/job/detective
	title            = "Detective"
	alt_titles       = list("Forensic Technician", "Investigator")
	hud_icon         = "huddetective"
	department_types = list(/decl/department/security)
	total_positions  = -1
	supervisors      = "the head of security"
	selection_color  = "#601c1c"
	minimal_access = list(
		access_security,
		access_sec_doors,
		access_forensics_lockers,
		access_morgue,
		access_maint_tunnels
	)

/datum/job/officer
	title            = "Security Officer"
	alt_titles       = list("Junior Officer", "Security Guard", "Watchman")
	hud_icon         = "hudsecurityofficer"
	department_types = list(/decl/department/security)
	total_positions  = -1
	supervisors      = "the head of security"
	selection_color  = "#601c1c"
	event_categories = list(ASSIGNMENT_SECURITY)
	minimal_access   = list(
		access_security,
		access_eva,
		access_sec_doors,
		access_brig,
		access_maint_tunnels,
		access_external_airlocks
	)

/datum/job/roboticist
	title            = "Roboticist"
	alt_titles       = list("Biomechanical Engineer","Mechatronic Engineer")
	hud_icon         = "hudroboticist"
	department_types = list(/decl/department/science)
	minimal_access   = list(
		access_robotics,
		access_tech_storage,
		access_morgue,
		access_research
	)
	total_positions  = -1

/datum/job/scientist
	title            = "Scientist"
	alt_titles       = list("Researcher", "Geologist", "Physicist")
	hud_icon         = "hudscientist"
	department_types = list(/decl/department/science)
	minimal_access   = list(
		access_tox,
		access_tox_storage,
		access_research,
		access_xenoarch,
		access_xenobiology,
		access_hydroponics
	)
	total_positions  = -1

///////////////////////////////////////////////////////////////////
// Outfit
///////////////////////////////////////////////////////////////////

/**
	The basic outfit all players spawn with on outreach.
 */
/decl/hierarchy/outfit/job/outreach
	name     = "Job - Outreach Colonist"
	id_type  = /obj/item/card/id/network/civilian
	uniform  = /obj/item/clothing/under/color/lightblue
	l_ear    = /obj/item/radio/headset
	shoes    = /obj/item/clothing/shoes/color/white
	pda_type = null
	r_ear    = null
	flags    = OUTFIT_HAS_BACKPACK
