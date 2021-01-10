#if !defined(USING_MAP_DATUM)
	#define DISABLE_DEBUG_CRASH
	
	// Mods section
	#include "../../mods/persistence/_persistence.dme"
	#include "../../mods/ascent/_ascent.dme"

	// Lobby section
	#include "../../code/datums/music_tracks/dirtyoldfrogg.dm"

	// Map defines.
	#include "persistence_defines.dm"
	#include "chargen/chargen_areas.dm"

	#include "outreach_access.dm"
	#include "outreach_areas.dm"
	#include "outreach_jobs.dm"
	#include "outreach_exoplanet.dm"
	// #include "example_unit_testing.dm"

	#define USING_MAP_DATUM /datum/map/persistence
#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Outreach

#endif
