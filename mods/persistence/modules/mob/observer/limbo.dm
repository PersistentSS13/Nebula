// This mob generically just holds a mind to show that it's
// still floating around .. somewhere.
/mob/living/limbo
	use_me = 0

/mob/living/limbo/Initialize()
	. = ..()
	verbs |= /mob/proc/resleeve
	verbs |= /mob/proc/death_give_up

	var/datum/action/resleeve/resleeve_act = new(src)
	resleeve_act.Grant(src)

	var/datum/action/death_give_up/give_up_act = new(src)
	give_up_act.Grant(src)

/mob/living/limbo/Destroy()
	for(var/datum/action/death_action in actions)
		death_action.SetTarget(null)
		qdel(death_action)
	. = ..()

// Do not call parent, as we do not want the area text to appear.
/mob/living/limbo/on_persistent_join()
	// Limbo mob is inside a stack, and can be revived from it.
	if(istype(loc, /obj/item/organ/internal/stack))
		to_chat(src, SPAN_NOTICE("Your character has died and you are now in limbo. Resleeve to continue playing as your character, or wait until a kind soul clones you from your cortical stack."))
	else
		to_chat(src, SPAN_NOTICE("Your character has died and you are now in limbo. Your sleeve has been destroyed but you may still have backups in the world. Resleeve to continue playing as your character. Otherwise, release yourself and create a new character!"))

/datum/action/resleeve
	name = "Resleeve"
	desc = "Resleeve your character, if you have a backup in the world"
	procname = "resleeve"
	action_type = AB_GENERIC
	button_icon = 'mods/persistence/icons/obj/action_buttons/actions.dmi'
	button_icon_state = "resleeve"

/datum/action/death_give_up
	name = "Give up"
	desc = "Give up, returning you to the main menu and permanently removing your character from the game"
	procname = "death_give_up"
	action_type = AB_GENERIC
	button_icon = 'mods/persistence/icons/obj/action_buttons/actions.dmi'
	button_icon_state = "give_up"