/datum/wrapper/map_data
	wrapper_for = /obj/effect/landmark/map_data

	var/height
	var/loc

/datum/wrapper/map_data/on_serialize(obj/effect/landmark/map_data/M)
	key = "[M.type]"

	var/turf/T = get_turf(M)
	height = M.height
	loc = "[T.x],[T.y],[T.z]"
	
/datum/wrapper/map_data/on_deserialize()
	var/list/coords = splittext(loc, ",")
	var/turf/T = locate(text2num(coords[1]), text2num(coords[2]), text2num(coords[3]))
	return new /obj/effect/landmark/map_data(T, text2num(height))
	