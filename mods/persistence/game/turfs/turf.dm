/turf/after_deserialize()
	..()
	initial_gas = null
	if(lighting_overlay)
		lighting_overlay = null
		log_warning("[src]([x],[y],[z]) has a lighting overlay after load!!")
