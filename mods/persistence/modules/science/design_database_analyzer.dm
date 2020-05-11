/obj/machinery/destructive_analyzer/process_loaded(var/mob/user)
	if(!loaded_item)
		return
	// Process the item.
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = device.get_network()
	if(!network)
		return

	var/analyze_successful = FALSE
	if(istype(loaded_item, /obj/item/experiment))
		// Special handler. We need to disassemble the experiment.
		analyze_successful = process_experiment(loaded_item, user)
	else
		// This is just a normal item.
		try
			var/datum/fabricator_recipe/recipe = SSfabrication.recipes_by_product_type[loaded_item.type][1]
			var/datum/computer_file/data/blueprint/BP = new()
			BP.set_recipe(recipe)
			for(var/datum/extension/network_device/mainframe/MF in network.get_mainframes_by_role(MF_ROLE_DESIGN, user))
				if(MF.save_file(BP))
					analyze_successful = TRUE
					break
			if(!analyze_successful)
				QDEL_NULL(BP)
		catch
			to_chat(user, SPAN_WARNING("Unable to analyze \the [loaded_item]. A technical error has occurred."))
	if(!analyze_successful)
		return
	busy = TRUE

	QDEL_NULL(loaded_item)
	flick("d_analyzer_process", src)
	addtimer(CALLBACK(src, .proc/refresh_busy, 2 SECONDS))

/obj/machinery/destructive_analyzer/proc/process_experiment(var/obj/item/experiment/E, var/mob/user)
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = device.get_network()
	if(E.experiment_id)
		// This was a proper experiment.
		// Find the experiment first.
		for(var/datum/computer_file/data/experiment/experiment in network.get_all_files_of_type(/datum/computer_file/data/experiment, MF_ROLE_DESIGN, user))
			if(experiment.id != E.experiment_id)
				continue
			// This is the matching file.
			return experiment.finish(E)
		// We didn't find the matching file.
		to_chat(user, SPAN_WARNING("Unable to find corresponding experiment. Was the file moved or deleted?"))
		return FALSE
	else
		// This was just invention.
		var/invention_technology = E.get_tech_levels()
		var/list/possible_recipes = list()
		for(var/fab_type in SSfabrication.all_recipes)
			for(var/datum/fabricator_recipe/recipe in SSfabrication.all_recipes[fab_type])
				for(var/req_tech in recipe.required_technology)
					if(!(req_tech in invention_technology))
						continue
					if(invention_technology[req_tech] < recipe.required_technology[req_tech])
						continue
					possible_recipes |= recipe
		var/datum/fabricator_recipe/acquired_recipe = pick(possible_recipes)
		if(!istype(acquired_recipe))
			return FALSE // No matching recipes found
		var/datum/computer_file/data/blueprint/BP = new()
		BP.set_recipe(acquired_recipe)
		for(var/datum/extension/network_device/mainframe/MF in network.get_mainframes_by_role(MF_ROLE_DESIGN, user))
			if(MF.save_file(BP))
				to_chat(user, SPAN_NOTICE("\the [src] pings and reports that through invention it managed to produce a blueprint for [acquired_recipe.name]."))
				return TRUE
		return FALSE
