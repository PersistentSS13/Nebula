/datum/computer_file/program/cloning
	filename = "organicbackup"
	filedesc = "Organic Backup System"
	extended_desc = "This system allows you to create a backup of yourself, in case of unfortunate death!"

	program_icon_state = "crew"
	program_key_state = "med_key"
	program_menu_icon = "heart"

	available_on_network = 1

	size = 12
	nanomodule_path = /datum/nano_module/program/cloning

/datum/computer_file/program/cloning/on_file_select(datum/file_storage/disk, datum/computer_file/directory/dir, datum/computer_file/selected, selecting_key, mob/user)
	// We pass the weakref instead of the network tag for safety reasons.
	var/weakref/CP_ref = selecting_key
	if(istype(CP_ref))
		var/datum/extension/network_device/cloning_pod/CP = CP_ref.resolve()
		if(istype(CP))
			CP.finished_scan = null
	. = ..()

/datum/computer_file/program/cloning/Topic(href, href_list)
	. = ..()
	if(.)
		return

	var/mob/user = usr
	var/datum/computer_network/network = computer.get_network()
	if(!network)
		return

	if(href_list["backup"])
		var/datum/extension/network_device/cloning_pod/CP = network.get_device_by_tag(href_list["machine"])
		if(!istype(CP))
			return TOPIC_REFRESH
		CP.begin_scan(user)
		return TOPIC_REFRESH

	if(href_list["save"])
		var/datum/extension/network_device/cloning_pod/CP = network.get_device_by_tag(href_list["machine"])
		if(!istype(CP))
			return TOPIC_REFRESH

		if(!CP.finished_scan)
			return TOPIC_REFRESH
		var/browser_desc = "Save cloning scan as:"
		view_file_browser(user, weakref(CP), /datum/computer_file/data/cloning, OS_WRITE_ACCESS, browser_desc, CP.finished_scan)
		return TOPIC_HANDLED

	if(href_list["clone"])
		var/datum/extension/network_device/cloning_pod/CP = network.get_device_by_tag(href_list["machine"])
		if(!istype(CP))
			return TOPIC_REFRESH
		var/obj/item/organ/internal/stack/occupant = CP.get_occupant()
		if(!istype(occupant) || !occupant.stackmob || !occupant.stackmob.mind)
			to_chat(user, SPAN_WARNING("The console flashes an error: invalid occupant!"))
			return TOPIC_REFRESH
		CP.begin_clone(user)
		return TOPIC_REFRESH

	if(href_list["eject"])
		var/datum/extension/network_device/cloning_pod/CP = network.get_device_by_tag(href_list["machine"])
		if(!istype(CP))
			return TOPIC_REFRESH
		CP.eject_occupant(user)
		return TOPIC_REFRESH

/datum/nano_module/program/cloning
	name = "Organic Backup System"

/datum/nano_module/program/cloning/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/cloning/PRG = program
	var/datum/computer_network/network = PRG.computer.get_network()
	if(network)
		var/list/cloning_pods = list()
		for(var/datum/extension/network_device/cloning_pod/CP in network.devices)
			var/obj/machinery/machine = CP.holder
			var/list/cloning_pod = list(
				"id" = CP.network_tag,
				"online" = !(!machine.operable() || machine.stat & (BROKEN|NOPOWER)),
				"operation" = "Waiting.",
				"contents" = "Empty.",
				"total_progress" = 1
			)
			cloning_pod["can_clone"] = CP.check_clone()
			cloning_pod["can_backup"] = CP.check_scan()
			cloning_pod["can_save"] = !!CP.finished_scan
			var/atom/movable/occupant = CP.get_occupant()
			if(!cloning_pod["online"])
				cloning_pod["status"] = "Offline."
			else if(occupant)
				cloning_pod["status"] = "Occupied."
				if(CP.finished_scan)
					cloning_pod["operation"] = "Scan complete"
				else if(CP.scanning || CP.cloning)
					cloning_pod["operation"] = CP.scanning ? "Scanning" : "Cloning"
					cloning_pod["progress"] = (world.time - CP.task_started_on) / (TASK_SCAN_TIME)
					cloning_pod["remaining"] = round((TASK_SCAN_TIME + CP.task_started_on - world.time) / 10)
				if(istype(occupant, /obj/item/organ/internal/stack))
					cloning_pod["contents"] = occupant.name
				else if(istype(occupant, /mob/living/carbon))
					var/mob/living/carbon/O = occupant
					cloning_pod["contents"] = "lifeform: [O.species.name]"
					if(O.mind)
						var/datum/computer_file/data/cloning/cloneFile = network.get_latest_clone_backup(O.mind.unique_id)
						if(cloneFile)
							cloning_pod["detailed"] = TRUE
							cloning_pod["last_backup"] = time2text(cloneFile.backup_date, "DDD, Month DD of YYYY")
							cloning_pod["backup_size"] = cloneFile.size
							cloning_pod["filename"] = cloneFile.filename
			else
				cloning_pod["status"] = "Online."
			cloning_pods += list(cloning_pod)
		data["cloning_pods"] = cloning_pods

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "cloning_program.tmpl", name, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.set_auto_update(1)
		ui.open()