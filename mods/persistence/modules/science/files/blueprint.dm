/datum/computer_file/data/blueprint
	var/instability			= BASE_BLUEPRINT_INSTABILITY	// 0-100 scale of how unstable this blueprint is.
	var/efficiency			= BASE_BLUEPRINT_EFFICIENCY		// Every material is divided by this to get how much it'll take to make something.
	var/speed				= BASE_BLUEPRINT_SPEED			// Time to make is divided by this.
	var/compression			= BASE_BLUEPRINT_COMPRESSION	// File size is divided by this.
	var/power_efficiency	= BASE_BLUEPRINT_POWER			// Power usage while making this item is divided by this.
	var/complexity			= 0								// The number of experiments done on this file.

	var/datum/fabricator_recipe/recipe
	var/list/experiments	= list()						// A list of possible experiments. Do not save this. This is meant to be wiped every server restart.

/datum/computer_file/data/blueprint/New(var/list/md = null, var/_recipe = null)
	set_recipe(_recipe)

/datum/computer_file/data/blueprint/proc/set_recipe(var/datum/fabricator_recipe/_recipe)
	recipe = _recipe
	filename = sanitize("[_recipe.name].[sequential_id("blueprint")]")
	calculate_size()

/datum/computer_file/data/blueprint/calculate_size()
	var/size = ceil(max(1, efficiency + speed + power_efficiency - instability) / compression)
	if(!recipe)
		return size
	for(var/tech in recipe.required_technology)
		size += recipe.required_technology[tech] / compression
	return ceil(size) + (complexity ** 2 / compression)

/datum/computer_file/data/blueprint/proc/get_resources()
	var/list/resources = list()
	var/list/building_cost = atom_info_repository.get_matter_for(recipe.path)
	for(var/mat in building_cost)
		if(!recipe.ignore_materials[mat])
			resources[mat] = ceil(building_cost[mat] / efficiency)
	return resources

/datum/computer_file/data/blueprint/proc/get_build_time()
	return ceil(recipe.build_time / speed)

/datum/computer_file/data/blueprint/proc/generate_experiments(var/mob/user)
	var/experiments_to_generate = max(0, user.get_skill_value(SKILL_SCIENCE) - length(experiments))
	while((length(experiments) < experiments_to_generate))
		if(!holder.can_store_file(3)) // Out of disk space.
			break
		var/datum/computer_file/data/experiment/experiment = new()
		experiment.target_blueprint = weakref(src)
		experiment.multiplier = rand(1, 3)
		experiment.attribute = pick("instability", "efficiency", "speed", "compression", "power_efficiency")
		experiment.tech_levels = list()
		var/tech_list = list(TECH_MATERIAL, TECH_ENGINEERING, TECH_PHORON, TECH_BLUESPACE, TECH_BIO, TECH_COMBAT, TECH_MAGNET, TECH_DATA, TECH_ESOTERIC)
		for(var/i in 1 to 3)
			experiment.tech_levels[pick_n_take(tech_list)] = 1 + rand(0, experiment.multiplier * 3)
		experiments += weakref(experiment)
		holder.store_file(experiment)
