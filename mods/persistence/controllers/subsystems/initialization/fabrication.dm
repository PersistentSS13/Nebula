/datum/controller/subsystem/fabrication
	var/list/research_recipes = list() // Fabricator class -> recipe

/datum/controller/subsystem/fabrication/Initialize()
	. = ..()
	for(var/fab_class in all_recipes)
		var/list/fab_recipes = all_recipes[fab_class]
		research_recipes[fab_class] = fab_recipes.Copy()
		if(fab_class in initial_recipes)
			research_recipes[fab_class] -= initial_recipes[fab_class]
		
		research_recipes[fab_class] -= get_unlocked_recipes(fab_class, get_default_initial_tech_levels())
		
		for(var/datum/fabricator_recipe/recipe in research_recipes[fab_class])
			if(recipe.research_excluded)
				research_recipes[fab_class] -= recipe
			else if(TECH_ESOTERIC in recipe.required_technology) // These techs must be unlocked via random chance during iteration
				research_recipes[fab_class] -= recipe

		if(!length(research_recipes[fab_class]))
			research_recipes -= fab_class