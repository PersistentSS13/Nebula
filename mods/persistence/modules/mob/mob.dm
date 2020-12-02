/mob
	var/saved_ckey = ""

/mob/before_save()
	. = ..()
	saved_ckey = ckey