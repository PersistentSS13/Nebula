/turf/simulated/before_save()
	. = ..()
	if(fire)
		CUSTOM_SV("fire_level", fire?.firelevel)
	if(zone)
		c_copy_air()

/turf/simulated/after_deserialize()
	. = ..()
	for(var/decal in decals)
		overlays += decal

/turf/simulated/Initialize(ml)
	. = ..()
	//We setup fires only when atmos is up and working
	if(LOAD_CUSTOM_SV("fire_level"))
		LATE_INIT_IF_SAVED

/turf/simulated/LateInitialize()
	. = ..()
	var/firelvl = LOAD_CUSTOM_SV("fire_level")
	if(firelvl > 0)
		create_fire(firelvl)