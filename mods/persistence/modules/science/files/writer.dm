#define RECIPES_PER_PAGE 10

#define MODE_ERROR  -1
#define MODE_LISTING 0
#define MODE_RECIPE  1
#define MODE_DESIGN  2
#define MODE_THEORY  3

/datum/computer_file/program/design_writer
	filename = "designWrit"
	filedesc = "Computer assisted designer"
	extended_desc = "This program allows development of new technological designs for use in fabricators."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "folder-collapsed"
	size = 12
	available_on_network = 1
	undeletable = 0
	usage_flags = PROGRAM_ALL
	category = PROG_UTIL

	var/datum/computer_file/data/design/current_design
	var/datum/fabricator_recipe/current_recipe

	var/current_design_directory

	var/error
	var/prog_mode = MODE_LISTING

	var/selected_analyzer // Network tag of the selected analyzer

	var/selected_fab_type = FABRICATOR_CLASS_PROTOLATHE
	var/search_string
	var/current_page = 1

	var/list/cached_recipe_data = list()

/datum/computer_file/program/design_writer/on_startup(var/mob/living/user, var/datum/extension/interactive/os/new_host)
	. = ..()
	cache_recipes()

/datum/computer_file/program/design_writer/on_shutdown()
	ui_header = null

	current_design = null
	current_design_directory = null
	current_recipe = null
	selected_analyzer = null

	current_page = 1
	search_string = null
	cached_recipe_data.Cut()

	prog_mode = MODE_LISTING
	error = null
	return ..()

/datum/computer_file/program/design_writer/on_file_select(datum/file_storage/disk, datum/computer_file/directory/dir, datum/computer_file/selected, selecting_key)
	if(istype(selected, /datum/computer_file/data/design))
		current_design = selected
		current_design_directory = disk.get_dir_path(dir, TRUE)

		prog_mode = MODE_DESIGN
	. = ..()

/datum/computer_file/program/design_writer/Topic(href, href_list, state)
	. = ..()
	if(.)
		return

	var/mob/user = usr

	if(error)
		prog_mode = MODE_ERROR

	if(prog_mode == MODE_ERROR)
		error = null
		prog_mode = MODE_LISTING // Any input here just returns us to the recipe listing.
		return TOPIC_REFRESH

	// Listing Recipes
	if(prog_mode == MODE_LISTING)
		if(href_list["PRG_select_fab_type"])
			var/choice = input(user, "Select the fabricator category you would like to view.") as null|anything in SSfabrication.research_recipes
			if(choice && (choice != selected_fab_type) && CanInteract(usr,state))
				selected_fab_type = choice
				current_page = 1
				cache_recipes()
			return TOPIC_REFRESH

		if(href_list["PRG_search"])
			var/new_search_string = sanitize(input(user, "Enter a new search string.", "Research search") as text|null)
			if(CanInteract(user, state) && (new_search_string != search_string))
				search_string = new_search_string
				current_page = 1
				cache_recipes()
				return TOPIC_REFRESH
			return TOPIC_HANDLED

		if(href_list["PRG_select_recipe"])
			var/datum/fabricator_recipe/recipe = locate(href_list["PRG_select_recipe"])
			if(recipe in SSfabrication.research_recipes[selected_fab_type])
				current_recipe = recipe
				current_design = null
				prog_mode = MODE_RECIPE
			return TOPIC_REFRESH

		if(href_list["PRG_prev_page"])
			current_page -= 1
			return TOPIC_REFRESH

		if(href_list["PRG_next_page"])
			current_page += 1
			return TOPIC_REFRESH

		if(href_list["PRG_change_design"])
			var/browser_desc = "Select a design file to open"
			view_file_browser(usr, "open_file", /datum/computer_file/data/design, OS_READ_ACCESS, browser_desc)
			return TOPIC_REFRESH

	// Viewing Recipe
	if(prog_mode == MODE_RECIPE)
		if(href_list["PRG_back"])
			prog_mode = MODE_LISTING
			return TOPIC_REFRESH

		if(href_list["PRG_create_design"])
			var/browser_desc = "Save design file as:"
			var/datum/computer_file/data/design/saving_design = new(null, current_recipe)
			view_file_browser(usr, "saveas_file", /datum/computer_file/data/design, OS_WRITE_ACCESS, browser_desc, saving_design)
			return TOPIC_HANDLED

		prog_mode = MODE_LISTING
		return TOPIC_REFRESH

	// Viewing design
	if(prog_mode == MODE_DESIGN)
		if(!current_design)
			prog_mode = MODE_LISTING
			return TOPIC_REFRESH

		if(!(get_file(current_design.filename, current_design_directory, computer.get_access(user), user)))
			error = "I/O Error: Could not locate design file!"
			current_design = null
			prog_mode = MODE_ERROR
			return TOPIC_REFRESH

		if(href_list["PRG_back"])
			prog_mode = MODE_LISTING
			return TOPIC_REFRESH

		if(href_list["PRG_change_analyzer"])
			var/datum/computer_network/network = computer.get_network()
			if(!network)
				to_chat(user, SPAN_WARNING("Network error: Could not connect to network!"))
				return TOPIC_REFRESH
			var/list/analyzers = network.get_tags_by_type(/obj/machinery/destructive_analyzer)
			if(!length(analyzers))
				to_chat(user, SPAN_WARNING("No destructive analyzers found on the network!"))
				return TOPIC_HANDLED

			var/tag_choice = input(user, "Select the destructive analyzer you would like to use,", "Destructive Analyzer Selection") as null|anything in analyzers
			if(!tag_choice || !CanInteract(user, state))
				return TOPIC_HANDLED

			selected_analyzer = tag_choice
			return TOPIC_REFRESH

		if(href_list["PRG_generate_theories"])
			if(length(current_design.theory_options) || current_design.finalized)
				return TOPIC_REFRESH

			current_design.generate_theories(user)
			return TOPIC_REFRESH

		if(href_list["PRG_select_theory"])
			var/datum/theory/selected = locate(href_list["PRG_select_theory"])
			if(!istype(selected) || !(selected in current_design.theory_options)) // Check to make sure this is a valid theory to select for the design.
				return TOPIC_REFRESH
			var/obj/item/analyzed
			var/datum/computer_network/network = computer.get_network()
			if(network)
				var/datum/extension/network_device/D = network.get_device_by_tag(selected_analyzer)
				if(D)
					var/obj/machinery/destructive_analyzer/analyzer = D.holder
					if(istype(analyzer))
						analyzed = analyzer.loaded_item

			var/feedback = current_design.select_theory(selected, analyzed, user)
			if(feedback)
				to_chat(user, SPAN_WARNING(feedback))
			if(current_design.progressing)
				// Little bit of feedback that they've progressed the design
				sound_to(user, 'sound/effects/bells.ogg')
			return TOPIC_REFRESH

		if(href_list["PRG_discard_theory"])
			var/datum/theory/discarded = locate(href_list["PRG_discard_theory"])
			if(!istype(discarded) || !(discarded in current_design.theory_options))
				return TOPIC_REFRESH

			current_design.discard_theory(discarded)
			return TOPIC_REFRESH

		if(href_list["PRG_add_point"])
			current_design.use_free_point(href_list["PRG_add_point"])
			return TOPIC_REFRESH

/datum/computer_file/program/design_writer/proc/cache_recipes()
	cached_recipe_data.Cut()
	if(!selected_fab_type)
		return
	var/list/recipe_list = SSfabrication.research_recipes[selected_fab_type]
	if(islist(recipe_list))
		for(var/datum/fabricator_recipe/recipe in recipe_list)
			var/recipe_name = recipe.get_product_name()
			if(search_string && !findtextEx_char(lowertext(recipe_name), lowertext(search_string)))
				continue

			var/list/recipe_data = list(
				"name" = recipe_name,
				"ref" = "\ref[recipe]"
			)

			cached_recipe_data += list(recipe_data)

/datum/computer_file/program/design_writer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	. = ..()
	if(!.)
		return
	var/list/data = computer.initial_data()

	data["prog_mode"] = prog_mode
	if(prog_mode == MODE_LISTING)

		data["fab_type"] = selected_fab_type
		data["search_string"] =  search_string || "No search filter set."
		data["recipe_listing"] = list()

		if(length(cached_recipe_data))

			var/total_recipes = length(cached_recipe_data)

			var/max_pages = CEILING(total_recipes/RECIPES_PER_PAGE)
			current_page = clamp(current_page, 1, max_pages)
			var/start_index = (current_page - 1)*RECIPES_PER_PAGE + 1

			data["recipe_listing"] = cached_recipe_data.Copy(start_index, min(total_recipes, start_index + RECIPES_PER_PAGE))

			if(current_page == max_pages)
				data["max_page"] = TRUE

		data["current_page"] = current_page

	else if(prog_mode == MODE_RECIPE)
		if(current_recipe)
			data["current_recipe"] = current_recipe.get_product_name()
			data["mat_costs"] = list()
			for(var/mat in current_recipe.resources)
				var/decl/material/material_type = GET_DECL(mat)
				data["mat_costs"] += list(list("name" = material_type.name, "amount" = current_recipe.resources[mat]))
			data["research_costs"] = list()
			var/mod_research_cost = current_recipe.get_mod_research_cost()
			for(var/tech in mod_research_cost)
				data["research_costs"] += list(list("name" = tech, "amount" = mod_research_cost[tech]))
		else
			error = "Internal Error: Could not locate prototype!"

	else if(prog_mode == MODE_DESIGN)
		if(!(get_file(current_design.filename, current_design_directory, computer.get_access(user), user)))
			error = "I/O Error: Could not locate design file!"
			current_design = null
			prog_mode = MODE_ERROR
		else if(current_design.finalized)
			data["final_desc"] = current_design.stored_data
			data["design_name"] = current_design.filename
		else
			data["design_name"] = current_design.filename
			data["theories"] = list()
			for(var/datum/theory/option in current_design.theory_options)
				var/list/option_ui_data = option.get_ui_data()
				// Special cards are automatically discarded, so don't scratch them out.
				option_ui_data["discard"] = option_ui_data["special"] ? FALSE : !current_design.theory_options[option]
				data["theories"] += list(option_ui_data)

			data["specifications"] = list()
			if(LAZYLEN(current_design.specifications))
				for(var/datum/specification/spec in current_design.specifications)
					data["specifications"] += spec.get_name()

			data["research_points"] = current_design.remaining_points
			data["fields"] = current_design.get_ui_data()
			data["free_points"] = !!current_design.free_points

			data["selected_analyzer"] = (selected_analyzer || "No analyzer selected")
			data["loaded_item"] = "No item loaded"
			if(selected_analyzer)
				var/datum/computer_network/network = computer.get_network()
				if(network)
					var/datum/extension/network_device/D = network.get_device_by_tag(selected_analyzer)
					if(D)
						var/obj/machinery/destructive_analyzer/analyzer = D.holder
						if(istype(analyzer))
							data["loaded_item"] = analyzer.loaded_item ? analyzer.loaded_item.name : "No item loaded"

	// Check the error mode last just in case we had an oopsie in another mode during the ui update.
	if(prog_mode == MODE_ERROR)
		data["error"] = error

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "design_writer.tmpl", "Technical Design Utility", 1000, 700, state = state)
		ui.set_initial_data(data)
		ui.open()

#undef RECIPES_PER_PAGE
#undef MODE_ERROR
#undef MODE_LISTING
#undef MODE_RECIPE
#undef MODE_DESIGN
#undef MODE_THEORY