// Override event generation to ensure that events only get randomly placed on unsaved turfs.
/decl/overmap_event_handler/create_events(var/z_level, var/overmap_size, var/number_of_events)
	// Acquire the list of not-yet utilized overmap turfs on this Z-level
	var/list/candidate_turfs = list()

	for(var/turf/T in block(locate(OVERMAP_EDGE, OVERMAP_EDGE, z_level),locate(overmap_size - OVERMAP_EDGE, overmap_size - OVERMAP_EDGE,z_level)))
		if(istype(T, /turf/unsimulated/map/hazardous))
			candidate_turfs |= T

	for(var/i = 1 to number_of_events)
		if(!candidate_turfs.len)
			break
		var/overmap_event_type = pick(subtypesof(/datum/overmap_event))
		var/datum/overmap_event/datum_spawn = new overmap_event_type

		var/list/event_turfs = acquire_event_turfs(datum_spawn.count, datum_spawn.radius, candidate_turfs, datum_spawn.continuous)
		candidate_turfs -= event_turfs

		for(var/event_turf in event_turfs)
			var/type = pick(datum_spawn.hazards)
			new type(event_turf)

		qdel(datum_spawn)

/obj/effect/overmap/event/meteor
	var/decl/asteroid_class/class // Determines material make up of asteroid when using the asteroid magnet.
	var/spent = FALSE			  // Whether or not the asteroid field has been harvested yet.

/obj/effect/overmap/event/meteor/get_scan_data(mob/user)
	return desc + (class ? "<br> You detect \a [class.name] inside the asteroid field." : "") 

/obj/effect/overmap/event/meteor/Initialize()
	. = ..()
	if(!class)
		var/list/classes = decls_repository.get_decls_of_subtype(/decl/asteroid_class/)
		var/list/weighted_classes = list()
		for(var/c_type in classes)
			var/decl/asteroid_class/C = decls_repository.get_decl(c_type)
			weighted_classes[c_type] = C.weight
		class = pickweight(weighted_classes)