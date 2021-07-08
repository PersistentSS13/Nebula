#define TASK_SCAN_TIME 	60 SECONDS
#define TASK_CLONE_TIME	60 SECONDS

/datum/extension/network_device/cloning_pod
	var/occupied = FALSE
	var/scanning = FALSE
	var/cloning = FALSE
	var/cloning_progress = 0 // Used to display messages to whoever is being clone while they're in the vat. 
	var/task_started_on
	var/current_task 		 // Timer ID of task

	var/datum/file_transfer/scan

// Checks if this is a valid place for a mob to use as a cloning respawn point.
/datum/extension/network_device/cloning_pod/proc/is_valid_respawn(var/mind_id)
	if(!mind_id)
		return FALSE
	var/obj/machinery/cloning_pod/CP = holder
	if(!CP.operable() || CP.stat & (BROKEN|NOPOWER) || occupied)
		return FALSE
	var/datum/computer_network/network = get_network()
	if(!network)
		return FALSE
	return network.get_latest_clone_backup(mind_id)

/datum/extension/network_device/cloning_pod/proc/get_occupant()
	var/obj/machinery/cloning_pod/CP = holder
	return CP.occupant

/datum/extension/network_device/cloning_pod/proc/eject_occupant(var/mob/user)
	var/obj/machinery/cloning_pod/CP = holder
	return CP.eject_occupant(user)

/datum/extension/network_device/cloning_pod/proc/create_character(var/datum/mind/mind, var/datum/computer_file/data/cloning/backup, var/obj/item/organ/internal/stack/stack)
	var/datum/computer_network/network = get_network()
	if(!network)
		return
	var/obj/machinery/cloning_pod/CP = holder
	if(!istype(backup))
		backup = network.get_latest_clone_backup(mind.unique_id, TRUE)
	if(!istype(backup))
		return
	var/mob/living/carbon/human/new_character = new(CP, backup.dna.species)
	new_character.setDNA(backup.dna)
	new_character.fully_replace_character_name(backup.dna.real_name)
	new_character.UpdateAppearance()
	new_character.sync_organ_dna()
	
	new_character.add_language(/decl/language/human/common)
	new_character.default_language = /decl/language/human/common

	// The body forms 'around' the stack, so reinstall it.
	if(stack)
		var/obj/item/organ/O = new_character.get_organ(stack.parent_organ)
		stack.status &= ~ORGAN_CUT_AWAY
		stack.replaced(new_character, O)
	else
		mind.philotic_damage += 10

	mind.transfer_to(new_character)
	// TODO: More feedback on philotic damage in general.
	if(mind.philotic_damage > 75)
		to_chat(new_character, SPAN_WARNING("Colors seem to lack the vibrance they used to have. It would be easy to just go to sleep and never wake up."))
	// Transfer over skills from the backup file.
	new_character.skillset.points_remaining = backup.skill_points
	new_character.skillset.skill_list = backup.skill_list.Copy()
	new_character.skillset.on_levels_change()

	new_character.set_sdisability(BLINDED)

	CP.set_occupant(new_character)
	cloning = TRUE
	task_started_on = world.time
	update_cloning()
	current_task = addtimer(CALLBACK(src, /datum/extension/network_device/cloning_pod/proc/update_cloning), TASK_CLONE_TIME/4, TIMER_STOPPABLE | TIMER_LOOP)
	qdel(backup)
	return new_character

/datum/extension/network_device/cloning_pod/proc/update_cloning()
	var/atom/movable/occupant = get_occupant()
	if(!occupant || !cloning)
		cloning_progress = 0
		deltimer(current_task)
		return
	switch(cloning_progress)
		if(0)
			to_chat(occupant, SPAN_NOTICE("Reality comes flooding back all at once, cushioned by a flurry of perfluorochemical bubbles."))
			to_chat(occupant, SPAN_NOTICE("OOC: Characters usually have memory loss about the details surrounding their death. Play responsibly."))
		if(1)
			to_chat(occupant, SPAN_NOTICE("You feel a tingling numbness as the rudiments of your nervous system reform."))
		if(2)
			to_chat(occupant, SPAN_NOTICE("Muscle, bone, and skin coagulate around you. Your body is nearly remade."))
		if(3)
			to_chat(occupant, SPAN_NOTICE("The harsh light beyond the tube is intensifying. You'll be waking up soon."))
		if(4)
			to_chat(occupant, SPAN_NOTICE("You're harshly ejected out of the cloning tube, forced back into the world of the living."))
			deltimer(current_task)
			cloning = FALSE
			cloning_progress = 0
			var/obj/machinery/cloning_pod/CP = holder
			CP.eject_occupant()
			return
	cloning_progress += 1

/datum/extension/network_device/cloning_pod/proc/begin_scan(var/mob/caller, var/filesource)
	if(!check_scan())
		return
	cancel_task() // Delete any in progress timers just in case.
	var/atom/movable/occupant = get_occupant()
	if(!occupant)
		return

	scanning = TRUE
	task_started_on = world.time
	var/datum/computer_file/data/cloning/cloneFile = new()
	cloneFile.initialize_backup(occupant)
	scan = new(null, filesource, cloneFile)
	current_task = addtimer(CALLBACK(src, /datum/extension/network_device/cloning_pod/proc/finish_scan), TASK_SCAN_TIME, TIMER_STOPPABLE)
	to_chat(occupant, SPAN_NOTICE("Lights flash around you as a cortical scan begins."))

/datum/extension/network_device/cloning_pod/proc/finish_scan()
	var/atom/movable/occupant = get_occupant()
	if(!occupant)
		return

	scanning = FALSE
	if(!scan || !scan.transfer_to)
		return
	scan.transfer_to.store_file(scan.transferring)

	qdel(scan)
	scan = null

/datum/extension/network_device/cloning_pod/proc/cancel_task()
	deltimer(current_task)
	scanning = FALSE
	cloning = FALSE

/datum/extension/network_device/cloning_pod/proc/check_clone()
	if(cloning || scanning)
		return FALSE
	var/atom/movable/occupant = get_occupant()
	if(!istype(occupant, /obj/item/organ/internal/stack))
		return FALSE
	var/obj/item/organ/internal/stack/S = occupant
	if(S.backup && S.stackmob)
		return TRUE

	return FALSE

/datum/extension/network_device/cloning_pod/proc/check_scan()
	if(cloning || scanning)
		return FALSE
	var/atom/movable/occupant = get_occupant()
	if(!istype(occupant, /mob/living/carbon))
		return FALSE
	var/mob/living/carbon/subject = occupant
	if(subject.mind)
		return TRUE
	return FALSE

/datum/extension/network_device/cloning_pod/proc/begin_clone()
	if(!check_clone())
		return
	cancel_task() // Delete any in progress timers just in case.
	var/atom/movable/occupant = get_occupant()
	if(!occupant)
		return
	var/obj/item/organ/internal/stack/S = occupant
	if(!S)
		return
	return create_character(S?.stackmob?.mind, S.backup, S)