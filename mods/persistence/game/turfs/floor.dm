
/turf/simulated/floor/before_save()
	. = ..()
	if(flooring)
		CUSTOM_SV("flooring", ispath(flooring) ? flooring : flooring?.type)

/turf/simulated/floor/after_deserialize()
	//#RETROCOMPATIBILITY PATCH: Make sure all the turfs that lost their flooring get it back
	initial_flooring = initial(initial_flooring)
	var/flooring_type = LOAD_CUSTOM_SV("flooring")
	if(flooring_type)
		initial_flooring = flooring_type
	. = ..()
