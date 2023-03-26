#if !defined(USING_MAP_DATUM)
#define OUTREACH_SURFACE_TURF /turf/exterior/barren/outreach

	// Mods section
	#include "../../mods/persistence/_persistence.dme"
	#include "../../mods/species/bayliens/_bayliens.dme"
	#include "../../mods/species/vox/_vox.dme"
	#include "../../mods/content/xenobiology/_xenobiology.dme"
	#include "../../mods/species/ascent/_ascent.dme"

	//Map extensions
	#include "../chargen/chargen_areas.dm"
	#include "../chargen/chargen_objects.dm"

	//Away sites
	// #include "../away/casino/casino.dm"
	// #include "../away/derelict/derelict.dm"
	// #include "../away/errant_pisces/errant_pisces.dm"
	// #include "../away/lost_supply_base/lost_supply_base.dm"
	// #include "../away/mining/mining.dm"
	// #include "../away/smugglers/smugglers.dm"
	// #include "../away/slavers/slavers_base.dm"
	// #include "../away/yacht/yacht.dm"

	#include "turfs\outreach_turf_border.dm"
	#include "turfs\outreach_turf_flooded.dm"
	#include "turfs\outreach_turf_magma.dm"
	#include "turfs\outreach_turf_transition.dm"
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
	#include "outreach_network.dm"
	#include "outreach_elevators.dm"
	#include "outreach_machinery.dm"
	#include "outreach_weather.dm"
	#include "outreach_structures.dm"
	#include "outreach_music.dm"

	#define USING_MAP_DATUM /datum/map/outreach
#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Outreach

#endif
