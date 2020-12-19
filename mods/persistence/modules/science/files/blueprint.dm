/datum/computer_file/data/blueprint
	filetype = "BLP"
	do_not_edit = TRUE
	var/instability			= BASE_BLUEPRINT_INSTABILITY	// 0-100 scale of how unstable this blueprint is.
	var/efficiency			= BASE_BLUEPRINT_EFFICIENCY		// Every material is divided by this to get how much it'll take to make something.
	var/speed				= BASE_BLUEPRINT_SPEED			// Time to make is divided by this.
	var/compression			= BASE_BLUEPRINT_COMPRESSION	// File size is divided by this.
	var/power_efficiency	= BASE_BLUEPRINT_POWER			// Power usage while making this item is divided by this.
	var/complexity			= 0								// The number of experiments done on this file.

	var/atom/created_path
	var/list/experiments	= list()						// A list of possible experiments. Do not save this. This is meant to be wiped every server restart.
	var/cloned = FALSE										// Blueprints can be copied, but copies of blueprints cannot. Copied blueprints cannot be experimented on.

/datum/computer_file/data/blueprint/New(var/list/md = null, var/_created_path = null)
	set_path(_created_path)
	. = ..()

/datum/computer_file/data/blueprint/proc/set_path(var/_created_path)
	if(!_created_path)
		return
	created_path = _created_path
	filename = sanitize("[initial(created_path.name)] - [sequential_id("datum/computer_file/data/blueprint")]")
	for(var/badchar in list("/","\\",":","*","?","\"","<",">","|","#", ".", " ", ")"))
		filename = replacetext(filename, badchar, "")
	filename = replacetext(filename, "(", "-")
	size = calculate_size()
	return TRUE

/datum/computer_file/data/blueprint/calculate_size()
	var/size = ceil(max(1, efficiency + speed + power_efficiency - (instability / 100)) / compression)
	var/datum/fabricator_recipe/recipe = get_recipe()
	if(!recipe)
		return size
	for(var/tech in recipe.required_technology)
		size += recipe.required_technology[tech] / compression
	return ceil(size) + (complexity ** 2 / compression)

/datum/computer_file/data/blueprint/proc/get_resources()
	var/list/resources = list()
	var/datum/fabricator_recipe/recipe = get_recipe()
	var/list/building_cost = atom_info_repository.get_matter_for(recipe.path)
	for(var/mat in building_cost)
		if(!recipe.ignore_materials[mat])
			resources[mat] = ceil(building_cost[mat] / efficiency)
	return resources

/datum/computer_file/data/blueprint/proc/get_build_time()
	var/datum/fabricator_recipe/recipe = get_recipe()
	return ceil(recipe.build_time / speed)

/datum/computer_file/data/blueprint/proc/generate_experiments(var/mob/user)
	var/experiments_to_generate = max(0, user.get_skill_value(SKILL_SCIENCE) - length(experiments))
	if(cloned)
		return
	while((length(experiments) < experiments_to_generate))
		if(!holder.can_store_file(3)) // Out of disk space.
			break
		var/datum/computer_file/data/experiment/experiment = new()
		experiment.target_blueprint = weakref(src)
		experiment.multiplier = rand(1, 3)
		experiment.attribute = pick("instability", "efficiency", "speed", "compression", "power_efficiency")
		experiment.tech_levels = list()
		var/tech_list = list(TECH_MATERIAL, TECH_ENGINEERING, TECH_EXOTIC_MATTER, TECH_WORMHOLES, TECH_BIO, TECH_COMBAT, TECH_MAGNET, TECH_DATA, TECH_ESOTERIC)
		for(var/i in 1 to 3)
			experiment.tech_levels[pick_n_take(tech_list)] = 1 + rand(0, experiment.multiplier * 3)
		experiments += weakref(experiment)
		if(!holder.store_file(experiment))
			experiments -= weakref(experiment)
			QDEL_NULL(experiment)

/datum/computer_file/data/blueprint/proc/get_stats()
	. = list()
	.+= "Produces: [initial(created_path.name)]"
	.+= "Instability: [instability]%"
	.+= "Material Efficiency: rating [efficiency] ([100 / efficiency]% of normal cost)"
	.+= "Speed: rating [speed] ([get_build_time() / 10] seconds)"
	.+= "File Compression: [(BASE_BLUEPRINT_COMPRESSION / compression) * 100]%"
	.+= "Power Efficiency: rating [power_efficiency]"
	.+= "Complexity: [complexity]"
	var/list/materials = list()
	var/list/resources = get_resources()
	for(var/mat_type in resources)
		var/decl/material/mat = SSmaterials.materials_by_name[mat_type]
		materials += "[resources[mat_type]]x [mat.name]"
	.+= "Materials: [english_list(materials)]"

	. = jointext(.,"<br>")

/datum/computer_file/data/blueprint/proc/get_recipe()
	if(!created_path)
		return
	return SSfabrication.recipes_by_product_type[created_path]

/datum/computer_file/data/blueprint/clone()
	var/datum/computer_file/data/blueprint/temp = ..()
	if(cloned)
		temp.filename = "COPY FAILED - Copyright denied"
		return temp
	temp.created_path = created_path
	temp.efficiency = efficiency
	temp.speed = speed
	temp.compression = compression
	temp.power_efficiency = power_efficiency
	temp.complexity = complexity
	temp.cloned = TRUE
	return temp