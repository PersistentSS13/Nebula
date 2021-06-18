/mob
	var/saved_ckey = ""

/mob/before_save()
	. = ..()
	saved_ckey = ckey

/mob/Initialize()
	UpdateLyingBuckledAndVerbStatus() // Dead mobs need to have their transforms etc. updated on load.
	update_transform()
	if(!ispath(skillset))
		var/datum/skillset/temp = skillset
		skillset = /datum/skillset
		. = ..()
		skillset = temp
	else
		. = ..()