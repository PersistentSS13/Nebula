#if !defined(USING_MAP_DATUM)
	// Mods section
	#include "../../mods/persistence/_persistence.dme"
	#include "../../mods/species/ascent/_ascent.dme"
	#include "../../mods/content/xenobiology/_xenobiology.dme"
	#include "../chargen/chargen_areas.dm"

	#include "outreach_test.dm"

	#include "music_tracks/dirtyoldfrogg.dm"

	#include "outreach_access.dm"
	#include "outreach_areas.dm"
	#include "outreach_jobs.dm"
	#include "outreach_exoplanet.dm"

	#define USING_MAP_DATUM /datum/map/outreach
#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Outreach

#endif
