/turf/simulated/before_save()
	..()
	if(fire && fire.firelevel > 0)
		is_on_fire = fire.firelevel
	else
		is_on_fire = 0
	if(zone)
		c_copy_air()

/turf/simulated/after_deserialize()
	. = ..()
	for(var/decal in decals)
		overlays += decal