/decl/hierarchy/chargen/role
	abstract_type = /decl/hierarchy/chargen/role
	var/text_book_type = /obj/item/book/skill/organizational/literacy/basic

/decl/hierarchy/chargen/role/Initialize()
	. = ..()
	if(!desc)
		desc = "Before I came here, I worked as a \a [name]."

/decl/hierarchy/chargen/role/drifter
	ID = "drifter"
	name = "Drifter"
	skills = list(
		SKILL_PILOT = 1,
		SKILL_EVA	= 1
	)
	remaining_points_offset = 0

	text_book_type = /obj/item/book/skill/general/eva/expert

/decl/hierarchy/chargen/role/engine_mechanic
	ID = "engine_mechanic"
	name = "Engine Mechanic"
	skills = list(
		SKILL_ENGINES = 1,
		SKILL_LITERACY = 1
	)
	remaining_points_offset = 0

	text_book_type = /obj/item/book/skill/engineering/engines/expert

/decl/hierarchy/chargen/role/electrical_engineer
	ID = "electrical_engineer"
	name = "Electrical Engineer"
	skills = list(
		SKILL_ELECTRICAL = 1,
		SKILL_LITERACY = 1
	)
	remaining_points_offset = 0

	text_book_type = /obj/item/book/skill/engineering/electrical/expert

/decl/hierarchy/chargen/role/programmer
	ID = "programmer"
	name = "Programmer"
	skills = list(
		SKILL_COMPUTER = 1,
		SKILL_LITERACY = 1
	)
	remaining_points_offset = 0

	text_book_type = /obj/item/book/skill/general/computer/expert

/decl/hierarchy/chargen/role/farmer
	ID = "farmer"
	name = "Farmer/Botanist"
	skills = list(
		SKILL_BOTANY = 1,
		SKILL_HAULING = 1
	)
	remaining_points_offset = 0

	text_book_type = /obj/item/book/skill/service/botany/expert

/decl/hierarchy/chargen/role/doctor
	ID = "doctor"
	name = "Doctor"
	skills = list(
		SKILL_MEDICAL = 1,
		SKILL_LITERACY = 1
	)
	remaining_points_offset = 0

	text_book_type = /obj/item/book/skill/medical/medicine/expert

/decl/hierarchy/chargen/role/pilot
	ID = "pilot"
	name = "Pilot"
	skills = list(
		SKILL_PILOT = 1,
		SKILL_LITERACY = 1
	)
	remaining_points_offset = 0
	
	text_book_type = /obj/item/book/skill/general/pilot/expert

/decl/hierarchy/chargen/role/prisoner
	ID = "prisoner"
	name = "Prisoner"
	skills = list(
		SKILL_COMBAT = 1,
		SKILL_LITERACY = 1
	)
	remaining_points_offset = 2
	
	text_book_type = /obj/item/book/skill/security/combat/expert

/decl/hierarchy/chargen/role/scientist
	ID = "scientist"
	name = "Scientist"
	skills = list(
		SKILL_SCIENCE = 1,
		SKILL_LITERACY = 1
	)
	remaining_points_offset = 0

	text_book_type = /obj/item/book/skill/research/science/expert
/*
/decl/hierarchy/chargen/role/judge
	ID = "judge"
	name = "Judge"
	whitelist_only = TRUE
	skills = list(
		SKILL_FORENSICS = 1
	)

	text_book_type = /obj/item/book/skill/security/forensics/prof

/decl/hierarchy/chargen/role/gov_maint
	ID = "gov_maint"
	name = "Outreach Government Contractor"
	whitelist_only = TRUE
	skills = list(
		SKILL_CONSTRUCTION = 2,
		SKILL_LITERACY = 1
	)

	text_book_type = /obj/item/book/skill/engineering/construction/expert
*/
/decl/hierarchy/chargen/role/wage_slave
	ID = "wage_slave"
	name = "Wage Slave"
	skills = list(
		SKILL_FINANCE = 1,
		SKILL_LITERACY = 1
	)
	remaining_points_offset = 0

	text_book_type = /obj/item/book/skill/organizational/finance/expert

/decl/hierarchy/chargen/role/soldier
	ID = "soldier"
	name = "Soldier"
	skills = list(
		SKILL_WEAPONS = 1,
		SKILL_COMBAT = 1
	)
	remaining_points_offset = 4

	text_book_type = /obj/item/book/skill/security/weapons/expert

/decl/hierarchy/chargen/role/miner
	ID = "miner"
	name = "Miner"
	skills = list(
		SKILL_HAULING = 1,
		SKILL_CONSTRUCTION = 1
	)
	remaining_points_offset = 0

	text_book_type = /obj/item/book/skill/engineering/construction/adept

/decl/hierarchy/chargen/role/detective
	ID = "detective"
	name = "Detective"
	skills = list(
		SKILL_FORENSICS = 1,
		SKILL_LITERACY = 1
	)
	remaining_points_offset = 0

	text_book_type = /obj/item/book/skill/security/forensics/expert

/decl/hierarchy/chargen/role/inventor
	ID = "inventor"
	name = "Inventor"
	skills = list(
		SKILL_DEVICES = 1,
		SKILL_LITERACY = 1
	)
	remaining_points_offset = 0

	text_book_type = /obj/item/book/skill/research/devices/expert

/decl/hierarchy/chargen/role/shipbreaker
	ID = "shipbreaker"
	name = "Shipbreaker"
	skills = list(
		SKILL_CONSTRUCTION = 1,
		SKILL_ELECTRICAL = 1
	)
	remaining_points_offset = 0

	text_book_type = /obj/item/book/skill/engineering/electrical/expert

/decl/hierarchy/chargen/role/educator
	ID = "educator"
	name = "Educator"
	skills = list(
		SKILL_LITERACY = 2
	)
	remaining_points_offset = 4

	text_book_type = /obj/item/book/skill/organizational/literacy/prof
