/obj/machinery/forensic/Initialize()
	. = ..()
	var/old_sample = sample
	if(old_sample)
		sample = null
		set_sample(old_sample)