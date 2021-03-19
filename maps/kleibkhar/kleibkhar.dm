#if !defined(USING_MAP_DATUM)
	// Mods section
	#include "../../mods/persistence/_persistence.dme"
	#include "../../mods/species/ascent/_ascent.dme"
	#include "../../mods/content/xenobiology/_xenobiology.dme"

	#include "kleibkhar_test.dm"
	#include "chargen/chargen_areas.dm"

	#include "kleibkhar_access.dm"
	#include "kleibkhar_areas.dm"
	#include "kleibkhar_jobs.dm"
	#include "kleibkhar_exoplanet.dm"
	#include "kleibkhar_unit_testing.dm"

	#define USING_MAP_DATUM /datum/map/kleibkhar
#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring kleibkhar

#endif
