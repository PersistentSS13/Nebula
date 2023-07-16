/mob/living/carbon/human
	var/obj/home_spawn		// The object we last safe-slept on. Used for moving characters to safe locations on loads.

/mob/living/carbon/human/before_save()
	. = ..()
	CUSTOM_SV_LIST(\
	"move_intent" = ispath(move_intent)? move_intent : move_intent?.type, \
	"eye_color" = eye_colour, \
	"facial_hair_colour" = facial_hair_colour, \
	"hair_colour" = hair_colour, \
	"skin_colour" = skin_colour, \
	"skin_tone" = skin_tone, \
	"h_style" = h_style, \
	"f_style" = f_style, \
	)

/mob/living/carbon/human/after_deserialize()
	. = ..()
	backpack_setup = null //Make sure we don't repawn a new backpack

/mob/living/carbon/human/setup(species_name, datum/dna/new_dna)
	//If we're loading from save, go through setup using the existing dna loaded from save
	if(persistent_id && dna)
		species = null //Null out the species at this point, so we don't crash set_species()
		. = ..(null, dna)
	else
		. = ..()

/mob/living/carbon/human/Initialize()
	. = ..()
	LATE_INIT_IF_SAVED

/mob/living/carbon/human/LateInitialize()
	. = ..()
	if(!persistent_id)
		return

	set_move_intent(GET_DECL(LOAD_CUSTOM_SV("move_intent")))

	//Apply saved appearance (appearance may differ from DNA)
	eye_colour         = LOAD_CUSTOM_SV("eye_colour")
	facial_hair_colour = LOAD_CUSTOM_SV("facial_hair_colour")
	hair_colour        = LOAD_CUSTOM_SV("hair_colour")
	skin_colour        = LOAD_CUSTOM_SV("skin_colour")
	skin_tone          = LOAD_CUSTOM_SV("skin_tone")
	h_style            = LOAD_CUSTOM_SV("h_style")
	f_style            = LOAD_CUSTOM_SV("f_style")

	//Force equipped items to refresh their held icon
	for(var/obj/item/I in get_contained_external_atoms())
		I.hud_layerise()

	//Update wounds has to be run this late because it expects the mob to be fully initialized
	for(var/obj/item/organ/external/limb in get_external_organs())
		limb.update_wounds()

	//Important to regen icons here, since we skipped on that before load!
	refresh_visible_overlays()

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

	CLEAR_ALL_SV //Clear saved vars

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

SAVED_VAR(/mob/living/carbon/human, h_style)
SAVED_VAR(/mob/living/carbon/human, f_style)
SAVED_VAR(/mob/living/carbon/human, hair_colour)
SAVED_VAR(/mob/living/carbon/human, facial_hair_colour)
SAVED_VAR(/mob/living/carbon/human, skin_colour)
SAVED_VAR(/mob/living/carbon/human, eye_colour)
SAVED_VAR(/mob/living/carbon/human, skin_tone)
SAVED_VAR(/mob/living/carbon/human, damage_multiplier)
SAVED_VAR(/mob/living/carbon/human, lip_style)
SAVED_VAR(/mob/living/carbon/human, b_type)
SAVED_VAR(/mob/living/carbon/human, worn_underwear)
SAVED_VAR(/mob/living/carbon/human, cultural_info)
SAVED_VAR(/mob/living/carbon/human, voice)
SAVED_VAR(/mob/living/carbon/human, last_dam)
SAVED_VAR(/mob/living/carbon/human, remoteview_target)
SAVED_VAR(/mob/living/carbon/human, hand_blood_color)
SAVED_VAR(/mob/living/carbon/human, flavor_texts)
SAVED_VAR(/mob/living/carbon/human, pulling_punches)
SAVED_VAR(/mob/living/carbon/human, last_attack)
SAVED_VAR(/mob/living/carbon/human, flash_protection)
SAVED_VAR(/mob/living/carbon/human, equipment_tint_total)
SAVED_VAR(/mob/living/carbon/human, equipment_darkness_modifier)
SAVED_VAR(/mob/living/carbon/human, equipment_vision_flags)
SAVED_VAR(/mob/living/carbon/human, equipment_see_invis)
SAVED_VAR(/mob/living/carbon/human, equipment_prescription)
SAVED_VAR(/mob/living/carbon/human, equipment_light_protection)
SAVED_VAR(/mob/living/carbon/human, char_branch)
SAVED_VAR(/mob/living/carbon/human, char_rank)
SAVED_VAR(/mob/living/carbon/human, stance_damage)
SAVED_VAR(/mob/living/carbon/human, default_attack)
SAVED_VAR(/mob/living/carbon/human, shock_stage)
SAVED_VAR(/mob/living/carbon/human, became_older)
SAVED_VAR(/mob/living/carbon/human, became_younger)
SAVED_VAR(/mob/living/carbon/human, appearance_descriptors)
SAVED_VAR(/mob/living/carbon/human, skin_state)
SAVED_VAR(/mob/living/carbon/human, embedded_flag)
SAVED_VAR(/mob/living/carbon/human, stamina)
SAVED_VAR(/mob/living/carbon/human, vessel)
SAVED_VAR(/mob/living/carbon/human, home_spawn)

SAVED_FLATTEN(/datum/mob_descriptor)
SAVED_VAR(/datum/appearance_descriptor, name)
SAVED_VAR(/datum/appearance_descriptor, chargen_label)
SAVED_VAR(/datum/appearance_descriptor, default_value)
SAVED_VAR(/datum/appearance_descriptor, comparative_value_descriptor_equivalent)
SAVED_VAR(/datum/appearance_descriptor, standalone_value_descriptors)
SAVED_VAR(/datum/appearance_descriptor, comparative_value_descriptors_smaller)
SAVED_VAR(/datum/appearance_descriptor, comparative_value_descriptors_larger)
SAVED_VAR(/datum/appearance_descriptor, chargen_value_descriptors)
SAVED_VAR(/datum/appearance_descriptor, chargen_min_index)
SAVED_VAR(/datum/appearance_descriptor, chargen_max_index)
SAVED_VAR(/datum/appearance_descriptor, skip_species_mention)
SAVED_VAR(/datum/appearance_descriptor, equivalent_variance_threshold)
SAVED_VAR(/datum/appearance_descriptor, comparison_variance_multiplier)
