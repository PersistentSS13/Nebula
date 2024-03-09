#if !defined(USING_MAP_DATUM)
	#define OUTREACH_SURFACE_TURF         /turf/exterior/barren/outreach
	#define OUTREACH_PLANETOID_ID         "outreach"

	/////////////////////////////////////////////////////////////////////
	// Level IDs
	/////////////////////////////////////////////////////////////////////
	#define OUTREACH_LEVEL_ID_SKY         "outreach_sky"
	#define OUTREACH_LEVEL_ID_SURFACE     "outreach_surface"
	#define OUTREACH_LEVEL_ID_UNDERGROUND "outreach_underground"
	#define OUTREACH_LEVEL_ID_ABYSS       "outreach_abyss"

	#define OUTREACH_LEVEL_ID_SOUTH_ABYSS       "outreach_south_abyss"
	#define OUTREACH_LEVEL_ID_SOUTH_UNDERGROUND "outreach_south_underground"
	#define OUTREACH_LEVEL_ID_SOUTH_MOUNTAIN    "outreach_south_mountain"

	/////////////////////////////////////////////////////////////////////
	// Networking
	/////////////////////////////////////////////////////////////////////

	#define OUTREACH_NETWORK_NAME "outreach_net"

	/////////////////////////////////////////////////////////////////////
	// Netork Groups (Access)
	/////////////////////////////////////////////////////////////////////

	#define OUTREACH_USR_GRP_MAINT    "oh_maintenance"
	#define OUTREACH_USR_GRP_JANITOR  "oh_janitorial"
	#define OUTREACH_USR_GRP_EVA      "oh_eva"
	#define OUTREACH_USR_GRP_EXTERIOR "oh_exterior"
	#define OUTREACH_USR_GRP_KITCHEN  "oh_kitchen"
	#define OUTREACH_USR_GRP_BOTANY   "oh_botany"

	#define OUTREACH_USR_GRP_COMMAND          "oh_command"
	#define OUTREACH_USR_GRP_COMMAND_TCOM     "oh_telecomms"
	#define OUTREACH_USR_GRP_COMMAND_FINANCES "oh_finances"
	#define OUTREACH_USR_GRP_COMMAND_RECORDS  "oh_records"

	#define OUTREACH_USR_GRP_CARGO       "oh_cargo"
	#define OUTREACH_USR_GRP_CARGO_HEAD  "oh_cargo_head"
	#define OUTREACH_USR_GRP_CARGO_REQ   "oh_cargo_requisition"
	#define OUTREACH_USR_GRP_CARGO_VAULT "oh_cargo_vault"

	#define OUTREACH_USR_GRP_MEDICAL         "oh_medical"
	#define OUTREACH_USR_GRP_MEDICAL_HEAD    "oh_medical_head"
	#define OUTREACH_USR_GRP_MEDICAL_STORAGE "oh_medical_storage"
	#define OUTREACH_USR_GRP_MEDICAL_MORGUE  "oh_medical_morgue"

	#define OUTREACH_USR_GRP_SECURITY           "oh_security"
	#define OUTREACH_USR_GRP_SECURITY_HEAD      "oh_security_head"
	#define OUTREACH_USR_GRP_SECURITY_ARMORY    "oh_security_armory"
	#define OUTREACH_USR_GRP_SECURITY_FORENSICS "oh_forensics"
	#define OUTREACH_USR_GRP_SECURITY_BRIG      "oh_brig"
	#define OUTREACH_USR_GRP_SECURITY_WARDEN    "oh_warden"
	#define OUTREACH_USR_GRP_SECURITY_DETECTIVE "oh_detective"

	#define OUTREACH_USR_GRP_MINING            "oh_mining"
	#define OUTREACH_USR_GRP_MINING_HEAD       "oh_mining_head"
	#define OUTREACH_USR_GRP_MINING_PROCESSING "oh_mining_processing"

	#define OUTREACH_USR_GRP_ENGINEERING         "oh_engineering"
	#define OUTREACH_USR_GRP_ENGINEERING_HEAD    "oh_engineering_head"
	#define OUTREACH_USR_GRP_ENGINEERING_STORAGE "oh_engineering_storage"
	#define OUTREACH_USR_GRP_ENGINEERING_ATMOS   "oh_atmos"
	#define OUTREACH_USR_GRP_ENGINEERING_GEN     "oh_generators"

	#define OUTREACH_USR_GRP_RESEARCH      "oh_research"
	#define OUTREACH_USR_GRP_RESEARCH_HEAD "oh_research_head"
	#define OUTREACH_USR_GRP_RESEARCH_DB   "oh_research_database"
	#define OUTREACH_USR_GRP_RESEARCH_CHEM "oh_chemistry"


	////////////////////////////////////////////////////////////////////
	// Mods section
	////////////////////////////////////////////////////////////////////

	#include "../../mods/persistence/_persistence.dme"
	#include "../../mods/species/bayliens/_bayliens.dme"
	#include "../../mods/species/vox/_vox.dme"
	#include "../../mods/species/neoavians/_neoavians.dme"
	#include "../../mods/species/ascent/_ascent.dme"
	#include "../../mods/species/serpentid/_serpentid.dme"
	#include "../../mods/species/utility_frames/_utility_frames.dme"
	#include "../../mods/content/xenobiology/_xenobiology.dme"

	//Away sites
	// #include "../away/casino/casino.dm"
	// #include "../away/derelict/derelict.dm"
	// #include "../away/errant_pisces/errant_pisces.dm"
	// #include "../away/lost_supply_base/lost_supply_base.dm"
	// #include "../away/mining/mining.dm"
	// #include "../away/smugglers/smugglers.dm"
	// #include "../away/slavers/slavers_base.dm"
	// #include "../away/yacht/yacht.dm"
	#include "..\chargen\chargen.dm"

	#include "turfs\outreach_turf_border.dm"
	#include "turfs\outreach_turf_flooded.dm"
	#include "turfs\outreach_turf_magma.dm"
	#include "turfs\outreach_turf_volcanic.dm"

	//Unit tests
	#include "outreach_test.dm"

	//Map stuff
	#include "outreach_atmosphere.dm"
	#include "outreach_turfs.dm"
	#include "outreach_zlevels.dm"
	#include "outreach_overmap.dm"
	#include "outreach_species.dm"
	#include "outreach_areas.dm"
	#include "outreach_events.dm"
	#include "outreach_departments.dm"
	#include "outreach_jobs.dm"
	#include "outreach_exoplanet.dm"
	#include "outreach_elevators.dm"
	#include "outreach_weather.dm"
	#include "outreach_music.dm"

	#include "items/outreach_items.dm"
	#include "items/id_cards.dm"
	#include "items/mounted_shotgun.dm"

	#include "structures/outreach_structures.dm"

	#include "machinery/outreach_network.dm"
	#include "machinery/access_controller.dm"
	#include "machinery/area_controller.dm"
	#include "machinery/network_machines.dm"
	#include "machinery/conveyors.dm"
	#include "machinery/doors.dm"
	#include "machinery/telecomms.dm"
	#include "machinery/computers.dm"
	#include "machinery/outreach_machinery.dm"
	#include "machinery/outreach_turrets.dm"
	#include "machinery/outreach_disposal.dm"

	#define USING_MAP_DATUM /datum/map/outreach
#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Outreach

#endif
