// Override to prevent grants being overwritten on load.
/obj/machinery/network/acl/RuntimeInitialize()
	// Get default file server.
	var/datum/extension/network_device/acl/FW = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = FW.get_network()
	if(network)
		var/datum/extension/network_device/file_server = network.get_file_server_by_role(MF_ROLE_CREW_RECORDS)
		if(file_server)
			file_source.server = file_server.network_tag
			// Populate initial grants.
			for(var/grant in initial_grants)
				if(network.find_file_by_name(grant)) // Prevent grants being overwritten on load
					continue
				create_grant(grant)