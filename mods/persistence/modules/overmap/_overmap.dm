// Complete override since Persistence hotloads its maps, and most of these functions must be delayed.
/datum/overmap/New(var/_name)
	//#TODO: Find out if this is even necessary???

	name = _name

	if(!overmap_turf_type)
		overmap_turf_type = initial(overmap_turf_type)

	if(!name)
		PRINT_STACK_TRACE("Unnamed overmap datum instantiated: [type]")

	if(global.overmaps_by_name[name])
		PRINT_STACK_TRACE("Duplicate overmap datum instantiated: [type], [name], [overmaps_by_name[name]]")
	global.overmaps_by_name[name] = src

/datum/overmap/proc/late_initialize()
	generate_overmap()
	testing("Overmap build for [name] complete.")

	if(!assigned_z)
		PRINT_STACK_TRACE("Overmap datum generated null assigned z_level.")

	if(global.overmaps_by_z["[assigned_z]"])
		PRINT_STACK_TRACE("Duplicate overmap datum instantiated for z-level: [type], [assigned_z], [overmaps_by_name[name]]")
	global.overmaps_by_z["[assigned_z]"] = src

	for(var/event_type in subtypesof(/datum/overmap_event))
		var/datum/overmap_event/event = event_type
		if(initial(event.overmap_id) == name)
			LAZYADD(valid_event_types, event_type)