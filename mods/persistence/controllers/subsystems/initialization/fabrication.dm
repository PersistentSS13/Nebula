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

/datum/controller/subsystem/fabrication
	var/list/valid_research_recipes = list() // Keyed from species->valid recipes

/datum/controller/subsystem/fabrication/proc/get_valid_research_recipes(var/species_path)
	if(valid_research_recipes[species_path])
		return valid_research_recipes[species_path]
	if(!ispath(species_path, /decl/species))
		return null
	
	valid_research_recipes[species_path] = list()
	for(var/fab_type in all_recipes)
		for(var/datum/fabricator_recipe/recipe in all_recipes[fab_type])
			if(istype(recipe, /datum/fabricator_recipe/robotics/robot_component) || istype(recipe, /datum/fabricator_recipe/imprinter/ai))
				continue
			// Don't include any auto-unlocked tech - they're not worth researching further.
			if(!(recipe in locked_recipes[fab_type]))
				continue
			if(recipe in get_unlocked_recipes(fab_type, DEFAULT_TECH))
				continue
			if(recipe.species_locked)
				if(!(species_path in recipe.species_locked))
					continue
			valid_research_recipes[species_path] |= recipe
	
	return valid_research_recipes[species_path]

