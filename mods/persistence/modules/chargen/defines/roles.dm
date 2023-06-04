/decl/hierarchy/chargen/role // WHY was this system so complicated before i got here??
	abstract_type = /decl/hierarchy/chargen/role	// DONT MAKE LIFE SO HARD ON YOURSELF!
	var/text_book_type = /obj/item/book/skill/organizational/literacy/basic	// DESIGN AROUND PLAYERS AND YOURSELF, NOT YOUR INITIAL IDEA

/decl/hierarchy/chargen/role/Initialize()
	. = ..()
	if(!desc)
		desc = "Before I came here, I worked as a \a [name]."

/decl/hierarchy/chargen/role/xenohunter
	ID = "xenohunter"
	name = "Xeno Hunter"
	desc = "You have major skills in combat that make you a perfect choice for hunting the dangerous fauna of the Frontier. You also posess basic skills in piloting and EVA."
	skills = list(
		SKILL_WEAPONS = 2,
		SKILL_COMBAT = 2,
		SKILL_PILOT = 1,
		SKILL_EVA	= 1
	)
	text_book_type = /obj/item/book/manual/xenohunter

/decl/hierarchy/chargen/role/shipmaster
	ID = "shipmaster"
	name = "Ship Master"
	desc = "You are a skilled pilot who is capable of fixing a vessel under fire and that makes you a Ship Master. Your EVA and Piloting is adept, and you maintain basic engineering skills."
	skills = list(
		SKILL_PILOT = 2,
		SKILL_EVA	= 2,
		SKILL_CONSTRUCTION = 1,
		SKILL_ENGINES = 1
	)
	text_book_type = /obj/item/book/manual/shipmaster

/decl/hierarchy/chargen/role/agent
	ID = "agent"
	name = "Special Agent"
	desc = "You have a wide variety of special talents that make you capable of espionage or investigation. Proficent as a detective or spy as needed."
	skills = list(
		SKILL_COMPUTER = 3, // extra better skills because these ones usually req expert and are not as useful for primaries
		SKILL_FORENSICS	= 3,
		SKILL_CHEMISTRY = 1,
		SKILL_WEAPONS = 1,
		SKILL_SCIENCE = 1
	)
	text_book_type = /obj/item/book/manual/agent


/decl/hierarchy/chargen/role/civilengineer
	ID = "civilengineer"
	name = "Civil Engineer"
	desc = "Your talent in construction and electrical engineering make you an ideal Civil Engineer. Build new stations and facilities, and perhaps the organizations that surround them."
	skills = list(
		SKILL_CONSTRUCTION = 2,
		SKILL_ELECTRICAL	= 1,
		SKILL_ENGINES = 1,
		SKILL_ATMOS = 1,
		SKILL_EVA = 1
	)
	text_book_type = /obj/item/book/manual/civilengineer

/decl/hierarchy/chargen/role/inventor
	ID = "inventor"
	name = "Inventor Mechanic"
	desc = "You have a brilliant mind capable of inventing and assembling grand designs; You also have basic skill in how to pilot a ship and work on engines."
	skills = list(
		SKILL_SCIENCE = 2,
		SKILL_DEVICES	= 2,
		SKILL_PILOT = 1,
		SKILL_ENGINES = 1
	)
	text_book_type = /obj/item/book/manual/inventor

/decl/hierarchy/chargen/role/chemist
	ID = "chemist"
	name = "Chemical Genius"
	desc = "You have a rare aptitude for chemistry and medicine which makes you a valuable commidity in the Frontier. You also have basic botanical and research ability."
	skills = list(
		SKILL_CHEMISTRY = 2,
		SKILL_MEDICINE = 2,
		SKILL_SCIENCE	= 1,
		SKILL_BOTANY = 1
	)
	text_book_type = /obj/item/book/manual/chemist

/decl/hierarchy/chargen/role/doctor
	ID = "doctor"
	name = "Frontier Surgeon"
	desc = "You have a capable hand at surgery and medicine plus basic experience in Chemistry and EVA operation. As a Frontier Surgeon you will fight to keep your patients alive and clone those who cant be saved."
	skills = list(
		SKILL_ANATOMY = 2,
		SKILL_MEDICINE = 2,
		SKILL_CHEMISTRY	= 1,
		SKILL_EVA = 1
	)
	text_book_type = /obj/item/book/manual/doctor

/decl/hierarchy/chargen/role/diplomat
	ID = "diplomat"
	name = "Master Diplomat"
	desc = "You are a skilled pilot with a variety of service skills that sharpen your talent as a diplomat. Negotiate for others or yourself in the unclaimed frontier."
	skills = list(
		SKILL_PILOT = 2,
		SKILL_COOKING = 1,
		SKILL_BOTANY = 1,
		SKILL_SCIENCE = 1,
		SKILL_EVA = 1
	)
	text_book_type = /obj/item/book/manual/diplomat

/decl/hierarchy/chargen/role/farmingchef
	ID = "farmingchef"
	name = "Farming Chef"
	desc = "Your skill in both botany and cooking gives you potential as a farming chef. Feed the hungry masses and your hungry pockets."
	skills = list(
		SKILL_COOKING = 2,
		SKILL_BOTANY = 2,
		SKILL_CHEMISTRY = 1,
		SKILL_HAULING = 1
	)
	text_book_type = /obj/item/book/manual/farmingchef

/decl/hierarchy/chargen/role/brawler
	ID = "brawler"
	name = "Brawler"
	desc = "You have a talent for close quarters combat that makes you a fierce competitor in any martial arts match, perhaps even a champion. If you can't quite find work doing that, you could always sign aboard a mining crew."
	skills = list(
		SKILL_COMBAT = 3,
		SKILL_HAULING = 1,
		SKILL_WEAPONS = 1
	)
	text_book_type = /obj/item/book/manual/brawler

/decl/hierarchy/chargen/role/soldier
	ID = "soldier"
	name = "Soldier of Fortune"
	desc = "Perfectly trained for combat of any kind, you are a necessary force multiplier in the unclaimed frontier. Claim power and glory for your nation or at least yourself."
	skills = list(
		SKILL_COMBAT = 2,
		SKILL_WEAPONS = 2,
		SKILL_EVA = 1,
		SKILL_HAULING = 1
	)
	text_book_type = /obj/item/book/manual/soldier

/*
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

/decl/hierarchy/chargen/role/surgeon
	ID = "surgeon"
	name = "Surgeon"
	skills = list(
		SKILL_ANATOMY = 3,
		SKILL_MEDICAL = 1
	)
	remaining_points_offset = -17

	text_book_type = /obj/item/book/skill/medical/anatomy/prof

/decl/hierarchy/chargen/role/chemist
	ID = "chemist"
	name = "Chemist"
	skills = list(
		SKILL_CHEMISTRY = 2
	)
	remaining_points_offset = 0

	text_book_type = /obj/item/book/skill/medical/chemistry/expert

/decl/hierarchy/chargen/role/emt
	ID = "emt"
	name = "EMT"
	skills = list(
		SKILL_MEDICAL = 1,
		SKILL_HAULING = 1
	)
	remaining_points_offset = 0
	text_book_type = /obj/item/book/skill/medical/medicine/expert

*/