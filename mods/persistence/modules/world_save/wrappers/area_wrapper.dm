/datum/wrapper/area
	wrapper_for = /area

	// Area details
	var/name
	var/list/turfs
	var/has_gravity

/datum/wrapper/area/on_serialize(var/area/A)
	key = "[A.type]"
	name = A.name

	// Code to remap Z for area turfs.
	turfs = list()
	for(var/turf in A.get_turf_coords())
		var/list/coords = splittext(turf, ",")
		var/z = coords[3]
		if(SSpersistence.serializer.nongreedy_serialize && !(z in SSpersistence.serializer.z_map))
			return null
		try
			z = SSpersistence.serializer.z_map[z]
		catch
			z = z // Ignore this terrible code.
		turfs += jointext(list(coords[1], coords[2], z), ",")

	has_gravity = A.has_gravity

/datum/wrapper/area/on_deserialize()
	// Check for areas that have already been deserialized to prevent duplicate areas.
	for(var/area/pre_area)
		if("[pre_area.type]" == key && pre_area.name == name)
			return pre_area

	var/area_type = text2path(key)
	var/area/A = new area_type()
	A.name = name
	A.has_gravity = has_gravity
 
	for(var/index in 1 to length(turfs))
		var/list/coords = splittext(turfs[index], ",")
		var/old_z = text2num(coords[3])
		var/new_z
		for(var/datum/persistence/load_cache/z_level/z_level in SSpersistence.serializer.resolver.z_levels)
			if(z_level.index == old_z)
				new_z = z_level.new_index
				break
		if(!new_z)
			return null // Invalid Z-Level
		var/turf/T = locate(text2num(coords[1]), text2num(coords[2]), new_z)
		A.contents.Add(T)
	return A
