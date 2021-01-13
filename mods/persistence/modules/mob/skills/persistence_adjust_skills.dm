#define TIME_PER_POINT       30 MINUTES
#define MAX_SKILL_POINTS    100

/datum/skillset
	var/time_active = 0								 // Players get points over time.
	var/points_remaining = 0
	var/total_points_added = 0

	var/datum/skillset/temp_skillset				 // Temporary skillset while adjusting skills.

	var/list/min_skill_level = list()				 // Minimum level that a skill cannot go beneath. 
	var/list/textbook_skills = list()				 // Skills that are being learned via textbook. Maximum MAX_TEXTBOOK_SKILLS per character.

	var/last_read_time = 0

	literacy_charges = 999							 // No need to limit the amount of textbooks one mob can make. This var should not be saved.

/datum/skillset/proc/set_skillset_min()				 // Outside of Persistence skills are tied to job preferences, so this should be kept here.
	for(var/decl/hierarchy/skill/S in GLOB.skills)
		skill_list[S.type] = SKILL_MIN
	on_levels_change()

/datum/skillset/proc/add_point()
	if(total_points_added >= MAX_SKILL_POINTS)
		return

	points_remaining++
	if(temp_skillset) temp_skillset.points_remaining++
	total_points_added++
	switch(total_points_added)
		if(0 to 25)
			to_chat(owner, SPAN_NOTICE("You're beginning to understand your surroundings a bit more. <b>You feel like your skills have improved</b>."))
		if(26 to 50)
			to_chat(owner, SPAN_NOTICE("You're beginning to feel comfortable in the Outreach system. <b>You feel like your skills have improved</b>."))
		if(51 to 75)
			to_chat(owner, SPAN_NOTICE("You're becoming acclimated to your work in the Outreach system. <b>You feel like your skills have improved</b>."))
		if(76 to MAX_SKILL_POINTS)
			to_chat(owner, SPAN_NOTICE("You're becoming capable in a wide variety of fields and are a certain boon to the Outreach system. <b>You feel like your skills have improved</b>."))

/datum/skillset/proc/add_textbook_reading(var/decl/hierarchy/skill/S)
	if(length(textbook_skills) >= MAX_TEXTBOOK_SKILLS && !textbook_skills[S])
		return
	if(skill_list[S] == SKILL_MAX) // No more larnin' from textbooks if you're already maxed out
		return
	if(last_read_time && (world.realtime < last_read_time + TEXTBOOK_COOLDOWN))
		return
	
	var/skill_name = initial(S.name)
	textbook_skills[S]++
	last_read_time = world.realtime
	if(textbook_skills[S] >= 5)
		textbook_skills[S] = 0
		skill_list[S]++
		switch(skill_list[S])
			if(SKILL_BASIC)
				to_chat(owner, SPAN_NOTICE("You are beginning to grasp the fundamentals of [skill_name]. You feel like you're ready to put some of this textbook into practice!"))
			if(SKILL_ADEPT)
				to_chat(owner, SPAN_NOTICE("You are beginning to synthesize your conceptual understanding of [skill_name] with its practical applications!"))
			if(SKILL_EXPERT)
				to_chat(owner, SPAN_NOTICE("Your knowledge of [skill_name] is extremely robust. You feel like you're now able to perform the vast majority of tasks in this field!"))
			if(SKILL_PROF)
				to_chat(owner, SPAN_NOTICE("As you close the textbook, you feel like you've learned all there is to know on the subject of [skill_name]. Certainly you're now a professional in your field."))

/datum/skillset/proc/gain_time(var/dt)
	time_active += dt
	var/time_coeff = (total_points_added <= MAX_SKILL_POINTS/2) ? 1 : 2
	if(time_active >= time_coeff*TIME_PER_POINT)
		add_point()
		time_active = 0

/mob/living/verb/adjust_skills()
	set category = "IC"
	set name = "Adjust your skills"

	skillset.temp_skillset = null // Create a new temporary skillset whenever it's reopened.
	adjust_skills_ui()

/mob/living/proc/adjust_skills_ui()
	if(!skillset.temp_skillset)
		skillset.temp_skillset = new()
		var/list/curr_list = skillset.skill_list
		skillset.temp_skillset.skill_list = curr_list.Copy()
		skillset.temp_skillset.min_skill_level = curr_list.Copy()
		skillset.temp_skillset.points_remaining = skillset.points_remaining
	var/datum/browser/panel = new(usr, "skill_selection", "Skill Selection: [src.name]", 770, 850, src)
	panel.set_content(p_generate_skill_content(src))
	panel.open()

/mob/living/OnSelfTopic(href_list)
	if(href_list["hit_skill_button"])
		var/decl/hierarchy/skill/S = locate(href_list["hit_skill_button"])
		if(!istype(S))
			return TOPIC_HANDLED
		var/value = text2num(href_list["newvalue"])
		p_update_skill_value(S, usr.skillset.temp_skillset, value)
		adjust_skills_ui() // Refresh
		return TOPIC_HANDLED

	else if(href_list["skillinfo"])
		var/decl/hierarchy/skill/S = locate(href_list["skillinfo"])
		if(!istype(S))
			return TOPIC_HANDLED
		var/HTML = list()
		HTML += "<h2>[S.name]</h2>"
		HTML += "[S.desc]<br>"
		var/i
		for(i=1, i <= length(S.levels), i++)
			var/level_name = S.levels[i]
			HTML +=	"<br><b>[level_name]</b>: [S.levels[level_name]]<br>"
		show_browser(usr, jointext(HTML, null), "window=\ref[usr]skillinfo")
		return TOPIC_HANDLED
	
	else if(href_list["finalize_skills"])
		var/confirm = alert(usr, "Are you sure you want to make the following changes to your skills? This cannot be undone!", "Confirm", "Yes", "No")
		if(confirm && skillset.temp_skillset)
			skillset.points_remaining = skillset.temp_skillset.points_remaining
			skillset.skill_list = skillset.temp_skillset.skill_list
			skillset.on_levels_change()
			skillset.temp_skillset = null
			adjust_skills_ui()
			return TOPIC_HANDLED
		return TOPIC_HANDLED
	return ..()

// Largely taken from skill_selection.dm. Modified to remove references to jobs.
/proc/p_generate_skill_content(var/mob/living/M)
	var/dat = list()
	var/datum/skillset/SS = M.skillset.temp_skillset
	dat += "<body>"
	dat += "<style>.Selectable,.Current,.Unavailable,.Toohigh{border: 1px solid #161616;padding: 1px 4px 1px 4px;margin: 0 2px 0 0}</style>"
	dat += "<style>.Selectable,a.Selectable{background: #40628a}</style>"
	dat += "<style>.Current,a.Current{background: #2f943c}</style>"
	dat += "<style>.Unavailable{background: #d09000}</style>"
	dat += "<tt><center>"
	dat += "<b>Skill points remaining: [SS.points_remaining].</b><hr>"
	if(SS.skill_list == M.skillset.skill_list)
		dat += "<b>Finalize skills: <span class ='Unavailable'>Finalize</span></b>"
	else
		dat += "<b>Finalize skills: <a href='?src=\ref[usr];finalize_skills=1'>Finalize</a></b>"
	dat += "<hr>"
	dat += "</center></tt>"

	dat += "<table>"
	var/decl/hierarchy/skill/skill = decls_repository.get_decl(/decl/hierarchy/skill)
	for(var/decl/hierarchy/skill/cat in skill.children)
		dat += "<tr><th colspan = 4><b>[cat.name]</b>"
		dat += "</th></tr>"
		for(var/decl/hierarchy/skill/S in cat.children)
			dat += p_get_skill_row(M, S, SS)
			for(var/decl/hierarchy/skill/perk in S.children)
				dat += p_get_skill_row(M, perk, SS)
	dat += "</table>"
	return JOINTEXT(dat)

/proc/p_get_skill_row(var/mob/living/usr, decl/hierarchy/skill/S, var/datum/skillset/SS)
	var/list/dat = list()
	var/level = SS.get_value(S.type)	//the current skill level
	var/cap = p_get_max_affordable(S, SS) //if selecting the skill would make you overspend, it won't be shown
	dat += "<tr style='text-align:left;'>"
	dat += "<th><a href='?src=\ref[usr];skillinfo=\ref[S]'>[S.name] ([p_get_spent_points(S, SS)])</a></th>"
	for(var/i = SKILL_MIN, i <= SKILL_MAX, i++)
		dat += p_skill_to_button(usr, S, SS, level, i, SS.min_skill_level[S.type], cap)
	dat += "</tr>"
	return JOINTEXT(dat)

/proc/p_get_max_affordable(decl/hierarchy/skill/S, var/datum/skillset/SS)
	var/current_level = 0
	current_level += SS.get_value(S.type)
	var/max = SKILL_MAX						// Ignoring the natural limits on skills without having the respective job.
	var/budget = SS.points_remaining
	. = max
	for(var/i=current_level+1, i <= max, i++)
		if(budget - S.get_cost(i) < 0)
			return i-1
		budget -= S.get_cost(i)

/proc/p_skill_to_button(var/mob/living/usr, decl/hierarchy/skill/S, var/datum/skillset/SS, current_level, selection_level, min, max)
	var/offset = S.prerequisites ? S.prerequisites[S.parent.type] - 1 : 0
	var/effective_level = selection_level - offset
	if(effective_level <= 0 || effective_level > length(S.levels))
		return "<th></th>"
	var/level_name = S.levels[effective_level]
	var/cost = S.get_cost(effective_level)
	var/button_label = "[level_name] ([cost])"
	if(effective_level < min)
		return "<th><span class='Unavailable'>[button_label]</span></th>"
	else if(effective_level < current_level)
		return "<th>[p_add_skill_link(usr, S, SS, button_label, "'Current'", effective_level)]</th>"
	else if(effective_level == current_level)
		return "<th><span class='Current'>[button_label]</span></th>"
	else if(effective_level <= max)
		return "<th>[p_add_skill_link(usr, S, SS, button_label, "'Selectable'", effective_level)]</th>"
	else
		return "<th><span class='Toohigh'>[button_label]</span></th>"

/proc/p_add_skill_link(var/mob/living/usr, decl/hierarchy/skill/S, var/datum/skillset/SS, text, style, value)
	if(p_check_skill_prerequisites(S, SS))
		return "<a class=[style] href='?src=\ref[usr];hit_skill_button=\ref[S];newvalue=[value]'>[text]</a>"
	return text

/proc/p_get_spent_points(decl/hierarchy/skill/S, var/datum/skillset/SS)
	return p_get_level_cost(S, SS.get_value(S.type))

/proc/p_get_level_cost(decl/hierarchy/skill/S, level)
	. = 0
	for(var/i=SKILL_MIN, i <= level, i++)
		. += S.get_cost(i)

/proc/p_check_skill_prerequisites(decl/hierarchy/skill/S, var/datum/skillset/SS)
	if(!S.prerequisites)
		return TRUE
	for(var/skill_type in S.prerequisites)
		var/decl/hierarchy/skill/prereq = decls_repository.get_decl(skill_type)
		var/value = SKILL_MIN + SS.get_value(prereq.type)
		if(value < S.prerequisites[skill_type])
			return FALSE
	return TRUE

/proc/p_purge_skills_missing_prerequisites(var/datum/skillset/SS)
	for(var/decl/hierarchy/skill/S in SS.skill_list)
		if(!p_check_skill_prerequisites(S, SS))
			p_clear_skill(S, SS)
			.() // restart checking from the beginning, as after doing this we don't know whether what we've already checked is still fine.
			return

/proc/p_clear_skill(decl/hierarchy/skill/S, var/datum/skillset/SS)
	var/freed_points = p_get_level_cost(S, SS.get_value(S.type))
	SS.points_remaining += freed_points
	SS.skill_list[S.type] = SKILL_MIN
	SS.on_levels_change()

/proc/p_update_skill_value(decl/hierarchy/skill/S, var/datum/skillset/SS, new_level)
	if(!isnum(new_level) || (round(new_level) != new_level))
		return											//Checks to make sure we were fed an integer.
	if(!p_check_skill_prerequisites(S, SS))
		return

	var/current_value = p_get_level_cost(S, SS.get_value(S.type))
	var/new_value = p_get_level_cost(S, new_level)

	if((new_level < SS.min_skill_level[S.type]) || (new_level > SKILL_MAX) || (SS.points_remaining + current_value - new_value < 0))
		return											//Checks if the new value is actually allowed.
														//None of this should happen normally, but this avoids client attacks.
	SS.skill_list[S.type] = new_level
	SS.on_levels_change()
	SS.points_remaining += (current_value - new_value)
	p_purge_skills_missing_prerequisites(SS)

#undef TIME_PER_POINT
#undef MAX_SKILL_POINTS