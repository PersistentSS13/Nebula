/datum/computer_file/program/ide
	filename = "ide"
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

	var/error
	var/list/file_sources = list(
		/datum/file_storage/disk,
		/datum/file_storage/disk/removable,
		/datum/file_storage/network
	)
	var/datum/file_storage/current_filesource = /datum/file_storage/disk

/datum/computer_file/program/ide/on_startup(var/mob/living/user, var/datum/extension/interactive/ntos/new_host)
	..()
	for(var/T in file_sources)
		file_sources[T] = new T(new_host)
	current_filesource = file_sources[initial(current_filesource)]

/datum/computer_file/program/ide/on_shutdown()
	for(var/T in file_sources)
		var/datum/file_storage/FS = file_sources[T]
		qdel(FS)
		file_sources[T] = null
	current_filesource = initial(current_filesource)
	ui_header = null
	return ..()

/datum/computer_file/program/ide/Topic(href, href_list, state)
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

/datum/computer_file/program/ide/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
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


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ide.tmpl", "", 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.set_auto_update(1)
		ui.open()