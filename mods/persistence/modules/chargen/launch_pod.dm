#define STARTING_POINTS 30

/obj/machinery/cryopod/chargen/proc/send_to_outpost()
	if(!istype(occupant))
		return

	// Updating the mob's skills with the actual chargen choices.
	var/mob/living/carbon/user = occupant
	var/datum/skillset/mob_set = occupant.skillset
	var/datum/skillset/char = occupant.mind.chargen_skillset
	var/list/char_set = char.skill_list
	mob_set.skill_list = char_set.Copy()
	mob_set.default_value = char.default_value
	mob_set.points_remaining = 30
	mob_set.on_levels_change()
	
	to_chat(user, SPAN_NOTICE("You have an additional [STARTING_POINTS] skill points to apply to your character. Use the 'Adjust Skills' verb to do so"))

	var/obj/starter_book = user.mind.role.text_book_type 
	
	if(starter_book)
		to_chat(user, SPAN_NOTICE("You have brought with you a textbook related to your specialty. It can increase your skills temporarily by reading it, or permanently through dedicated study. It's highly valuable, so don't lose it!"))
		user.equip_to_slot_or_store_or_drop(new starter_book(user), slot_in_backpack_str)

	// Find the Outreach network, and create the crew record for convenience.
	var/datum/computer_file/report/crew_record/CR = new()
	GLOB.all_crew_records.Add(CR)
	CR.load_from_mob(user)
	for(var/network_id in SSnetworking.networks)
		var/datum/computer_network/network = SSnetworking.networks[network_id]
		if(network.network_id == "outreach")
			network.store_file(CR, MF_ROLE_CREW_RECORDS)
			break

	for(var/turf/T in GLOB.latejoin_cryo)
		if(!(locate(/mob) in T))
			go_out()
			user.forceMove(T)
			return
	
	// If we didn't find a empty turf, put them on a filled one	
	var/turf/T = pick(GLOB.latejoin_cryo)
	if(T)
		go_out()
		user.forceMove(T)
	else
		to_chat(user, SPAN_DANGER("UNABLE TO FIND SUITABLE LOCATION, CONTACT AN ADMIN!"))
		message_admins(SPAN_DANGER("UNABLE TO FIND SUITABLE LOCATION FOR NEW PLAYERS! CREATE A CRYOPOD."))

/obj/machinery/cryopod/chargen/check_occupant_allowed(mob/M)
	var/allowed = M.mind.finished_chargen
	if(!allowed)
		to_chat(M, SPAN_NOTICE("The [src] beeps: Please finished your dossier on the terminal before proceeding to cryostasis."))
	return allowed

/obj/machinery/cryopod/chargen/set_occupant(mob/living/carbon/occupant, silent)
	. = ..()

	if(occupant)
		to_chat(occupant, SPAN_NOTICE("The [src] beeps: Launch procedure initiated. Please wait..."))
		addtimer(CALLBACK(src, /obj/machinery/cryopod/chargen/proc/send_to_outpost), 5 SECONDS)

/obj/machinery/cryopod/chargen/Process()
	// Do not apply stasis.

#undef STARTING_POINTS