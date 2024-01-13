/decl/aspect/prosthetic_organ
	name = "Prosthetic Heart"
	aspect_flags = ASPECTS_PHYSICAL
	desc = "You have a synthetic heart."
	aspect_cost = 1
	category = "Prosthetic Organs"
	sort_value = 2
	var/apply_to_organ = BP_HEART

/decl/aspect/prosthetic_organ/is_available_to(datum/preferences/pref)
	. = ..()
	if(. && pref.species && pref.bodytype)
		var/decl/species/mob_species = pref.get_species_decl()
		var/decl/bodytype/mob_bodytype = pref.get_bodytype_decl()
		if(!istype(mob_bodytype))
			return FALSE
		if(!(apply_to_organ in mob_bodytype.has_organ))
			return FALSE
		if(mob_species.species_flags & SPECIES_NO_ROBOTIC_INTERNAL_ORGANS)
			return FALSE
		return TRUE

/decl/aspect/prosthetic_organ/applies_to_organ(var/organ)
	return apply_to_organ && organ == apply_to_organ

/decl/aspect/prosthetic_organ/apply(var/mob/living/carbon/human/holder)
	. = ..()
	if(.)
		var/obj/item/organ/internal/I = GET_INTERNAL_ORGAN(holder, apply_to_organ)
		if(I)
			I.set_bodytype(holder.species.base_prosthetics_model)

/decl/aspect/prosthetic_organ/eyes
	name = "Prosthetic Eyes"
	desc = "Your vision is augmented."
	apply_to_organ = BP_EYES
	incompatible_with = list(
		/decl/aspect/handicap/impaired_vision,
		/decl/aspect/handicap/colourblind,
		/decl/aspect/handicap/colourblind/protanopia,
		/decl/aspect/handicap/colourblind/tritanopia,
		/decl/aspect/handicap/colourblind/achromatopsia
	)

/decl/aspect/prosthetic_organ/kidneys
	name = "Prosthetic Kidneys"
	desc = "You have synthetic kidneys."
	apply_to_organ = BP_KIDNEYS

/decl/aspect/prosthetic_organ/liver
	name = "Prosthetic Liver"
	desc = "You have a literal iron liver."
	apply_to_organ = BP_LIVER

/decl/aspect/prosthetic_organ/lungs
	name = "Prosthetic Lungs"
	desc = "You have synthetic lungs."
	apply_to_organ = BP_LUNGS

/decl/aspect/prosthetic_organ/stomach
	name = "Prosthetic Stomach"
	desc = "You have a literal iron stomach."
	apply_to_organ = BP_STOMACH
