/area/chargen
	name = "\improper Colony Pod"
	icon_state = "crew_quarters"
	requires_power = FALSE
	var/obj/abstract/landmark/chargen_spawn/chargen_landmark //Cached landmark for the current pod
	var/static/chargen_area_counter = 0

//Clear an entire chargen pod from any random trash left
/area/chargen/proc/run_chargen_cleanup()
	var/junkcounter = 0
	for(var/obj/item/junk in src)
		junkcounter++
		if(!QDELETED(junk))
			qdel(junk)
	log_debug("area/chargen/run_chargen_cleanup(): Cleared [junkcounter] junk item(s) from [src]!")

/area/chargen/Initialize()
	. = ..()
	name = "[name] #[chargen_area_counter]"
	chargen_area_counter++

/area/chargen/Destroy()
	chargen_landmark = null
	. = ..()