/mob/living/carbon/death()
	if(stat & DEAD)
		return FALSE

	if(ckey && client)
		var/obj/item/organ/internal/stack/stack = switchToStack(ckey, mind)
		if(stack)
			// They did have a stack.
			to_chat(stack.stackmob, SPAN_NOTICE("Darkness envelopes you. Your character has died and you are now in limbo. Resleeve to continue playing as your character, or wait until a kind soul clones you from your cortical stack."))
			stack.stackmob.verbs |= /mob/proc/resleeve
			stack.stackmob.verbs |= /mob/proc/death_give_up
		else
			hide_fullscreens()
			var/mob/living/limbo/brainmob = new(src)
			brainmob.forceMove(null)
			brainmob.SetName(real_name)
			brainmob.real_name = real_name
			brainmob.dna = dna.Clone()
			brainmob.verbs |= /mob/proc/resleeve  
			brainmob.verbs |= /mob/proc/death_give_up
			// brainmob.timeofhostdeath = timeofdeath
			mind.transfer_to(brainmob)
			to_chat(brainmob, SPAN_NOTICE("Darkness envelopes you. Your character has died and you are now in limbo. Your sleeve has been destroyed but you may still have backups in the world. Resleeve to continue playing as your character. Otherwise, release yourself and create a new character!"))
	. = ..()

/mob/proc/resleeve()
	set category = "IC"
	set name = "Resleeve"

	if(key && mind)
		if(show_valid_respawns(src))
			verbs -= /mob/proc/resleeve
			verbs -= /mob/proc/death_give_up

/mob/proc/death_give_up()
	set category = "IC"
	set name = "Give up"
	if(key && mind)
		var/mob/new_player/player = new()
		player.ckey = ckey

		// Permanently remove the player from the limbo list so that the mind datum is removed from the database at next save.
		SSpersistence.RemoveFromLimbo(mind.unique_id, LIMBO_MIND)
		QDEL_NULL(mind)
		qdel_self()
