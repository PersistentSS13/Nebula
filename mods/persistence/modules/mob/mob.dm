/mob
	var/saved_ckey = ""

/mob/before_save()
	. = ..()
	saved_ckey = ckey

/mob/Initialize()
	if(persistent_id)
		//The following line cause issues with ghosts if you don't limit it to loaded mobs
		UpdateLyingBuckledAndVerbStatus() // Dead mobs need to have their transforms etc. updated on load.
		update_transform()
	. = ..()
	if(persistent_id)
		skillset?.update_verbs()
		skillset?.update_special_effects()
