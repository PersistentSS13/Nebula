/obj/effect/shuttle_landmark/Initialize()
	// Don't autoset your base_area and base_turf if loaded.
	if(persistent_id)
		flags &= ~SLANDMARK_FLAG_AUTOSET
	
	name = initial(name) // Landmarks set their names automatically, so the saved name needs to be removed.
	. = ..()