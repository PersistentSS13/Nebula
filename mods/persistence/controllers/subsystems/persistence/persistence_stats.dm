/////////////////////////////////
// Save statistics
/////////////////////////////////

///Stats on how long a specific type of atom took to save in total, and how many instances of that type there are.
/datum/serialization_stat
	var/time_spent   = 0
	var/nb_instances = 0

/datum/serialization_stat/New(var/_time_spent = 0, var/_nb_instances = 0)
	. = ..()
	time_spent   = _time_spent
	nb_instances = _nb_instances
