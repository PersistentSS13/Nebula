/datum/nano_module/program/camera_monitor
	var/datum/computer_network/network

/datum/nano_module/program/camera_monitor/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/list/all_networks[0]
	network = get_network()
	
	data["current_camera"] = current_camera ? current_camera.nano_structure() : null
	data["current_network"] = network.network_id
	all_networks.Add(list(list(
						"tag" = network.network_id,
						"has_access" = 1
						)))

	all_networks = modify_networks_list(all_networks)

	data["networks"] = all_networks
	
	if(network)
		var/list/L = list()
		for(var/obj/machinery/camera/C in network.get_devices_by_type(/obj/machinery/camera))
			L[++L.len] = C.nano_structure()
		data["cameras"] = L

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "sec_camera(mod).tmpl", "Camera Monitoring", 900, 800, state = state)

		ui.add_template("mapContent", "sec_camera_map_content.tmpl")
		ui.add_template("mapHeader", "sec_camera_map_header.tmpl")
		ui.set_initial_data(data)
		ui.open()

	user.machine = nano_host()
	if(can_connect_to_camera(current_camera))
		user.reset_view(current_camera)
		
/datum/nano_module/program/camera_monitor/Topic(href, href_list)
	. = ..()
	
	if(..())
		return 1

	if(href_list["switch_camera"])
		var/obj/machinery/camera/C = locate(href_list["switch_camera"]) in network.get_devices_by_type(/obj/machinery/camera)
		if(!C)
			return
			
		if(!can_connect_to_camera(C))
			to_chat(usr, "Unable to establish a connection.")
			return

		switch_to_camera(usr, C)
		return 1

	else if(href_list["switch_network"])
		current_network = href_list["switch_network"]
		return 1

	else if(href_list["reset"])
		reset_current()
		usr.reset_view(current_camera)
		return 1
		
	else if(href_list["record"])
		var/obj/machinery/camera/C = locate(href_list["record"]) in network.get_devices_by_type(/obj/machinery/camera)
		if(!C)
			return
		vidrecord()
		return 1

	else if(href_list["capture"])
		var/obj/machinery/camera/C = locate(href_list["capture"]) in network.get_devices_by_type(/obj/machinery/camera)
		if(!C)
			return
		if(!current_camera.mymem)
			return to_chat(usr, "There's no memory in this camera!")
		current_camera.captureimage(current_camera)
		current_camera.mymem.printpicture(usr)
		return 1

	else if(href_list["print"])
		var/obj/machinery/camera/C = locate(href_list["print"]) in network.get_devices_by_type(/obj/machinery/camera)
		if(!C)
			return
		current_camera.print_transcript(usr)
//		current_camera.mymem.printpicture(usr)
		return 1

/datum/nano_module/program/camera_monitor/proc/vidrecord()

	if(!current_camera.mymem)
		to_chat(usr, "There's no memory in this camera!")
		return
	if(current_camera.recording)
		current_camera.stop_recording()
		current_camera.set_active(new_on = 0)
		to_chat(usr, "Stopped Recording.")
		return
	current_camera.set_active(1)
	current_camera.recording = 1
	to_chat(usr, "Now recording audio and video.")
