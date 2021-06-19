/datum/reagents/New(maximum_volume, atom/my_atom)
	if(!my_atom)
		my_atom = global.temp_reagents_holder
	. = ..()

/datum/reagents/after_deserialize()
	. = ..()
	update_total()