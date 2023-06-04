/decl/species/human
	name = SPECIES_HUMAN
	name_plural = "Humans"
	primitive_form = SPECIES_MONKEY
	unarmed_attacks = list(/decl/natural_attack/stomp, /decl/natural_attack/kick, /decl/natural_attack/punch, /decl/natural_attack/bite)
	description = "The most common sentient species in the known galaxy, humanity has been devistated over the past three generations by a war between two human empires."
	hidden_from_codex = FALSE
	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE_NORMAL | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR
	inherent_verbs = list(/mob/living/carbon/human/proc/tie_hair)

	available_bodytypes = list(
		/decl/bodytype/human,
		/decl/bodytype/human/masculine
	)

	exertion_effect_chance = 10
	exertion_hydration_scale = 1
	exertion_charge_scale = 1
	exertion_reagent_scale = 1
	exertion_reagent_path = /decl/material/liquid/lactate
	exertion_emotes_biological = list(
		/decl/emote/exertion/biological,
		/decl/emote/exertion/biological/breath,
		/decl/emote/exertion/biological/pant
	)
	exertion_emotes_synthetic = list(
		/decl/emote/exertion/synthetic,
		/decl/emote/exertion/synthetic/creak
	)

	available_cultural_info = list(
		TAG_CULTURE = list(
			/decl/cultural_info/culture/human_retro,
			/decl/cultural_info/culture/human_futurist,
			/decl/cultural_info/culture/human_pragmatist
		),
		TAG_HOMEWORLD = list(
			/decl/cultural_info/location/human_sol,
			/decl/cultural_info/location/human_borderworlds,
			/decl/cultural_info/location/human_terrancolony,
			/decl/cultural_info/location/human_agartha,
			/decl/cultural_info/location/human_independent
		),
		TAG_FACTION = list(
			/decl/cultural_info/faction/human_solgov,
			/decl/cultural_info/faction/human_terran,
			/decl/cultural_info/faction/human_independent
		),
		TAG_RELIGION =  list(/decl/cultural_info/religion/soldivinity,
			/decl/cultural_info/religion/commucracy,
			/decl/cultural_info/religion/retrodoxy,
			/decl/cultural_info/religion/seeker,
			/decl/cultural_info/religion/athiest
		)
	)

/decl/species/human/get_root_species_name(var/mob/living/carbon/human/H)
	return SPECIES_HUMAN

/decl/species/human/get_ssd(var/mob/living/carbon/human/H)
	if(H.stat == CONSCIOUS)
		return "staring blankly, not reacting to your presence"
	return ..()

/decl/species/human/equip_default_fallback_uniform(var/mob/living/carbon/human/H)
	if(istype(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey, slot_w_uniform_str)
