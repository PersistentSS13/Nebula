/datum/computer_file/program/reader
	filename = "memrdr"
	filedesc = "Reader"
	extended_desc = "This program allows the reading of memory drives and playback."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 6
	available_on_network = 1
	usage_flags = PROGRAM_ALL
	nanomodule_path = /datum/nano_module/program/memory
	category = PROG_UTIL

	var/using_reader = 0	//Whether or not the program is synched with the scanner module.
	var/data_buffer = ""	//Buffers scan output for saving/viewing.
	var/scan_file_type = /datum/computer_file/data/text		//The type of file the data will be saved to.
	var/list/metadata_buffer = list()
	var/paper_type
	var/playing = 0.0
	var/playsleepseconds = 0.0
/datum/computer_file/program/reader/proc/connect_reader()	//If already connected, will reconnect.
	if(!computer)
		return 0
	var/obj/item/stock_parts/computer/mem_slot/reader = computer.get_component(PART_MEM)
	if(reader && istype(src, reader.driver_type))
		using_reader = 1
		reader.driver = src
		return 1
	return 0

/datum/computer_file/program/reader/proc/disconnect_reader()
	using_reader = 0
	if(computer)
		var/obj/item/stock_parts/computer/mem_slot/reader = computer.get_component(PART_MEM)
		if(reader && (src == reader.driver))
			reader.driver = null
	data_buffer = null
	metadata_buffer.Cut()
	return 1

/datum/computer_file/program/reader/proc/save_scan(name)
	if(!data_buffer)
		return 0
	if(!create_file(name, data_buffer, scan_file_type, metadata_buffer.Copy()))
		return 0
	return 1

/datum/computer_file/program/reader/proc/check_scanning()
	if(!computer)
		return 0
	var/obj/item/stock_parts/computer/mem_slot/reader = computer.get_component(PART_MEM)
	if(!reader)
		return 0
	if(!reader.can_run_scan)
		return 0
	if(!reader.check_functionality())
		return 0
	if(!using_reader)
		return 0
	if(src != reader.driver)
		return 0
	return 1

/datum/computer_file/program/reader/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["connect_scanner"])
		if(text2num(href_list["connect_scanner"]))
			if(!connect_reader())
				to_chat(usr, "Reader installation failed.")
		else
			disconnect_reader()
		return 1

	if(href_list["scan"])
		if(check_scanning())
			metadata_buffer.Cut()
			var/obj/item/stock_parts/computer/mem_slot/reader = computer.get_component(PART_MEM)
			var/info = "<B>Loaded Data:</B><BR><BR>"
			for(var/i=1,reader.stored_memory.storedinfo.len >= i,i++)
				var/info2 = reader.stored_memory.storedinfo[i]
				info += "[info2]<BR>"
				data_buffer = info
			if(!reader.stored_memory)
				return to_chat(usr, "Memory drive must be inserted.")
		return 1

	if(href_list["play"])
		var/obj/item/stock_parts/computer/mem_slot/reader = computer.get_component(PART_MEM)
		playing = 1
		to_chat(usr, "<span class='notice'>Audio playback started.</span>")
		playsound(usr, 'sound/machines/click.ogg', 10, 1)
		for(var/i=1 , i < reader.stored_memory.max_capacity , i++)
			if(!reader.stored_memory || !playing)
				break
			if(reader.stored_memory.storedinfo.len < i)
				break

			var/turf/T = get_turf(usr)
			var/playedmessage = reader.stored_memory.storedinfo[i]
			if(findtextEx(playedmessage,"*",1,2)) //remove marker for action sounds
				playedmessage = copytext(playedmessage,2)
			T.audible_message("<font color=Maroon><B>Playback</B>: [playedmessage]</font>")

			if(reader.stored_memory.storedinfo.len < i+1)
				playsleepseconds = 1
				sleep(10)
				T = get_turf(usr)
				T.audible_message("<font color=Maroon><B>Playback</B>: End of recording.</font>")
				playsound(usr, 'sound/machines/click.ogg', 10, 1)
				break
			else
				playsleepseconds = reader.stored_memory.timestamp[i+1] - reader.stored_memory.timestamp[i]

			if(playsleepseconds > 14)
				sleep(10)
				T = get_turf(usr)
				T.audible_message("<font color=Maroon><B>Playback</B>: Skipping [playsleepseconds] seconds of silence</font>")
				playsleepseconds = 1
			sleep(10 * playsleepseconds)

	if(href_list["save"])
		var/name = sanitize(input(usr, "Enter file name:", "Save As") as text|null)
		if(!save_scan(name))
			to_chat(usr, "Scan save failed.")

	if(.)
		SSnano.update_uis(NM)

/datum/nano_module/program/memory
	name = "Shell Player"

/datum/nano_module/program/memory/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/reader/prog = program
	if(!prog.computer)
		return
	var/obj/item/stock_parts/computer/mem_slot/reader = prog.computer.get_component(PART_MEM)
	if(reader)
		data["scanner_name"] = reader.name
		data["scanner_enabled"] = reader.enabled
		data["can_view_scan"] = reader.can_view_scan
		data["can_save_scan"] = (reader.can_save_scan && prog.data_buffer)
	data["using_scanner"] = prog.using_reader
	data["check_scanning"] = prog.check_scanning()

	data["data_buffer"] = digitalPencode2html(prog.data_buffer)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "scanner.tmpl", name, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()