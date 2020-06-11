/datum/wrapper/area
	wrapper_for = /area

	// Area details
	var/name
	var/list/turfs
	var/has_gravity

/datum/wrapper/area/on_serialize(var/area/A)
	key = "[A.type]"
	name = A.name
	turfs = A.get_turf_coords()
	has_gravity = A.has_gravity

/datum/wrapper/area/on_deserialize()
	var/area_type = text2path(key)

	var/area/A = new area_type()
	A.name = name
	A.has_gravity = has_gravity
 
	var/list/new_turfs = list()
	for(var/index in 1 to length(turfs))
		var/list/coords = splittext(turfs[index], ",")
		var/turf/T = locate(text2num(coords[1]), text2num(coords[2]), text2num(coords[3]))
		new_turfs |= T
	A.contents.Add(new_turfs)
	return A
