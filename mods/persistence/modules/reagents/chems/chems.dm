SAVED_VAR(/obj/item/chems, reagents)


/decl/material/liquid/antitoxins/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	holder.remove_reagent(/decl/material/liquid/dexalinultra, 10 * removed)
	..()

/decl/material/liquid/bicaridine
	name = "bicaridine"
	lore_text = "An advanced chemical for healing physical trauma."
	taste_description = "metallicness"
	taste_mult = 3
	color = "#bf0000"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 4.9
	uid = "chem_bicaridine"

/decl/material/liquid/bicaridine/affect_overdose(mob/living/M, alien, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		M.add_chemical_effect(CE_BLOCKAGE, (15 + REAGENT_VOLUME(holder, type))/100)
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/E in H.get_external_organs())
			if(E.status & ORGAN_ARTERY_CUT && prob(2 + REAGENT_VOLUME(holder, type) / overdose))
				E.status &= ~ORGAN_ARTERY_CUT

/decl/material/liquid/bicaridine/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(6 * removed, 0)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/decl/material/liquid/kelotane
	name = "kelotane"
	lore_text = "An advanced chemical for healing burns."
	taste_description = "bitterness"
	color = "#ffa800"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 2.9
	uid = "chem_kelotane"

/decl/material/liquid/kelotane/affect_blood(mob/living/M, alien, removed, var/datum/reagents/holder)
	M.heal_organ_damage(0, 6 * removed)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/decl/material/liquid/dexalinplus	//T2 oxygen chem
	name = "dexalin plus"
	lore_text = "An advanced chemical for treating oxygen deprivation."
	taste_description = "tasteless slickness"
	color = "#0040ff"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 3.7
	uid = "chem_dexplus"

/decl/material/liquid/dexalinplus/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_OXYGENATED, 2)
	holder.remove_reagent(/decl/material/gas/carbon_monoxide, 3 * removed)

/decl/material/liquid/painkillers/morphine	//T3 painkiller
	name = "morphine"	//oxycodone
	lore_text = "The optimal and exceedingly rare painkiller. Don't mix with alcohol."
	taste_description = "numbness"
	color = "#800080"
	overdose = 20
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 3.1
	pain_power = 200 //magnitude of painkilling effect
	effective_dose = 2 //how many units it need to process to reach max power
	uid = "chem_morphine"

/decl/material/liquid/painkillers/morphine/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	SET_STATUS_MAX(M, STAT_DROWSY, 10)
	..()

/decl/material/liquid/painkillers/morphine/affect_overdose(var/mob/living/M, var/alien, var/datum/reagents/holder)
	M.adjustToxLoss(5)
	..()

/decl/material/liquid/dexalinultra	//T3 oxygen chem
	name = "dexalin ultra"
	lore_text = "The optimal and exceedingly rare chemical for treating oxygen deprivation"
	taste_description = "a breath of fresh air"
	color = "#5e4fb3"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 3.7
	uid = "chem_ansodex"

/decl/material/liquid/dexalinultra/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_OXYGENATED, 3)
	holder.remove_reagent(/decl/material/gas/carbon_monoxide, 4 * removed)
	M.adjustToxLoss(5 * removed)
	SET_STATUS_MAX(M, STAT_JITTER, 130)
	SET_STATUS_MAX(M, STAT_DIZZY,  1000)

/decl/material/liquid/painkillers/paracetamol	//T1 painkiller
	name = "paracetamol"
	lore_text = "An weak painkiller. Don't mix with alcohol."
	taste_description = "sickness"
	color = "#c8a5dc"
	overdose = 60
	scannable = 1
	metabolism = 0.02
	ingest_met = 0.02
	flags = IGNORE_MOB_SIZE
	value = 3.3
	pain_power = 35 //magnitude of painkilling effect
	effective_dose = 0.2 //how many units it need to process to reach max power
	uid = "chem_paracetamol"
