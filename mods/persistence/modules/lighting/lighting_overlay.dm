/atom/movable/lighting_overlay
	should_save = FALSE

/atom/movable/lighting_overlay/after_deserialize()
	..()
	forceMove(null)

/atom/movable/lighting_overlay/Initialize(ml, ...)
	if(persistent_id)
		return INITIALIZE_HINT_QDEL
	. = ..()
