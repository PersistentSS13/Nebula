/obj/machinery/fabricator/refresh_design_cache(var/list/known_tech)
	. = ..()

	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = device.get_network()

	if(!network)
		return
	
	var/list/design_files = network.get_all_files_of_type(/datum/computer_file/data/design, MF_ROLE_DESIGN)
	if(!length(design_files)) // Return here to avoid sorting again.
		return

	var/list/new_materials = list()
	for(var/datum/computer_file/data/design/D AS_ANYTHING in design_files)
		if(!D.finalized || !D.recipe)
			continue
		if(!(fabricator_class in D.recipe.fabricator_types))
			continue
		new_materials |= (D.recipe.resources ^ base_storage_capacity)
		design_cache += D.recipe

	// This is painful, but the material storage system is pretty inflexible. Adds the materials to both the base capacities and the current
	// capacities, redoing a lot of work done in Initialize() for the normal materials.
	if(length(new_materials))
		for(var/mat_path in new_materials)
			stored_material[mat_path] = 0

			// Update global type to string cache.
			if(!stored_substances_to_names[mat_path])
				if(ispath(mat_path, /decl/material))
					var/decl/material/mat_instance = GET_DECL(mat_path)
					if(istype(mat_instance))
						stored_substances_to_names[mat_path] =  lowertext(mat_instance.name)
				else if(istype(mat_path, /decl/material))
					var/decl/material/reg = mat_path
					stored_substances_to_names[reg.type] = lowertext(initial(reg.name))

			base_storage_capacity[mat_path] = SHEET_MATERIAL_AMOUNT * 10
		RefreshParts()

	design_cache = sortTim(design_cache, /proc/cmp_name_asc)
