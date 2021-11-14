/datum/wrapper_holder // Dummy object to hold wrappers for deserialization, when the wrapped objects don't necessarily have a physical reference. Has to be created manually.
	var/list/wrapped = list()

/datum/wrapper_holder/New(wrapped_list)
	if(wrapped_list)
		wrapped += wrapped_list
	. = ..()