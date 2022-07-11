/datum/wrapper/area
	wrapper_for = /area

	// Area details
	var/name

/datum/wrapper/area/on_serialize(var/area/A, var/serializer/curr_serializer)
	key = "[A.type]"
	name = A.name

/datum/wrapper/area/on_deserialize(var/serializer/curr_serializer)
	// Check for areas that have already been deserialized to prevent duplicate areas.
	for(var/area/pre_area in global.areas)
		if("[pre_area.type]" == key && pre_area.name == name)
			return pre_area
	
	// Couldn't find the area, create it (without turfs)
	var/new_type = text2path(key)
	var/area/A = new new_type
	A.name = name
	return A