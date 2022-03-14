/mob/living/carbon/human
	var/obj/home_spawn		// The object we last safe-slept on. Used for moving characters to safe locations on loads.

/mob/living/carbon/human/before_save()
	. = ..()
	CUSTOM_SV_LIST(\
	"saved_move_intent" = move_intent?.type,\
	"saved_species" = species?.name,\
	"saved_bodytype" = bodytype?.name)

/mob/living/carbon/human/after_deserialize()
	. = ..()
	backpack_setup = null //Make sure we don't repawn a new backpack
	if(ignore_persistent_spawn())
		return

	if(!loc) // We're loading into null-space because we were in an unsaved level or intentionally in limbo. Move them to the last valid spawn.
		if(istype(home_spawn))
			if(home_spawn.loc)
				forceMove(get_turf(home_spawn)) // Welcome home!
				return
			else // Your bed is in nullspace with you!
				QDEL_NULL(home_spawn)
		forceMove(get_spawn_turf()) // Sorry man. Your bed/cryopod was not set.

/mob/living/carbon/human/Initialize()
	if(!persistent_id)
		return ..()
	set_species(LOAD_CUSTOM_SV("saved_species"), FALSE)
	set_bodytype(species.get_bodytype_by_name(LOAD_CUSTOM_SV("saved_bodytype")), FALSE)
	. = ..()
	LATE_INIT_IF_SAVED

/decl/species/create_organs(var/mob/living/carbon/human/H)
	//We don't want to delete the organs we loaded from the save
	if(!H.persistent_id)
		. = ..()
	
	H.mob_size = mob_size

/mob/living/carbon/human/LateInitialize()
	. = ..()
	if(persistent_id)
		set_move_intent(GET_DECL(LOAD_CUSTOM_SV("saved_move_intent")))

	for(var/obj/item/I in contents)
		I.hud_layerise()

	// Refresh the items in contents to make sure they show up.
	for(var/s in species.hud.gear)
		var/list/gear = species.hud.gear[s]
		var/obj/item/I = get_equipped_item(gear["slot"])
		if(istype(I))
			I.screen_loc = gear["loc"]
	
	//Important to regen icons here, since we skipped on that before load!
	refresh_visible_overlays()

	CLEAR_SV //Clear saved vars

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

// Don't let it update icons during initialize
// Can't avoid upstream code from doing it, so just postpone it
/mob/living/carbon/human/update_icon()
	if(!(atom_flags & ATOM_FLAG_INITIALIZED))
		queue_icon_update() //Queue it later instead
		return
	. = ..()