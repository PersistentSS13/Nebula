#define STARTING_POINTS 30

/obj/machinery/cryopod/outreach
	name = "cryogenic freezer"

/obj/machinery/cryopod/outreach/Initialize()
	. = ..()
	global.latejoin_locations |= get_turf(src)
	global.latejoin_cryo_locations |= get_turf(src)

/obj/machinery/cryopod/chargen/Initialize()
	. = ..()
	icon_state = occupied_icon_state //Those starts closed

/obj/machinery/cryopod/chargen/proc/ready_for_mingebag()
	set_light(10, 1, COLOR_CYAN_BLUE)
	icon_state = base_icon_state
	if(open_sound)
		playsound(src, open_sound, 40)

/obj/machinery/cryopod/chargen/proc/unready()
	icon_state = occupied_icon_state
	set_light(0, null)

// Chargen pod
/obj/machinery/cryopod/chargen/proc/send_to_outpost()
	if(!istype(occupant))
		return

	var/mob/living/carbon/human/user = occupant
//	if(occupant.mind.chargen_stack)
	var/obj/item/organ/internal/stack/charstack = new()
	var/obj/item/organ/O = occupant.get_organ(charstack.parent_organ)
	user.add_organ(charstack, O)
	to_chat(user, SPAN_NOTICE("As your shuttle approaches the frontier the cryopod you are in suddenly shunts a neural stack into your cortex, wrenching you back to momentary conciousness."))
	// Updating the mob's skills with the actual chargen choices.
	var/datum/skillset/mob_set = occupant.skillset
	var/datum/skillset/char = occupant.mind.chargen_skillset
	var/list/char_set = char.skill_list
	mob_set.skill_list = char_set.Copy()
	mob_set.default_value = char.default_value
	mob_set.points_remaining = max(STARTING_POINTS + user.mind.role.remaining_points_offset, 0)
	mob_set.on_levels_change()
	to_chat(user, SPAN_NOTICE("You have an additional [mob_set.points_remaining] skill points to apply to your character. Use the 'Adjust Skills' verb to do so"))

	var/obj/starter_book = user.mind.role.text_book_type
	if(starter_book)
		to_chat(user, SPAN_NOTICE("You have brought with you a textbook related to your specialty. It will tell you secrets of the Frontier that can help someone with your skillset."))
		user.equip_to_storage(new starter_book(user))

	// Find the starting network, and create the crew record + user account for convenience.

	// Crew record is created on spawn, just reuse it
	var/datum/computer_file/report/crew_record/CR = get_crewmember_record(user.real_name)
	if(!CR)
		error("obj/machinery/cryopod/chargen/proc/send_to_outpost(): Missing crew record for '[user.real_name]'(Ckey:'[user.ckey]')!")
	//#FIXME: Should probably be done in a proc in SSnetworking instead

	var/network_id = global.using_map.spawn_network
	if(network_id)
		var/datum/computer_network/network = SSnetworking.networks[network_id]
		if(network)
			network.store_file(CR, MF_ROLE_CREW_RECORDS)

			network.create_account(user, user.real_name, null, user.real_name, null, TRUE)

	var/area/A = get_area(src)
	var/obj/chargen/status_light/slight = locate() in A
	if(slight)
		slight.completed_chargen = FALSE
		slight.update_icon()

	//Free up the chargen pod
	unready()
	SSchargen.release_spawn_pod(get_area(src))

	// Add the mob to limbo for safety. Mark for removal on the next save.
	SSpersistence.AddToLimbo(list(user, user.mind), user.mind.unique_id, LIMBO_MIND, user.mind.key, user.mind.current.real_name, TRUE)
	SSpersistence.limbo_removals += list(list(user.mind.unique_id, LIMBO_MIND))

	for(var/turf/T in global.latejoin_cryo_locations)
		var/obj/machinery/cryopod/C = locate() in T
		if(C.occupant)
			continue
		go_out()
		C.set_occupant(user, silent = TRUE)
		C.on_mob_spawn()
		spawn(1 SECOND)
		to_chat(user, SPAN_NOTICE("<br><br><br>You wake up feeling like you died and came back to life on the journey here."))
		to_chat(user, SPAN_NOTICE("Find your fortune in the glorious frontier! You should have a book in your inventory that can help you start your journey."))
		to_chat(user, SPAN_NOTICE("<br><br>Don't forget to assign your extra skillpoints by using 'Adjust your Skills' in the IC menu tab."))
		C.go_out()
		return

	// If we didn't find a empty turf, put them on a filled one
	var/turf/T = pick(global.latejoin_cryo_locations | global.latejoin_locations)
	if(T)
		go_out()
		user.forceMove(T)
	else
		to_chat(user, SPAN_DANGER("UNABLE TO FIND SUITABLE LOCATION, CONTACT AN ADMIN!"))
		message_admins(SPAN_DANGER("UNABLE TO FIND SUITABLE CRYO SPAWN LOCATION FOR CKEY:'[user.ckey]'([user.name])! CREATE A CRYOPOD."))


/obj/machinery/cryopod/chargen/check_occupant_allowed(mob/M)
	. = ..()
	if(!.)
		return
	var/allowed = M.mind.finished_chargen
	if(!allowed)
		to_chat(M, SPAN_NOTICE("The [src] beeps: Please finish your dossier on the terminal before proceeding to cryostasis."))
	return allowed

/obj/machinery/cryopod/chargen/set_occupant(mob/living/carbon/human/occupant, silent)
	//Attempt to prevent dropping any held items when transfering
	if(occupant)
		for(var/atom/movable/thing in occupant.get_held_items())
			occupant.equip_to_storage(thing)
	. = ..()
	if(occupant)
		to_chat(occupant, SPAN_NOTICE("The [src] beeps: Launch procedure initiated. Please wait..."))
		addtimer(CALLBACK(src, /obj/machinery/cryopod/chargen/proc/send_to_outpost), 5 SECONDS)

/obj/machinery/cryopod/chargen/Process()
	return PROCESS_KILL

#undef STARTING_POINTS