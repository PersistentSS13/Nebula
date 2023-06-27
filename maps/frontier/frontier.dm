
/datum/level_data/exoplanet/kleibkhar/underground
	name                = "kleibkhar underground"
	level_id            = "kleibkhar_underground"
	level_flags         = ZLEVEL_CONTACT | ZLEVEL_PLAYER | ZLEVEL_MINING | ZLEVEL_SAVED
	ambient_light_level = 0.2
	base_area           = /area/exoplanet/kleibkhar/mines/depth_1
	base_turf           = /turf/exterior/barren/mining
	border_filler       = /turf/unsimulated/mineral


#if !defined(USING_MAP_DATUM)
	// Mods section
//	#include "../../mods/persistence/_persistence.dme"
	#include "../../mods/species/bayliens/_bayliens.dme"
	#include "../../mods/species/vox/_vox.dme"
	#include "../../mods/content/xenobiology/_xenobiology.dme"
	#include "../chargen/chargen_areas.dm"
	#include "../chargen/chargen_objects.dm"
	#include "../utility/cargo_shuttle_tmpl.dm"

	#include "frontier_zlevels.dm"
	#include "frontier_areas.dm"
	#include "frontier_departments.dm"
	#include "frontier_jobs.dm"
	#include "frontier_exoplanet.dm"
	#include "frontier_network.dm"
	#include "frontier_overmap.dm"
	#include "frontier_unit_testing.dm"
	#include "frontier_turf.dm"
	#include "frontier_events.dm"
	#include "frontier_species.dm"
	#include "frontier_supply.dm"

	#define USING_MAP_DATUM /datum/map/kleibkhar
#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring frontier

#endif
