//Simple structure displaying a nanoui on interact
/obj/structure/fake_computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = TRUE
	anchored = TRUE

/obj/structure/fake_computer/attack_hand(mob/user)
	ui_interact(user)

/obj/structure/fake_computer/on_update_icon()
	cut_overlays()
	icon = initial(icon)
	icon_state = initial(icon_state)

	//Slap on the screen overlay
	var/image/screen_overlay = image(icon, "generic", layer)
	screen_overlay.appearance_flags |= RESET_COLOR
	add_overlay(screen_overlay)

	//Slap on the keyboard overlay
	var/image/keyboard_overlay = image(icon, "generic_key", layer)
	keyboard_overlay.appearance_flags |= RESET_COLOR
	add_overlay(keyboard_overlay)

	//Light it up
	set_light(2, 1, light_color)

/obj/structure/fake_computer/CouldUseTopic(var/mob/user)
	..()
	playsound(src, "keyboard", 40)

//Chargen console
/obj/structure/fake_computer/chargen
	var/active_section = "origin"
	should_save = FALSE

/obj/structure/fake_computer/chargen/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)
	. = TOPIC_REFRESH

	var/datum/skillset/skillset = user.mind.chargen_skillset
	var/decl/hierarchy/chargen/role/role = user.mind.role

	switch(href_list["action"])
		if("choose_role")
			active_section = "role"
		if("submit")
			if(isnull(user.mind.role))
				to_chat(user, SPAN_NOTICE("The console beeps: Application incomplete. Please enter a role to proceed."))
				return
			user.mind.finished_chargen = TRUE
			var/area/A = get_area(src)
			var/obj/machinery/cryopod/chargen/pod = locate() in A
			var/obj/chargen/status_light/slight = locate() in A
			if(pod)
				pod.ready_for_mingebag()
			if(slight)
				slight.completed_chargen = TRUE
				slight.update_icon()
		if("unsubmit")
			user.mind.finished_chargen = FALSE

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

/obj/structure/fake_computer/chargen/proc/build_ui_data(var/mob/user)
	if(!istype(user.mind.chargen_skillset))
		user.mind.chargen_skillset = new(user)
		for(var/decl/hierarchy/skill in global.skills)
			user.mind.chargen_skillset.skill_list[skill.type] = 1
		user.mind.chargen_skillset.skill_list[SKILL_HAULING] = SKILL_BASIC
		user.mind.chargen_skillset.skill_list[SKILL_LITERACY] = SKILL_ADEPT
	. = user.mind.chargen_skillset.get_nano_data(FALSE)
	var/decl/hierarchy/chargen/role/role = user.mind.role
	.["active"] = role
	.["finished"] = user.mind.finished_chargen
	.["map_name"] = global.using_map.station_name
	.["role"] = istype(user.mind.role) ? user.mind.role.name : "Not set"
	.["role_desc"] = istype(user.mind.role) ? user.mind.role.desc : "Not set"
	// Populate role & origin choices.
	.["roles"] = list()
	var/decl/hierarchy/chargen/role/roles = GET_DECL(/decl/hierarchy/chargen/role)

	for(var/decl/hierarchy/chargen/D in roles.children)
		var/list/fields = list(
			"name" = D.name,
			"ref" = D.ID,
			"skills" = list(),
			"whitelist_only" = D.whitelist_only,
			"active" = (user.mind.role && D == user.mind.role)
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
		.["roles"] += list(fields)

/obj/structure/fake_computer/chargen/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = build_ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "chargen.tmpl", name, 800, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
