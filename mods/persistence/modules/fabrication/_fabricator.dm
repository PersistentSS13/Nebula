#define DEFAULT_TECH list( \
		TECH_MATERIAL = 1, \
		TECH_ENGINEERING = 1, \
		TECH_EXOTIC_MATTER = 0, \
		TECH_POWER = 1, \
		TECH_WORMHOLES = 0, \
		TECH_BIO = 0, \
		TECH_COMBAT = 0, \
		TECH_MAGNET = 1, \
		TECH_DATA = 1, \
		TECH_ESOTERIC = 0 \
	)

// Design cache only holds basic designs necessary for players to start out with.
/obj/machinery/fabricator/refresh_design_cache(var/list/known_tech)
	var/list/unlocked_tech = SSfabrication.get_unlocked_recipes(fabricator_class, DEFAULT_TECH)
	if(length(unlocked_tech))
		design_cache |= unlocked_tech
	
	for(var/datum/fabricator_recipe/R in design_cache)
		if(!length(R.species_locked))
			continue

		if(isnull(species_variation))
			design_cache.Remove(R)
			continue

		for(var/species_type in R.species_locked)
			if(ispath(species_variation, species_type))
				design_cache.Remove(R)
				return