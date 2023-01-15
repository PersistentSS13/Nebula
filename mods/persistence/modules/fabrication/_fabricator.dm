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
	. = list()
	for(var/datum/computer_file/data/design/D in files)
		if(!D.finalized || !D.recipe)
			continue
		if(!(fabricator_class in D.recipe.fabricator_types))
			continue
		if(D.recipe in design_cache)
			continue
		design_cache += D.recipe
		. += D.recipe

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

