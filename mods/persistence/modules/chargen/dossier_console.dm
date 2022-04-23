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
		if("toggle_stack")
			user.mind.chargen_stack = !user.mind.chargen_stack
			return
		if("choose_origin")
			active_section = "origin"
		if("choose_role")
			active_section = "role"
		if("submit")
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
	.["map_name"] = global.using_map.station_name
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
	
