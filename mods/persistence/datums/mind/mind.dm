var/global/list/player_minds = list()

/datum/mind
	// This is a unique UID that will forever identify this mind.
	// No two minds are ever the same, and this ID will always identify 'this character'.
	var/unique_id
	var/age = 0 // How old the mob's mind is in years.
	var/philotic_damage = 0
	var/chargen_stack = TRUE // Whether or not the mob starts with a cortical stack.

	var/datum/skillset/chargen_skillset 		// Temporary skillset used for character generation.
	var/finished_chargen = FALSE				// Whether or not this character finished character generation.
	var/decl/hierarchy/chargen/origin/origin 	// The origin chosen for this character at chargen.
	var/decl/hierarchy/chargen/role/role		// The role chosen for this character at chargen.

/datum/mind/New()
	. = ..()
	unique_id = "[make_sequential_guid(/datum/mind)]"
	global.player_minds += src

/datum/mind/Destroy()
	. = ..()
	global.player_minds -= src

/datum/mind/transfer_to(mob/living/new_character)
	. = ..()
	// New mobs tend to have their organs installed before mind is transferred, so we'll double check that the mind_id is correct here.
	var/mob/living/carbon/human/H = new_character
	if(istype(H))
		var/obj/item/organ/internal/stack/S = H.get_organ(BP_STACK)
		if(S)
			S.update_mind_id()

/proc/get_valid_clone_pods(var/mind_id)
	var/list/valid_clone_pods = list()
	for(var/network_id in SSnetworking.networks)
		var/datum/computer_network/network = SSnetworking.networks[network_id]
		for(var/datum/extension/network_device/cloning_pod/CP in network.devices)
			var/datum/computer_file/data/cloning/backup = CP.is_valid_respawn(mind_id)
			if(istype(backup))
				valid_clone_pods["Backup [worldtime2stationtime(backup.backup_date)] - [get_area(CP)]"] = CP
	return valid_clone_pods

/proc/show_valid_respawns(var/mob/living/carbon/user)
	if(!user || !user.mind)
		return
	var/list/valid_clone_pods = get_valid_clone_pods(user.mind.unique_id)

	if(valid_clone_pods.len)
		var/clone_pod_tag = input(user, "Choose a cloning pod to awaken at:", "Select Cloning Pod") as null|anything in valid_clone_pods
		if(clone_pod_tag)
			var/datum/extension/network_device/cloning_pod/CP = valid_clone_pods[clone_pod_tag]
			if(!CP.is_valid_respawn(user.mind.unique_id))
				to_chat(user, SPAN_WARNING("That cloning pod has become unavailable. Please choose a new cloning pod."))
				return show_valid_respawns(user)
			if(CP.create_character(user.mind, user.ckey))
				qdel(user) // Whatever mob was storing us is no longer needed.
				return TRUE
			else
				to_chat(user, SPAN_WARNING("That cloning pod has become unavailable. Please choose a new cloning pod."))
				return show_valid_respawns(user)
	else
		to_chat(user, SPAN_NOTICE("There does not appear to be any viable clone pods for you to spawn in."))