/obj/machinery/computer/chargen
	var/ui_template = "chargen.tmpl"
	var/active_section = "origin"
	stat_immune = NOPOWER | NOSCREEN | NOINPUT | BROKEN
	construct_state = /decl/machine_construction/no_build

/obj/machinery/computer/chargen/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)
	. = TOPIC_REFRESH

	var/datum/skillset/skillset = user.mind.chargen_skillset
	var/decl/hierarchy/chargen/role/role = user.mind.role
	var/decl/hierarchy/chargen/origin/origin = user.mind.origin

	switch(href_list["action"])
		if("choose_age")
			var/new_age = sanitize(input(user, "Enter your age:", "Age", user.mind.age) as text|null)
			var/age_num = text2num(new_age)
			if(isnum(age_num))
				if(age_num < 18)
					to_chat(user, SPAN_NOTICE("The console beeps: You must be over the age of eighteen to participate in the [global.using_map.station_name] program."))
					return
				if(age_num > 120)
					to_chat(user, SPAN_NOTICE("The console beeps: You must be under the age of one hundred twenty to participate in the [global.using_map.station_name] program."))
					return
				user.mind.age = age_num
			else
				to_chat(user, SPAN_NOTICE("The console beeps: '[new_age]' is not a valid number. Please enter a valid number."))
		if("toggle_stack")
			user.mind.chargen_stack = !user.mind.chargen_stack
			return
		if("choose_origin")
			active_section = "origin"
		if("choose_role")
			active_section = "role"
		// if("choose_traits")
		// 	active_section = "traits"
		// if("choose_background")
		// 	active_section = "background"
		if("submit")
			if(user.mind.age < 18)
				to_chat(user, SPAN_NOTICE("The console beeps: Application incomplete. Please enter an age to proceed."))
				return
			if(user.mind.age > 120)
				to_chat(user, SPAN_NOTICE("The console beeps: Application incomplete. Please enter an age to proceed."))
				return
			if(isnull(user.mind.origin))
				to_chat(user, SPAN_NOTICE("The console beeps: Application incomplete. Please enter an origin to proceed."))
				return
			if(isnull(user.mind.role))
				to_chat(user, SPAN_NOTICE("The console beeps: Application incomplete. Please enter a role to proceed."))
				return
			user.mind.finished_chargen = TRUE
		if("unsubmit")
			user.mind.finished_chargen = FALSE
		if("confirm_origin")
			if(origin)
				for(var/skill in origin.skills)
					skillset.skill_list[skill] -= origin.skills[skill]

			var/decl/hierarchy/chargen/origin/origins = GET_DECL(/decl/hierarchy/chargen/origin)
			for(var/decl/hierarchy/chargen/D in origins.children)
				if(D.ID == href_list["ref"])
					// Found.
					user.mind.origin = D
					for(var/skill in D.skills)
						skillset.skill_list[skill] += D.skills[skill]

		if("confirm_role")
			if(role)
				for(var/skill in role.skills)
					skillset.skill_list[skill] -= role.skills[skill]

			var/decl/hierarchy/chargen/role/roles = GET_DECL(/decl/hierarchy/chargen/role)
			for(var/decl/hierarchy/chargen/D in roles.children)
				if(D.ID == href_list["ref"])
					// Found.
					user.mind.role = D
					for(var/skill in D.skills)
						skillset.skill_list[skill] += D.skills[skill]

/obj/machinery/computer/chargen/proc/build_ui_data()
	var/mob/user
	var/area/chargen/A = get_area(loc)
	if(istype(A))
		user = A.assigned_to
	else
		return list()

	if(!istype(user.mind.chargen_skillset))
		user.mind.chargen_skillset = new(user)
		for(var/decl/hierarchy/skill in global.skills)
			user.mind.chargen_skillset.skill_list[skill.type] = 1
		user.mind.chargen_skillset.skill_list[SKILL_HAULING] = SKILL_BASIC
		user.mind.chargen_skillset.skill_list[SKILL_LITERACY] = SKILL_BASIC
	. = user.mind.chargen_skillset.get_nano_data(FALSE)

	.["active"] = active_section
	.["finished"] = user.mind.finished_chargen
	.["age"] = user.mind.age
	.["map_name"] = global.using_map.station_name
	// .["species"] = usr.species.name
	.["stack"] = user.mind.chargen_stack
	.["origin"] = istype(user.mind.origin) ? user.mind.origin.name : "Not set"
	.["role"] = istype(user.mind.role) ? user.mind.role.name : "Not set"

	// Populate role & origin choices.
	.["origins"] = list()
	.["roles"] = list()
	var/decl/hierarchy/chargen/origin/origins = GET_DECL(/decl/hierarchy/chargen/origin)
	var/decl/hierarchy/chargen/role/roles = GET_DECL(/decl/hierarchy/chargen/role)
	for(var/decl/hierarchy/chargen/D in (roles.children + origins.children))
		var/list/fields = list(
			"name" = D.name,
			"ref" = D.ID,
			"skills" = list(),
			"whitelist_only" = D.whitelist_only,
			"active" = ((user.mind.origin && D == user.mind.origin) || (user.mind.role && D == user.mind.role))
		)

		for(var/skill in D.skills)
			if(!ispath(skill))
				continue
			var/decl/hierarchy/skill/S = GET_DECL(skill)
			if(!istype(S))
				continue
			fields["skills"] += S.name
		if(D.remaining_points_offset != 0)
			fields["skills"] += "Point offset: [D.remaining_points_offset >= 0 ? "+" : ""][D.remaining_points_offset]"
		fields["skills"] = english_list(fields["skills"])

		if(istype(D, /decl/hierarchy/chargen/origin))
			.["origins"] += list(fields)
		else
			.["roles"] += list(fields)


/obj/machinery/computer/chargen/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/chargen/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(ui_template)
		var/list/data = build_ui_data()
		ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
		if (!ui)
			ui = new(user, src, ui_key, ui_template, name, 800, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

/decl/machine_construction/no_build
	needs_board = "computer"
	cannot_print = TRUE

/obj/item/stock_parts/circuitboard/computer_chargen
	name = "circuitboard (dossier console)"
	build_path = /obj/machinery/computer/chargen
	
