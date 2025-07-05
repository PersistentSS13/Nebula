/mob/living/carbon/human

	var/regenerate_body_icon = FALSE // If true, the next icon update will also regenerate the body.

	var/skin_tone = 0  //Skin tone

	var/damage_multiplier = 1 //multiplies melee combat damage

	var/list/worn_underwear = list()

	var/datum/backpack_setup/backpack_setup

	var/list/cultural_info = list()

	var/obj/screen/default_attack_selector/attack_selector

	var/icon/stand_icon = null

	var/voice = ""	//Instead of new say code calling GetVoice() over and over and over, we're just going to ask this variable, which gets updated in Life()

	var/last_dam = -1	//Used for determining if we need to process all organs or just some or even none.
	/// organs we check until they are good.
	var/list/bad_external_organs

	var/mob/remoteview_target = null
	var/hand_blood_color

	var/list/flavor_texts = list()
	var/pulling_punches    // Are you trying not to hurt your opponent?
	var/full_prosthetic    // We are a robutt.
	var/robolimb_count = 0 // Number of robot limbs.
	var/last_attack = 0    // The world_time where an unarmed attack was done

	mob_bump_flag = HUMAN
	mob_push_flags = ~HEAVY
	mob_swap_flags = ~HEAVY

	var/flash_protection = 0				// Total level of flash protection
	var/equipment_tint_total = 0			// Total level of visualy impairing items
	var/equipment_darkness_modifier			// Darksight modifier from equipped items
	var/equipment_vision_flags				// Extra vision flags from equipped items
	var/equipment_see_invis					// Max see invibility level granted by equipped items
	var/equipment_prescription				// Eye prescription granted by equipped items
	var/equipment_light_protection
	var/list/equipment_overlays = list()	// Extra overlays from equipped items

	var/datum/mil_branch/char_branch = null
	var/datum/mil_rank/char_rank = null

	var/stance_damage = 0 //Whether this mob's ability to stand has been affected

	var/decl/natural_attack/default_attack	//default unarmed attack

	var/obj/machinery/machine_visual //machine that is currently applying visual effects to this mob. Only used for camera monitors currently.

	var/shock_stage
	var/rounded_shock_stage

	//vars for fountain of youth examine lines
	var/became_older
	var/became_younger

	var/list/smell_cooldown

	/// var for caching last getHalloss() run to avoid looping through organs over and over and over again
	var/last_pain

	var/vital_organ_missing_time

	/// Used to look up records when the client is logged out.
	var/comments_record_id

	ai = /datum/ai/human

	/// PS13 The object we last safe-slept on. Used for moving characters to safe locations on loads.
	var/obj/home_spawn


/mob/living/carbon/human/proc/get_age()
	. = LAZYACCESS(appearance_descriptors, "age") || 30

/mob/living/carbon/human/proc/set_age(var/val)
	var/datum/appearance_descriptor/age = LAZYACCESS(species.appearance_descriptors, "age")
	LAZYSET(appearance_descriptors, "age", age.sanitize_value(val))


SAVED_VAR(/mob/living/carbon/human, _skin_colour)
SAVED_VAR(/mob/living/carbon/human, skin_tone)
SAVED_VAR(/mob/living/carbon/human, damage_multiplier)
SAVED_VAR(/mob/living/carbon/human, blood_type)
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
