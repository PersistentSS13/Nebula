/obj/structure/stairs/long/before_save()
	. = ..()
	if(isturf(loc))
		var/turf/T = loc
		CUSTOM_SV("primary_loc", "[T.x],[T.y],[T.z]")

/obj/structure/stairs/long/after_deserialize()
	var/primary_loc_coords = LOAD_CUSTOM_SV("primary_loc")
	var/list/coords = splittext(primary_loc_coords, ",")
	if(!islist(coords) || length(coords) < 3)
		log_error("\The [src] could not find its primary location on load!")
		return ..()

	var/adjusted_z = text2num(coords[3])
	if(SSpersistence.serializer.z_map[num2text(adjusted_z)])
		adjusted_z = SSpersistence.serializer.z_map[num2text(adjusted_z)]

	var/turf/primary_loc = locate(text2num(coords[1]), text2num(coords[2]), adjusted_z)

	if(isturf(primary_loc))
		forceMove(primary_loc)

	CLEAR_SV("primary_loc")
	return ..()