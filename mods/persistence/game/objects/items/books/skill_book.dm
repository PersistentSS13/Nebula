#define MAX_TEXTBOOK_SKILLS   2
#define TEXTBOOK_COOLDOWN    20 HOURS

/obj/item/book/skill/verb/study()
	set name = "Study Intently"
	set category = "Object"
	set src in oview(1)

	if(!CanPhysicallyInteract(usr))
		return

	if(!skill)
		to_chat(usr, SPAN_WARNING("[title] doesn't have any content! What a ripoff!"))
		return
	if(!usr.skill_check(SKILL_LITERACY, SKILL_BASIC))
		to_chat(usr, SPAN_WARNING("Since you don't know how to read, you can hardly study this textbook's subject matter."))
		return
	if(!usr.skill_check(skill, skill_req))
		to_chat(usr, SPAN_WARNING("[title] is too advanced for you!"))
		return
	if(usr.get_skill_value(skill) > skill_req)
		to_chat(usr, SPAN_WARNING("You already know everything [title] has to teach you!"))
		return
	var/datum/skillset/SS = usr.skillset
	var/skill_name = initial(skill.name)

	if(SS.last_read_time && (world.realtime < SS.last_read_time + TEXTBOOK_COOLDOWN))
		to_chat(usr, SPAN_WARNING("You can't imagine any more textbook reading right now. Best to give it a rest for the day."))
		return
	// Characters can only learn MAX_TEXTBOOK_SKILLS skills from books.
	if(length(usr.skillset.textbook_skills) >= MAX_TEXTBOOK_SKILLS && !usr.skillset.textbook_skills[skill])
		to_chat(usr, SPAN_WARNING("Your mind aches at the thought of studying another subject so closely. Best to stick to what you know."))
		return
	else if(!(skill in usr.skillset.textbook_skills))
		if(alert("Are you sure you'd like to study the subject [skill_name] intently? You can only do this for [MAX_TEXTBOOK_SKILLS] skills so choose wisely!", "Study Intently", "Yes", "No") == "No")
			return

	to_chat(usr, SPAN_NOTICE("You start reading [title] intently, taking mental notes as you go..."))
	if(do_after(usr, 30 SECONDS, src))
		to_chat(usr, SPAN_NOTICE("You decide to mark your place in \the [src] and stop reading. That's enough for one day!"))
		SS.add_textbook_reading(skill)

/obj/item/book/skill/custom/study()
	if(progress != 6)
		to_chat(usr, SPAN_WARNING("This textbook isn't finished yet!"))
		return
	
	. = ..()