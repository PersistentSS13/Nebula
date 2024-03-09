
/**

 */
/datum/nano_module/chargen
	name            = "chargen form"
	available_to_ai = FALSE

	///The ui template
	var/ui_template = "chargen.tmpl"
	///The actual player character this chargen form instance is setup for.
	var/mob/living/player
	///The chargen_area currently associated with the player
	var/area/chargen/chargen_room
	///The section of the form to display
	var/active_section = "origin"

/datum/nano_module/chargen/New(datum/host, topic_manager, mob/living/_player, area/chargen/_room)
	. = ..(host, topic_manager)
	player       = _player
	chargen_room = _room

/**

 */
/datum/nano_module/chargen/Topic(var/mob/user, var/href_list, var/datum/topic_state/state)
	. = TOPIC_REFRESH

	switch(href_list["action"])
		if("toggle_stack")
			player.mind.set_spawn_with_stack(player.mind.should_spawn_with_stack())

		if("choose_origin")
			active_section = "origin"

		if("choose_role")
			active_section = "role"

		if("submit")
			if(!SSchargen.validate_chargen_form_submission(player))
				return
			SSchargen.set_player_chargen_state(player, CHARGEN_STATE_FORM_COMPLETE)

		if("unsubmit")
			//Setting the chargen state will update the player mind
			SSchargen.set_player_chargen_state(player, CHARGEN_STATE_FORM_INCOMPLETE)

		if("confirm_origin")
			SSchargen.set_player_chargen_origin(player, href_list["ref"])

		if("confirm_role")
			SSchargen.set_player_chargen_role(player, href_list["ref"])


/datum/nano_module/chargen/proc/ui_data_fill_lists(mob/user, ui_key)
	var/decl/hierarchy/chargen/origin/origins = GET_DECL(/decl/hierarchy/chargen/origin)
	var/decl/hierarchy/chargen/role/roles     = GET_DECL(/decl/hierarchy/chargen/role)
	. = list()

	for(var/decl/hierarchy/chargen/D in (roles.children + origins.children))
		var/list/fields = list(
			"name" = D.name,
			"ref" = D.ID,
			"skills" = list(),
			"whitelist_only" = D.whitelist_only,
			"active" = ((player.mind.origin && D == player.mind.origin) || (player.mind.role && D == player.mind.role))
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

/datum/nano_module/chargen/ui_data(mob/user, ui_key)
	if(!istype(player.mind.chargen_skillset))
		player.mind.chargen_skillset = new(player)
		for(var/decl/hierarchy/skill in global.skills)
			player.mind.chargen_skillset.skill_list[skill.type] = 1
		player.mind.chargen_skillset.skill_list[SKILL_HAULING] = SKILL_BASIC
		player.mind.chargen_skillset.skill_list[SKILL_LITERACY] = SKILL_BASIC
	. = player.mind.chargen_skillset.get_nano_data(FALSE)

	.["active"]   = active_section
	.["finished"] = player.mind.finished_chargen
	.["map_name"] = global.using_map.station_name
	.["stack"]    = player.mind.chargen_stack
	.["origin"]   = istype(player.mind.origin) ? player.mind.origin.name : "Not set"
	.["role"]     = istype(player.mind.role)   ? player.mind.role.name   : "Not set"

	// Populate role & origin choices.
	. += ui_data_fill_lists(user, ui_key)

/datum/nano_module/chargen/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, ui_template, name, 1024, 780)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
