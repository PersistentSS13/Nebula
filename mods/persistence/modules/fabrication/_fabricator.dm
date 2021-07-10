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