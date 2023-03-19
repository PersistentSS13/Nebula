/mob/living/Move(a, b, flag)
	if(SSautosave.saving)
		return
	. = ..()

/mob/living/switch_from_dead_to_living_mob_list()
	. = ..()
	if(.)
		// If there's a mob in limbo or the player has a stack, restore them to their body.
		if(last_ckey)
			for(var/mob/living/limbo/limbo in player_list)
				if(limbo.mind && limbo.mind.name == real_name && limbo.ckey == last_ckey)
					limbo.mind.transfer_to(src)
					qdel(limbo)
					break

SAVED_VAR(/mob/living, pronoun_gender)
SAVED_VAR(/mob/living, pronouns)