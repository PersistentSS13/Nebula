#define STARTING_POINTS 30

/obj/machinery/cryopod/outreach
	name = "cryogenic freezer"

/obj/machinery/cryopod/outreach/Initialize()
	. = ..()
	
	global.latejoin_locations |= get_turf(src)
	global.latejoin_cryo_locations |= get_turf(src)

/obj/machinery/cryopod/chargen/proc/send_to_outpost()
	if(!istype(occupant))
		return

	var/mob/living/carbon/human/user = occupant
	if(occupant.mind.chargen_stack)
		var/obj/item/organ/internal/stack/charstack = new()
		var/obj/item/organ/O = occupant.get_organ(charstack.parent_organ)
		charstack.replaced(occupant, O)
		to_chat(user, SPAN_NOTICE("You have been provided with a Cortical Stack to act as an emergency revival tool."))

	// Updating the mob's skills with the actual chargen choices.
	var/datum/skillset/mob_set = occupant.skillset
	var/datum/skillset/char = occupant.mind.chargen_skillset
	var/list/char_set = char.skill_list
	mob_set.skill_list = char_set.Copy()
	mob_set.default_value = char.default_value
	mob_set.points_remaining = max(STARTING_POINTS + user.mind.origin.remaining_points_offset + user.mind.role.remaining_points_offset, 0)
	mob_set.on_levels_change()

	user.add_language(/decl/language/human/common)
	
	to_chat(user, SPAN_NOTICE("You have an additional [mob_set.points_remaining] skill points to apply to your character. Use the 'Adjust Skills' verb to do so"))

	var/obj/starter_book = user.mind.role.text_book_type 
	
	if(starter_book)
		to_chat(user, SPAN_NOTICE("You have brought with you a textbook related to your specialty. It can increase your skills temporarily by reading it, or permanently through dedicated study. It's highly valuable, so don't lose it!"))
		user.equip_to_slot_or_store_or_drop(new starter_book(user), slot_in_backpack_str)

	// Find the Outreach network, and create the crew record for convenience.
	var/datum/computer_file/report/crew_record/CR = new()
	global.all_crew_records.Add(CR)
	CR.load_from_mob(user)
	for(var/network_id in SSnetworking.networks)
		var/datum/computer_network/network = SSnetworking.networks[network_id]
		if(network.network_id == "kleibkhar")
			network.store_file(CR, MF_ROLE_CREW_RECORDS)
			break

	for(var/turf/T in global.latejoin_cryo_locations)
		if(!(locate(/mob) in T))
			go_out()
			user.forceMove(T)
			return
	
	// If we didn't find a empty turf, put them on a filled one	
	var/turf/T = pick(global.latejoin_cryo_locations)
	if(T)
		go_out()
		user.forceMove(T)
	else
		to_chat(user, SPAN_DANGER("UNABLE TO FIND SUITABLE LOCATION, CONTACT AN ADMIN!"))
		message_admins(SPAN_DANGER("UNABLE TO FIND SUITABLE LOCATION FOR NEW PLAYERS! CREATE A CRYOPOD."))

/obj/machinery/cryopod/chargen/check_occupant_allowed(mob/M)
	. = ..()
	if(!.)
		return
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
	return PROCESS_KILL

#undef STARTING_POINTS