/datum/computer_file/program/research_manager
	filename = "research_manager"
	filedesc = "Research Manager"
	extended_desc = "This program allows management of research."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "folder-collapsed"
	size = 12
	available_on_network = 1
	undeletable = 0
	usage_flags = PROGRAM_ALL
	category = PROG_UTIL

	var/mode = "experimentation"
	var/datum/computer_file/data/blueprint/open_file
	var/current_protolathe // Network tag for protolathe.
	var/error
	var/list/file_sources = list(
		/datum/file_storage/disk,
		/datum/file_storage/disk/removable,
		/datum/file_storage/network
	)
	var/datum/file_storage/current_filesource = /datum/file_storage/disk

/datum/computer_file/program/research_manager/on_startup(var/mob/living/user, var/datum/extension/interactive/ntos/new_host)
	..()
	for(var/T in file_sources)
		file_sources[T] = new T(new_host)
	current_filesource = file_sources[initial(current_filesource)]

/datum/computer_file/program/research_manager/on_shutdown()
	for(var/T in file_sources)
		var/datum/file_storage/FS = file_sources[T]
		qdel(FS)
		file_sources[T] = null
	current_filesource = initial(current_filesource)
	ui_header = null
	return ..()

/datum/computer_file/program/research_manager/Topic(href, href_list, state)
	. = ..()
	if(.)
		return

	var/mob/user = usr

	if(href_list["PRG_change_filesource"])
		. = TOPIC_HANDLED
		var/list/choices = list()
		for(var/T in file_sources)
			var/datum/file_storage/FS = file_sources[T]
			if(FS == current_filesource)
				continue
			choices[FS.name] = FS
		var/file_source = input(usr, "Choose a storage medium to use:", "Select Storage Medium") as null|anything in choices
		if(file_source)
			current_filesource = choices[file_source]
			if(istype(current_filesource, /datum/file_storage/network))
				var/datum/computer_network/network = computer.get_network()
				if(!network)
					return TOPIC_REFRESH
				// Helper for some user-friendliness. Try to select the first available mainframe.
				var/list/file_servers = network.get_file_server_tags()
				if(!file_servers.len)
					return TOPIC_REFRESH
				var/datum/file_storage/network/N = current_filesource
				N.server = file_servers[1]
			return TOPIC_REFRESH

	if(href_list["PRG_changefileserver"])
		. = TOPIC_HANDLED
		var/datum/computer_network/network = computer.get_network()
		if(!network)
			return
		var/list/file_servers = network.get_file_server_tags(user)
		var/file_server = input(usr, "Choose a fileserver to view files on:", "Select File Server") as null|anything in file_servers
		if(file_server)
			var/datum/file_storage/network/N = file_sources[/datum/file_storage/network]
			N.server = file_server
			return TOPIC_REFRESH

	var/errors = current_filesource.check_errors()
	if(errors)
		error = errors
		return TOPIC_HANDLED

	if(href_list["PRG_usbdeletefile"])
		. = TOPIC_REFRESH
		current_filesource.delete_file(href_list["PRG_usbdeletefile"])

	if(href_list["PRG_changemode"])
		. = TOPIC_REFRESH
		var/choice = input(user, "Choose a mode:","Research Mode", null) as null|anything in list("experimentation", "invention", "analyze")
		if(choice)
			mode = choice

	if(href_list["PRG_changeblueprint"])
		. = TOPIC_REFRESH
		var/list/blueprints = list()
		for(var/datum/computer_file/data/blueprint/BP in current_filesource.get_all_files())
			blueprints[BP.filename] = BP
		var/choice = input(user, "Choose a blueprint:", "Blueprints", null) as null|anything in blueprints
		if(!choice)
			return
		open_file = blueprints[choice]

	if(href_list["PRG_analyze"])
		. = TOPIC_REFRESH
		var/datum/computer_network/network = computer.get_network()
		if(!network)
			return
		var/datum/extension/network_device/D = network.get_device_by_tag(href_list["PRG_eject"])
		var/obj/machinery/destructive_analyzer/DA = D.holder
		if(DA.loaded_item)
			DA.process_loaded(user)

	if(href_list["PRG_eject"])
		. = TOPIC_REFRESH
		var/datum/computer_network/network = computer.get_network()
		if(!network)
			return
		var/datum/extension/network_device/D = network.get_device_by_tag(href_list["PRG_eject"])
		var/obj/machinery/destructive_analyzer/DA = D.holder
		if(DA.loaded_item)
			DA.loaded_item.dropInto(DA.loc)
			DA.loaded_item = null
			DA.update_icon()

	if(href_list["PRG_beginexperiment"])
		. = TOPIC_REFRESH
		var/datum/computer_network/network = computer.get_network()
		if(!network)
			return
		if(!current_protolathe)
			to_chat(user, SPAN_NOTICE("A working protolathe must be selected in order to begin an experiment."))
			return
		var/datum/extension/network_device/D = network.get_device_by_tag(current_protolathe)
		if(!istype(D))
			to_chat(user, SPAN_NOTICE("A working protolathe must be selected in order to begin an experiment."))
			current_protolathe = null
			return
		var/obj/protolathe = D.holder
		var/datum/computer_file/data/experiment/experiment = network.find_file_by_name(href_list["PRG_beginexperiment"])
		if(!istype(experiment))
			to_chat(user, SPAN_NOTICE("Unable to find experiment [href_list["PRG_beginexperiment"]]."))
			return
		var/obj/item/experiment/experimental_device = new(protolathe.loc)
		experimental_device.experiment_id = experiment.id
		experiment.begin()

	if(href_list["PRG_generate_experiments"])
		if(!istype(open_file))
			return
		. = TOPIC_REFRESH
		open_file.generate_experiments(user)

	if(href_list["PRG_change_protolathe"])
		. = TOPIC_REFRESH
		var/datum/computer_network/network = computer.get_network()
		if(!network)
			return
		var/list/protolathes = list()
		for(var/obj/machinery/fabricator/protolathe/P in network.get_devices_of_type(/obj/machinery/fabricator/protolathe, user))
			var/datum/extension/network_device/D = get_extension(P, /datum/extension/network_device)
			protolathes |= D.network_tag
		var/choice = input(user, "Choose a protolathe:", "Protolathes", null) as null|anything in protolathes
		if(!choice)
			return
		current_protolathe = choice

/datum/computer_file/program/research_manager/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	. = ..()
	if(!.)
		return
	var/list/data = computer.initial_data()

	if(error)
		data["error"] = error
	else if(current_filesource)
		data["error"] = current_filesource.check_errors()

	data["current_source"] = current_filesource.name
	if(istype(current_filesource, /datum/file_storage/network))
		var/datum/file_storage/network/N = current_filesource
		data["fileserver"] = N.server

	data["current_protolathe"] = current_protolathe ? current_protolathe : "Not set"

	data["mode"] = uppertext(mode)
	var/datum/computer_network/network = computer.get_network()
	switch(mode)
		if("invention")

		if("experimentation")
			data["blueprint"] = uppertext(open_file ? open_file.recipe.name : "Not set")
			if(istype(open_file))
				// We can get experiments!
				data["experiments"] = list()
				for(var/weakref/E in open_file.experiments)
					var/datum/computer_file/data/experiment/experiment = E.resolve()
					if(!istype(experiment))
						continue // File deleted.
					var/modifier
					if(experiment.multiplier >= 3)
						modifier = "greatly improves"
					else if(experiment.multiplier >= 2)
						modifier = "moderately improves"
					else
						modifier = "mildly improves"

					var/list/requirements = list()
					for(var/tech_level in experiment.tech_levels)
						requirements += "[tech_level] [experiment.tech_levels[tech_level]]"
					var/list/e_data = list(
						"id" = experiment.filename,
						"improves" = "[modifier] [experiment.attribute]",
						"requirements" = english_list(requirements),
						"code_fragments" = "",
						"status" = experiment.in_progress ? "In Progress" : "Proposal"
					)
					data["experiments"] += list(e_data)
		if("analyze")
			if(istype(network))
				var/list/analyzers = list()
				for(var/obj/machinery/destructive_analyzer/DA in network.get_devices_of_type(/obj/machinery/destructive_analyzer, user))
					var/datum/extension/network_device/device = get_extension(DA, /datum/extension/network_device)
					var/analyzer = list(
						"network_tag" = device.network_tag,
						"loaded_with" = istype(DA.loaded_item) ? DA.loaded_item.name : "Empty"
					)
					if(istype(DA.loaded_item))
						var/list/techlvls = json_decode(DA.loaded_item.origin_tech)
						var/list/results = list()
						for(var/techlvl in techlvls)
							results += "[techlvl] [techlvls[techlvl]]"
						analyzer["tech_levels"] = english_list(results)
						if(istype(DA.loaded_item, /obj/item/experiment))
							var/obj/item/experiment/experiment = DA.loaded_item
							analyzer["experiment"] = experiment.experiment_id ? "experiment [experiment.experiment_id]" : "invention"
						else
							analyzer["experiment"] = "None"
					analyzers += list(analyzer)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "research_manager.tmpl", "Research Manager", 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.set_auto_update(1)
		ui.open()