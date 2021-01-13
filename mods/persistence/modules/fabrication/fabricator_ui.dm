#define PRINT_MULTIPLIER_DIVISOR 5

/obj/machinery/fabricator/ui_interact(mob/user, ui_key = "rcon", datum/nanoui/ui=null, force_open=1)
	var/list/data = list()

	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = device.get_network()
	data["network"] = device.network_tag
	data["category"] =   show_category
	data["functional"] = is_functioning()

	if(is_functioning())
		data["color_selectable"] = color_selectable
		data["color"] = selected_color

		var/current_storage =  list()
		data["material_storage"] =  current_storage
		for(var/material in stored_material)
			var/list/material_data = list()
			var/mat_name = capitalize(stored_substances_to_names[material])
			material_data["name"] =        mat_name
			material_data["stored"] =      "[stored_material[material]][SHEET_UNIT]"
			material_data["max"] =         storage_capacity[material]
			material_data["eject_key"] =   stored_substances_to_names[material]
			material_data["eject_label"] = ispath(material, /decl/material) ? "Eject" : "Flush"
			data["material_storage"] +=    list(material_data)

		var/list/current_build = list()
		data["current_build"] = current_build
		if(currently_building)
			current_build["name"] =       currently_building.target_recipe.name
			current_build["multiplier"] = currently_building.multiplier
			current_build["progress"] =   "[100-round((currently_building.remaining_time/currently_building.build_time)*100)]%"
		else
			current_build["name"] =       "Nothing."
			current_build["multiplier"] = "-"
			current_build["progress"] =   "-"

		data["build_queue"] = list()
		if(length(queued_orders))
			for(var/datum/fabricator_build_order/order in queued_orders)
				var/list/order_data = list()
				order_data["name"] = order.target_recipe.name
				order_data["multiplier"] = order.multiplier
				order_data["reference"] = "\ref[order]"
				data["build_queue"] += list(order_data)
		else
			var/list/order_data = list()
			order_data["name"] = "Nothing."
			order_data["multiplier"] = "-"
			data["build_queue"] += list(order_data)

		data["build_options"] = list()

		var/list/designs = design_cache.Copy()
		if(istype(network))
			// Add the blueprints to the designs list.
			designs |= network.get_all_files_of_type(/datum/computer_file/data/blueprint, MF_ROLE_DESIGN, user)

		for(var/design in designs)
			var/datum/fabricator_recipe/recipe
			var/datum/computer_file/data/blueprint/BP
			if(istype(design, /datum/computer_file/data/blueprint))
				BP = design
				recipe = BP.get_recipe()
			else
				recipe = design
			if(!istype(recipe)) // Sanity check
				continue
			if(show_category != "All" && show_category != recipe.category || !(fabricator_class in recipe.fabricator_types))
				continue
			var/list/build_option = list()
			var/max_sheets = 0
			build_option["name"] =      recipe.name
			build_option["reference"] = "\ref[design]"
			build_option["illegal"] =   recipe.hidden
			var/list/resources = BP ? BP.get_resources() : recipe.resources
			if(!length(resources))
				build_option["cost"] = "No resources required."
				max_sheets = 100
			else
				//Make sure it's buildable and list required resources.
				var/list/material_components = list()
				for(var/material in resources)
					var/sheets = round(stored_material[material]/round(resources[material]*mat_efficiency))
					if(isnull(max_sheets) || max_sheets > sheets)
						max_sheets = sheets
					if(stored_material[material] < round(resources[material]*mat_efficiency))
						build_option["unavailable"] = 1
					material_components += "[round(resources[material] * mat_efficiency)][SHEET_UNIT] [stored_substances_to_names[material]]"
				build_option["cost"] = "[capitalize(jointext(material_components, ", "))]."
			if(recipe.max_amount >= PRINT_MULTIPLIER_DIVISOR && max_sheets >= PRINT_MULTIPLIER_DIVISOR)
				build_option["multiplier"] = list()
				for(var/i = 1 to Floor(min(recipe.max_amount, max_sheets)/PRINT_MULTIPLIER_DIVISOR))
					var/mult = i * PRINT_MULTIPLIER_DIVISOR
					build_option["multiplier"] += list(list("label" = "x[mult]", "multiplier" = mult))
			data["build_options"] += list(build_option)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "fabricator.tmpl", "[capitalize(name)]", 480, 410, state = GLOB.physical_state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)