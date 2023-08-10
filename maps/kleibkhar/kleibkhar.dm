#if !defined(USING_MAP_DATUM)
	// Mods section
	#include "../../mods/persistence/_persistence.dme"
	#include "../../mods/species/bayliens/_bayliens.dme"
	#include "../../mods/species/vox/_vox.dme"
	#include "../../mods/content/xenobiology/_xenobiology.dme"
	#include "../chargen/chargen_areas.dm"
	#include "../chargen/chargen_objects.dm"
	//#include "../utility/cargo_shuttle_tmpl.dm"

	#include "kleibkhar_zlevels.dm"
	#include "kleibkhar_areas.dm"
	#include "kleibkhar_departments.dm"
	#include "kleibkhar_jobs.dm"
	#include "kleibkhar_exoplanet.dm"
	#include "kleibkhar_network.dm"
	#include "kleibkhar_overmap.dm"
	#include "kleibkhar_unit_testing.dm"
	#include "kleibkhar_turf.dm"
	#include "kleibkhar_events.dm"
	#include "kleibkhar_species.dm"
	#include "kleibkhar_supply.dm"

	#define USING_MAP_DATUM /datum/map/kleibkhar
#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring kleibkhar

#endif
