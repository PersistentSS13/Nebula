/obj/effect/shuttle_landmark/Initialize()
	name = initial(name) // Landmarks set their names automatically, so the saved name needs to be removed.
	. = ..()