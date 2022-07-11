/obj/machinery/fabricator/refresh_design_cache(var/list/known_tech)
	. = ..()

	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = device.get_network()

	if(!network)
		return
	
	var/list/design_files = network.get_all_files_of_type(/datum/computer_file/data/design, MF_ROLE_DESIGN)
	if(!length(design_files)) // Return here to avoid sorting again.
		return

	add_designs(design_files)

	design_cache = sortTim(design_cache, /proc/cmp_name_asc)

/obj/machinery/fabricator/proc/add_designs(list/files)
	var/list/new_materials = list()
	. = list()
	for(var/datum/computer_file/data/design/D in files)
		if(!D.finalized || !D.recipe)
			continue
		if(!(fabricator_class in D.recipe.fabricator_types))
			continue
		if(D.recipe in design_cache)
			continue
		new_materials |= (D.recipe.resources ^ base_storage_capacity)
		design_cache += D.recipe
		. += D.recipe

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

// Saved vars

SAVED_VAR(/obj/machinery/fabricator, stored_material)
SAVED_VAR(/obj/machinery/fabricator, base_icon_state)
SAVED_VAR(/obj/machinery/fabricator, panel_image)
SAVED_VAR(/obj/machinery/fabricator, queued_orders)
SAVED_VAR(/obj/machinery/fabricator, currently_building)
SAVED_VAR(/obj/machinery/fabricator, storage_capacity)
SAVED_VAR(/obj/machinery/fabricator, show_category)
SAVED_VAR(/obj/machinery/fabricator, fab_status_flags)
SAVED_VAR(/obj/machinery/fabricator, mat_efficiency)
SAVED_VAR(/obj/machinery/fabricator, build_time_multiplier)

SAVED_VAR(/datum/fabricator_build_order, target_recipe)
SAVED_VAR(/datum/fabricator_build_order, multiplier)
SAVED_VAR(/datum/fabricator_build_order, remaining_time)
SAVED_VAR(/datum/fabricator_build_order, earmarked_materials)

