/obj/machinery/destructive_analyzer/attackby(var/obj/item/O, var/mob/user)
	if(isrobot(user))
		return
	if(busy)
		to_chat(user, SPAN_WARNING("\The [src] is busy right now."))
		return TRUE
	if(component_attackby(O, user))
		return TRUE
	if(loaded_item)
		to_chat(user, SPAN_WARNING("There is something already loaded into \the [src]."))
		return TRUE
	if(panel_open)
		to_chat(user, SPAN_WARNING("You can't load \the [src] while it's opened."))
		return TRUE
	if(!istype(O, /obj/item/experiment))
		if(!O.origin_tech)
			to_chat(user, SPAN_WARNING("Nothing can be learned from \the [O]."))
			return TRUE
		var/list/techlvls = json_decode(O.origin_tech)
		if(!length(techlvls) || O.holographic)
			to_chat(user, SPAN_WARNING("You cannot deconstruct this item."))
			return TRUE

	if(user.unEquip(O, src))
		busy = TRUE
		loaded_item = O
		to_chat(user, SPAN_NOTICE("You add \the [O] to \the [src]."))
		flick("d_analyzer_la", src)
		addtimer(CALLBACK(src, .proc/refresh_busy, 1 SECOND))
		return TRUE

// Returns a list of paths of possible recipes to be selected by the user.
/obj/machinery/destructive_analyzer/process_loaded(var/mob/user, var/datum/file_storage/file_source)
	var/list/possible_recipes
	if(!loaded_item)
		return
	// Process the item.
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = device.get_network()
	if(!network)
		return
	var/analyze_successful
	if(istype(loaded_item, /obj/item/experiment))
		// Special handler. We need to disassemble the experiment.
		var/experiment_result = process_experiment(loaded_item, user, file_source)
		if(experiment_result)
			analyze_successful = TRUE
			if(islist(experiment_result))
				possible_recipes = experiment_result
	else
		// This is just a normal item.
		if(!(loaded_item.type in SSfabrication.recipes_by_product_type))
			to_chat(user, SPAN_WARNING("Unable to analyze \the [loaded_item]. No valid recipe found."))
			return
		var/datum/fabricator_recipe/recipe = SSfabrication.recipes_by_product_type[loaded_item.type]
		if(!istype(recipe))
			to_chat(user, SPAN_WARNING("Unable to analyze \the [loaded_item]. Recipe corrupted."))
			return
		possible_recipes = list()
		possible_recipes[recipe.name] = recipe.path
		analyze_successful = TRUE
	if(!analyze_successful)
		return
	busy = TRUE

	QDEL_NULL(loaded_item)
	flick("d_analyzer_process", src)
	addtimer(CALLBACK(src, .proc/refresh_busy, 2 SECONDS))
	return possible_recipes

/obj/machinery/destructive_analyzer/proc/process_experiment(var/obj/item/experiment/E, var/mob/user, var/datum/file_storage/file_source)
	if(!E.wired || !E.welded)
		return FALSE

	if(E.experiment_id)
		// This was a proper experiment.
		// Find the experiment first.
		var/datum/computer_file/data/experiment/experiment
		for(var/datum/computer_file/data/experiment/e_file in file_source.get_all_files())
			if(e_file.id != E.experiment_id)
				continue
			experiment = e_file
			break
		if(istype(experiment))
			// This is the matching file.
			if(!experiment.experiment_meets_prereqs(E))
				to_chat(user, SPAN_WARNING("Experiment does not meet prerequisites to complete research."))
				return FALSE
			return experiment.finish(E, user)
		// We didn't find the matching file.
		to_chat(user, SPAN_WARNING("Unable to find corresponding experiment. Was the file moved or deleted?"))
		return FALSE
	else
		// This was just invention.
		var/list/invention_technology = E.get_tech_levels()
		var/list/possible_recipes = list()
		var/decl/species/user_species = user.get_species()
		var/species_path = user_species.type

		var/list/valid_recipes = SSfabrication.get_valid_research_recipes(species_path)
		if(!length(valid_recipes))
			return FALSE
		for(var/datum/fabricator_recipe/recipe in valid_recipes)
			// Used to weight recipes depending on how close they are to the actual tech values of the recipe.
			// Must be some correspondance between invention technology and required technology.
			var/tech_delta = 10
			for(var/rec_tech in recipe.required_technology)
				if(!(rec_tech in invention_technology))
					tech_delta -= recipe.required_technology[rec_tech]
				else
					tech_delta -= abs(recipe.required_technology[rec_tech] - invention_technology[rec_tech])
			tech_delta = max(0, tech_delta)
			if(tech_delta)
				possible_recipes[recipe] = tech_delta
		. = list()
		var/recipes_to_produce = user.get_skill_value(SKILL_SCIENCE)
		for(var/i = 1 to recipes_to_produce)
			var/datum/fabricator_recipe/recipe = pickweight(possible_recipes)
			possible_recipes -= recipe
			.[recipe.name] = recipe.path
		
		if(!length(.))
			to_chat(user, SPAN_NOTICE("\The [src] beeps and reports that no viable design was able to be made from the experiment."))
			return TRUE // No matching recipes found
