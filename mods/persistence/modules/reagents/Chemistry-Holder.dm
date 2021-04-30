/datum/reagents/New(var/maximum_volume = 120, var/atom/my_atom)
	src.maximum_volume = maximum_volume
	if(istype(my_atom))
		src.my_atom = my_atom