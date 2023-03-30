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
