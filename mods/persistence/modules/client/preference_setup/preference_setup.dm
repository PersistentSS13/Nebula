/datum/category_collection/player_setup_collection
	var/static/list/hidden_categories = list(\
		/datum/category_group/player_setup_category/appearance_preferences,
		/datum/category_group/player_setup_category/occupation_preferences,
		/datum/category_group/player_setup_category/record_preferences,
	)

/datum/category_collection/player_setup_collection/header()
	var/dat = ""
	for(var/datum/category_group/player_setup_category/PS in categories)
		if(is_type_in_list(PS, hidden_categories))
			continue //Skip categories we don't wanna display
		if(PS == selected_category)
			dat += "[PS.name] "	// TODO: Check how to properly mark a href/button selected in a classic browser window
		else
			dat += "<a href='?src=\ref[src];category=\ref[PS]'>[PS.name]</a> "
	return dat