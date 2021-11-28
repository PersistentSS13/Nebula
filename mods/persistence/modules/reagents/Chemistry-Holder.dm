/datum/reagents/New(maximum_volume, atom/my_atom)
	if(!my_atom)
		my_atom = global.temp_reagents_holder
	. = ..()

/datum/reagents/after_deserialize()
	. = ..()
	update_total()

//Reimplement this to get rid of the spam on save load
/atom/create_reagents(var/max_vol)
	if(reagents)
		if(!persistent_id)
			log_debug("Attempted to create a new reagents holder when already referencing one: [log_info_line(src)]")
		reagents.maximum_volume = max(reagents.maximum_volume, max_vol)
	else
		reagents = new/datum/reagents(max_vol, src)
	return reagents