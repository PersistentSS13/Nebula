#define STARTING_POINTS 30

/obj/machinery/cryopod/chargen/proc/send_to_outpost()
	if(!istype(occupant))
		return

	// Updating the mob's skills with the actual chargen choices.
	var/datum/skillset/mob_set = occupant.skillset
	var/datum/skillset/char = occupant.mind.chargen_skillset
	var/list/char_set = char.skill_list
	mob_set.skill_list = char_set.Copy()
	mob_set.default_value = char.default_value
	mob_set.points_remaining = 30
	mob_set.on_levels_change()
	
	to_chat(occupant, SPAN_NOTICE("You have an additional [STARTING_POINTS] skill points to apply to your character. Use the 'Adjust Skills' verb to do so"))

	var/obj/starter_book = occupant.mind.role.text_book_type 
	
	if(starter_book)
		to_chat(occupant, SPAN_NOTICE("You have brought with you a textbook related to your specialty. It can increase your skills temporarily by reading it, or permanently through dedicated study. It's highly valuable, so don't lose it!"))
		occupant.equip_to_slot_or_store_or_drop(new starter_book(occupant), slot_in_backpack_str)

	for(var/turf/T in GLOB.latejoin_cryo)
		if(locate(/mob) in T)
			continue
		occupant.forceMove(T)

/obj/machinery/cryopod/chargen/check_occupant_allowed(mob/M)
	var/allowed = M.mind.finished_chargen
	if(!allowed)
		to_chat(M, SPAN_NOTICE("The [src] beeps: Please finished your dossier on the terminal before proceeding to cryostasis."))
	return allowed

/obj/machinery/cryopod/chargen/set_occupant(var/mob/living/carbon/occupant, var/silent)
	. = ..()
	to_chat(occupant, SPAN_NOTICE("The [src] beeps: Launch procedure initiated. Please wait..."))
	addtimer(CALLBACK(src, /obj/machinery/cryopod/chargen/proc/send_to_outpost), 5 SECONDS)

/obj/machinery/cryopod/chargen/Process()
	// Do not apply stasis.

#undef STARTING_POINTS