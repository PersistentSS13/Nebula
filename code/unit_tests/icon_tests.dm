/datum/unit_test/icon_test
	name = "ICON STATE template"
	template = /datum/unit_test/icon_test

/datum/unit_test/icon_test/item_modifiers_shall_have_icon_states
	name = "ICON STATE - Item Modifiers Shall Have Icon Sates"
	var/list/icon_states_by_type

/datum/unit_test/icon_test/item_modifiers_shall_have_icon_states/start_test()
	var/list/bad_modifiers = list()
	var/item_modifiers = list_values(decls_repository.get_decls(/decl/item_modifier))

	for(var/im in item_modifiers)
		var/decl/item_modifier/item_modifier = im
		for(var/type_setup_type in item_modifier.type_setups)
			var/list/type_setup = item_modifier.type_setups[type_setup_type]
			var/list/icon_states = icon_states_by_type[type_setup_type]

			if(!icon_states)
				var/obj/item/I = type_setup_type
				icon_states = icon_states(initial(I.icon))
				LAZYSET(icon_states_by_type, type_setup_type, icon_states)

			if(!(type_setup["icon_state"] in icon_states))
				bad_modifiers += type_setup_type

	if(bad_modifiers.len)
		fail("Item modifiers with missing icon states: [english_list(bad_modifiers)]")
	else
		pass("All item modifiers have valid icon states.")
	return 1

/datum/unit_test/icon_test/signs_shall_have_existing_icon_states
	name = "ICON STATE - Signs shall have existing icon states"
	var/list/skip_types = list(
		// Posters use a decl to set their icon and handle their own validation.
		/obj/structure/sign/poster
	)

/datum/unit_test/icon_test/signs_shall_have_existing_icon_states/start_test()
	var/list/failures = list()
	for(var/sign_type in typesof(/obj/structure/sign))

		var/obj/structure/sign/sign = sign_type
		if(TYPE_IS_ABSTRACT(sign))
			continue

		var/skip = FALSE
		for(var/skip_type in skip_types)
			if(ispath(sign_type, skip_type))
				skip = TRUE
				break
		if(skip)
			continue

		var/check_state = initial(sign.icon_state)
		if(!check_state)
			failures += "[sign] - null icon_state"
			continue
		var/check_icon = initial(sign.icon)
		if(!check_icon)
			failures += "[sign] - null icon_state"
			continue
		if(!check_state_in_icon(check_state, check_icon))
			failures += "[sign] - missing icon_state '[check_state]' in icon '[check_icon]"
	if(failures.len)
		fail("Signs with missing icon states:\n\t-[jointext(failures, "\n\t-")]")
	else
		pass("All signs have valid icon states.")
	return 1

/datum/unit_test/icon_test/floor_decals_shall_have_existing_icon_states
	name = "ICON STATE - Floor decals shall have existing icon states"
	var/static/list/excepted_types = list(
		/obj/effect/floor_decal/reset,
		/obj/effect/floor_decal/undo
	)
/datum/unit_test/icon_test/floor_decals_shall_have_existing_icon_states/start_test()
	var/list/failures = list()
	for(var/decal_type in typesof(/obj/effect/floor_decal))
		var/obj/effect/floor_decal/decal = decal_type
		if(TYPE_IS_ABSTRACT(decal) || is_path_in_list(decal_type, excepted_types))
			continue
		var/check_state = initial(decal.icon_state)
		if(!check_state)
			failures += "[decal] - null icon_state"
			continue
		var/check_icon = initial(decal.icon)
		if(!check_icon)
			failures += "[decal] - null icon_state"
			continue
		if(!check_state_in_icon(check_state, check_icon))
			failures += "[decal] - missing icon_state '[check_state]' in icon '[check_icon]"
	if(failures.len)
		fail("Decals with missing icon states:\n\t-[jointext(failures, "\n\t-")]")
	else
		pass("All decals have valid icon states.")
	return 1
