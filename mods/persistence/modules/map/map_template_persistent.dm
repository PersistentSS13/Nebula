////////////////////////////////////////////////
// Persistent Planetoid Map Template
////////////////////////////////////////////////

///Planetoid map template for the main planet map that skips loading from file when a save exists.
/datum/map_template/planetoid/persistent
	name = "persistent planetoid"

///Whether we should attempt loading the maps for the template, or skip it.
/datum/map_template/planetoid/persistent/proc/should_load_from_map()
	return !SSpersistence.SaveExists()

/datum/map_template/planetoid/persistent/load_new_z(no_changeturf, centered)
	if(!should_load_from_map())
		report_progress_serializer("Skipped loading map for persistent map template [name] on z [world.maxz], since we got a save!")
		loaded++ //Always mark it as loaded
		return WORLD_CENTER_TURF(world.maxz)
	. = ..()

////////////////////////////////////////////////
// Persistent Map Template
////////////////////////////////////////////////

/datum/map_template/persistent
	template_parent_type = /datum/map_template/persistent

///Whether we should attempt loading the maps for the template, or skip it.
/datum/map_template/persistent/proc/should_load_map()
	return !SSpersistence.SaveExists()

/datum/map_template/persistent/load_new_z(no_changeturf, centered)
	if(!should_load_map())
		report_progress_serializer("Skipped loading map for persistent map template [name] on z [world.maxz], since we got a save!")
		loaded++ //Always mark it as loaded
		return WORLD_CENTER_TURF(world.maxz)
	. = ..()

// ////////////////////////////////////////////////
// // Persistent Planet Template
// ////////////////////////////////////////////////

// ///Persistent map loaded from file once, then from save. This version is for planetary templates
// /datum/map_template/persistent/planet
// 	///The type of the planetoid data to spawn for this planet
// 	var/planetoid_type

// /datum/map_template/persistent/planet/load_new_z(no_changeturf, centered)
// 	//Spawn the planetoid data before we generate the level, so the level_data can grab the correct info
// 	var/datum/planetoid_data/planet_data = new planetoid_type
// 	SSmapping.register_planetoid(planet_data)
// 	var/old_maxz = world.maxz
// 	. = ..()
// 	for(var/Z = (old_maxz + 1) to world.maxz)
// 		SSmapping.register_planetoid_levels(Z, planet_data)
