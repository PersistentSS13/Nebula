/obj/abstract/map_data/should_save()
	return TRUE

/datum/wrapper/map_data
	wrapper_for = /obj/abstract/map_data

	var/height
	var/landmark_loc

/datum/wrapper/map_data/on_serialize(var/obj/abstract/map_data/M, var/serializer/curr_serializer)
	key = "[M.type]"

	var/turf/T = get_turf(M)
	height = M.height
	landmark_loc = "[T.x],[T.y],[T.z]"
	
/datum/wrapper/map_data/on_deserialize(var/serializer/curr_serializer)
	var/list/coords = splittext(landmark_loc, ",")
	var/turf/T = locate(text2num(coords[1]), text2num(coords[2]), text2num(coords[3]))
	return new /obj/abstract/map_data(T, text2num(height))
	