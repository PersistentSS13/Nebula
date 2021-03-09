

/obj/machinery/AdjustInitializeArguments(list/arguments)
	if(SSpersistence.in_loaded_world)
		if(arguments.len > 2)
			arguments[3] = FALSE
		else if(arguments.len > 1)
			arguments |= list(null, FALSE)
		else
			arguments = list(FALSE, null, FALSE)

	. = ..()

/obj/machinery/before_save()
	. = ..()
	initial_access = list() // Remove initial_access so that access isn't wiped on load.