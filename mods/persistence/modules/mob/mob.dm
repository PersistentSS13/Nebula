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

// Called when a player rejoins as a mob from the main menu.
/mob/proc/on_persistent_join()
	if(client)
		client.show_location_blurb(30)

/////////////////////////////////////
// Saved Variables Definition
/////////////////////////////////////
SAVED_VAR(/mob, saved_ckey)
SAVED_VAR(/mob, personal_aspects)
SAVED_VAR(/mob, mob_flags)
SAVED_VAR(/mob, mind)
SAVED_VAR(/mob, lastKnownIP)
SAVED_VAR(/mob, computer_id)
SAVED_VAR(/mob, last_ckey)
SAVED_VAR(/mob, stat)
SAVED_VAR(/mob, machine)
SAVED_VAR(/mob, sdisabilities)
SAVED_VAR(/mob, disabilities)
SAVED_VAR(/mob, real_name)
SAVED_VAR(/mob, resting)
SAVED_VAR(/mob, lying)
SAVED_VAR(/mob, pinned)
SAVED_VAR(/mob, embedded)
SAVED_VAR(/mob, languages)
SAVED_VAR(/mob, only_species_language)
SAVED_VAR(/mob, facing_dir)
SAVED_VAR(/mob, timeofdeath)
SAVED_VAR(/mob, bodytemperature)
SAVED_VAR(/mob, buckled)
SAVED_VAR(/mob, active_storage)
SAVED_VAR(/mob, inertia_dir)
SAVED_VAR(/mob, dna)
SAVED_VAR(/mob, active_genes)
SAVED_VAR(/mob, mutations)
SAVED_VAR(/mob, radiation)
SAVED_VAR(/mob, voice_name)
SAVED_VAR(/mob, faction)
SAVED_VAR(/mob, blinded)
SAVED_VAR(/mob, status_flags)
SAVED_VAR(/mob, lastarea)
SAVED_VAR(/mob, digitalcamo)
SAVED_VAR(/mob, control_object)
SAVED_VAR(/mob, universal_speak)
SAVED_VAR(/mob, universal_understand)
SAVED_VAR(/mob, shouldnt_see)
SAVED_VAR(/mob, mob_size)
SAVED_VAR(/mob, flavor_text)
SAVED_VAR(/mob, skillset)
SAVED_VAR(/mob, additional_vision_handlers)
SAVED_VAR(/mob, gender)