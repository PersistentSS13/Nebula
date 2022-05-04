/datum/category_collection/player_setup_collection/New(var/datum/preferences/preferences)
	src.preferences = preferences
	categories = new()
	categories_by_name = new()
	for(var/category_type in typesof(category_group_type))
		if(category_type in preferences.skipped_menus)
			continue
		var/datum/category_group/category = category_type
		if(initial(category.name))
			category = new category(src)
			categories += category
			categories_by_name[category.name] = category
	categories = sortTim(categories, /proc/cmp_category_groups)
	selected_category = categories[1]