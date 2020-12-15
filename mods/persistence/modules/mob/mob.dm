/mob
	var/saved_ckey = ""

/mob/before_save()
	. = ..()
	saved_ckey = ckey

/mob/Initialize()
	if(!ispath(skillset))
		var/datum/skillset/temp = skillset
		skillset = /datum/skillset
		. = ..()
		skillset = temp
	else
		. = ..()
	
