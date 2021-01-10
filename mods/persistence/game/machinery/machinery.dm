/obj/machinery/AdjustInitializeArguments(list/arguments)
	. = ..()
	if(arguments.len > 2)
		arguments[3] = FALSE
	else
		arguments |= list(null, FALSE)

/obj/machinery/before_save()
	. = ..()
	initial_access = list() // Remove initial_access so that access isn't wiped on load.