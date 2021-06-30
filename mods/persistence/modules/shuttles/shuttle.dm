// Override to fix a few bugs caused by variables not been added to the shuttle until after New()
/datum/shuttle
	should_save = FALSE

/datum/shuttle/New(map_hash, obj/effect/shuttle_landmark/initial_location)
	if(SSpersistence.loading_world)
		return
	. = ..()

/datum/shuttle/after_deserialize()
	. = ..()
	if(!display_name)
		display_name = name

	var/list/areas = list()
	if(!isnull(shuttle_area))
		if(!islist(shuttle_area))
			shuttle_area = list(shuttle_area)
		for(var/T in shuttle_area)
			var/area/A = locate(T)
			if(!istype(A))
				CRASH("Shuttle \"[name]\" couldn't locate area [T].")
			areas += A
		shuttle_area = areas

	if(!istype(current_location))
		current_location = SSshuttle.get_landmark(current_location)
	if(!istype(current_location))
		CRASH("Shuttle \"[name]\" could not find its starting location.")

	if(src.name in SSshuttle.shuttles)
		CRASH("A shuttle with the name '[name]' is already defined.")
	SSshuttle.shuttles[src.name] = src
	if(logging_home_tag)
		new /datum/shuttle_log(src)
	if(flags & SHUTTLE_FLAGS_PROCESS)
		SSshuttle.process_shuttles += src
	if(flags & SHUTTLE_FLAGS_SUPPLY)
		if(SSsupply.shuttle)
			CRASH("A supply shuttle is already defined.")
		SSsupply.shuttle = src