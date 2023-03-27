///Map template for the main map that skips loading from file when a save exists.
/datum/map_template/persistent
	template_flags       = TEMPLATE_FLAG_SPAWN_GUARANTEED | TEMPLATE_FLAG_NO_RUINS
	modify_tag_vars      = FALSE
	template_categories  = list(MAP_TEMPLATE_CATEGORY_MAIN_SITE) //Templates must have a category, or they won't spawn
	template_parent_type = /datum/map_template/persistent

/datum/map_template/persistent/load_new_z(no_changeturf, centered)
	if(SSpersistence.SaveExists())
		report_progress_serializer("Skipped loading map for persistent map template [name] on z [world.maxz], since we got a save!")
		loaded++ //Always mark it as loaded
		return locate(world.maxx/2, world.maxy/2, world.maxz)
	. = ..()

/datum/map_template/persistent/load(turf/T, centered)
	CRASH("Persistent level templates cannot be loaded on an existing level!")

///Loads main sites templates. Main sites template are not always saved btw, and may still be loaded when there is saved data
/datum/map/proc/build_main_sites()
	report_progress("Loading main sites...")
	var/list/sites_by_spawn_weight = list()
	var/list/sites_templates = SSmapping.get_templates_by_category(MAP_TEMPLATE_CATEGORY_MAIN_SITE)

	for (var/site_name in sites_templates)
		var/datum/map_template/site = sites_templates[site_name]
		if((site.template_flags & TEMPLATE_FLAG_SPAWN_GUARANTEED) && site.load_new_z()) // no check for budget, but guaranteed means guaranteed
			report_progress("Processed guaranteed main site [site]!")
			away_site_budget -= site.get_template_cost()
			continue
		sites_by_spawn_weight[site] = site.get_spawn_weight()

	while (away_site_budget > 0 && sites_by_spawn_weight.len)
		var/datum/map_template/selected_site = pickweight(sites_by_spawn_weight)
		if (!selected_site)
			break
		sites_by_spawn_weight -= selected_site
		var/site_cost = selected_site.get_template_cost()
		if(site_cost > away_site_budget)
			continue
		if (selected_site.load_new_z())
			report_progress("Loaded main site [selected_site]!")
			away_site_budget -= site_cost

	report_progress("Finished loading main sites, remaining budget [away_site_budget], remaining sites [sites_by_spawn_weight.len]")

