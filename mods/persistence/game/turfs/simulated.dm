/turf/simulated/before_save()
	..()
	if(fire && fire.firelevel > 0)
		is_on_fire = fire.firelevel
	else
		is_on_fire = 0
	if(zone)
		c_copy_air()
