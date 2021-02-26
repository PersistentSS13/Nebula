/mob/living/carbon/human
	var/obj/home_spawn		// The object we last safe-slept on. Used for moving characters to safe locations on loads.
	var/saved_species		// Whatever species we were, so that everything isn't rebuilt on load.

/mob/living/carbon/human/Initialize()
	if(ispath(move_intent))
		move_intent = decls_repository.get_decl(move_intent)
	if(saved_species)
		species = get_species_by_key(saved_species)

	..()

	return INITIALIZE_HINT_LATELOAD

/mob/living/carbon/human/LateInitialize()
	. = ..()
	
	for(var/obj/item/I in contents)
		I.hud_layerise()

	// Refresh the items in contents to make sure they show up.
	for(var/s in species.hud.gear)
		var/list/gear = species.hud.gear[s]
		var/obj/item/I = get_equipped_item(gear["slot"])
		if(istype(I))
			I.screen_loc = gear["loc"]

	regenerate_icons()

/mob/living/carbon/human/before_save()
	. = ..()
	if(species) saved_species = species.name // Caching species key for reference on load.

// For granting cortical chat on character creation.
/mob/living/carbon/human/update_languages()	
	. = ..()
	var/obj/item/organ/internal/stack/stack = (locate() in internal_organs)
	if(stack)
		add_language(/decl/language/cortical)

/mob/living/carbon/human/should_save()
	. = ..()
	if(mind && !mind.finished_chargen)
		return FALSE // We don't save characters who aren't finished CG.