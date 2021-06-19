

/obj/machinery/populate_parts(full_populate)
	if(persistent_id) // Only objects that have been loaded with have this var set at creation, so we prevent recreating additional components.
		return
	. = ..()

/obj/machinery/before_save()
	. = ..()
	initial_access = list() // Remove initial_access so that access isn't wiped on load.