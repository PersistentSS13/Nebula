//renames some chems

/decl/material/liquid/eyedrops
	name = "imidazoline"
	taste_description = "a dazzling kaleidoscope"

/decl/material/liquid/cleaner
	name = "space cleaner"

/decl/material/liquid/amphetamines
	name = "hyperzine" //known as amphetamines on Nebula, not to be confused with stimulants which is Neb's methylphenidate

// /decl/material/liquid/narcotics
//    name = "impedrezene"

/decl/material/liquid/sedatives
	name = "soporific"

/decl/material/liquid/hallucinogenics
	name = "mindbreaker toxin"

/decl/material/liquid/glowsap/gleam
	name = "three eye"

/decl/material/liquid/antirads
	name = "hyronalin"

/decl/material/liquid/antitoxins
	name = "dylovene"

/decl/material/liquid/antitoxins/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	holder.remove_reagent(/decl/material/liquid/ultradex, 10 * removed)
	..()

/decl/material/liquid/stimulants
	name = "methylphenidate"

/decl/material/liquid/antidepressants
	name = "citalopram"

/decl/material/liquid/antibiotics
//	name = "spaceacillin"
	lore_text = "A theta-lactam antibiotic. Slows progression of diseases. Treats infections."

/decl/material/liquid/retrovirals
	name = "ryetalyn"

/decl/material/liquid/stabilizer
	name = "inaprovaline"

/decl/material/liquid/regenerator
	name = "tricordrazine"

/decl/material/liquid/neuroannealer
	name = "alkysine"

/decl/material/liquid/oxy_meds	//T1 oxygen chem
	name = "dexalin"

/decl/material/liquid/painkillers	//T2 painkiller
	name = "tramadol"

// /decl/material/liquid/antiseptic
//   name = "sterilizine"

// /decl/material/liquid/paralytics
//    name = "vecuronium_bromide"

/decl/material/liquid/presyncopics
	name = "cryptobiolin"

//autoinjectors
/obj/item/chems/hypospray/autoinjector/detox
	name = "autoinjector (dylovene)"

/obj/item/chems/hypospray/autoinjector/pain
	name = "autoinjector (tramadol)"

/obj/item/chems/hypospray/autoinjector/antirad
	name = "autoinjector (hyronalin)"

//pills
/obj/item/chems/pill/antitox
	name = "dylovene (25u)"

/obj/item/chems/pill/stox
	name = "soporific (15u)"

/obj/item/chems/pill/painkillers
	name = "tramadol (15u)"

/obj/item/chems/pill/stabilizer
	name = "inaprovaline (30u)"

/obj/item/chems/pill/oxygen
	name = "dexalin (15u)"

/obj/item/chems/pill/antitoxins
	name = "dylovene (15u)"

// /obj/item/chems/pill/antibiotics
//	name = "spaceacillin (10u)"

/obj/item/chems/pill/stimulants
	name = "methylphenidate (15u)"

/obj/item/chems/pill/antidepressants
	name = "citalopram (15u)"

/obj/item/chems/pill/antirads
	name = "hyronalin (7u)"

/obj/item/chems/pill/antirad
	name = "hyro/dylo (15u)"

//spray bottle
// /obj/item/chems/spray/antiseptic
//	name = "sterilizine spray"

//syringes
/obj/item/chems/syringe/stabilizer
	name = "Syringe (inaprovaline)"

/obj/item/chems/syringe/antitoxin
	name = "Syringe (dylovene)"

// /obj/item/chems/syringe/antibiotic
//	name = "Syringe (spaceacillin)"

//pill bottles
/obj/item/storage/pill_bottle/antitox
	name = "pill bottle (dylovene)"

/obj/item/storage/pill_bottle/oxygen
	name = "pill bottle (dexalin)"

/obj/item/storage/pill_bottle/antitoxins
	name = "pill bottle (dylovene)"

// /obj/item/storage/pill_bottle/antibiotics
//	name = "pill bottle (spaceacillin)"

/obj/item/storage/pill_bottle/painkillers
	name = "pill bottle (tramadol)"

/obj/item/storage/pill_bottle/antidepressants
	name = "pill bottle (citalopram)"

/obj/item/storage/pill_bottle/stimulants
	name = "pill bottle (methylphenidate)"

//emergency autoinjectors
/obj/item/chems/hypospray/autoinjector/pouch_auto/stabilizer
	name = "emergency inaprovaline autoinjector"

/obj/item/chems/hypospray/autoinjector/pouch_auto/painkillers
	name = "emergency tramadol autoinjector"

/obj/item/chems/hypospray/autoinjector/pouch_auto/antitoxins
	name = "emergency dylovene autoinjector"

/obj/item/chems/hypospray/autoinjector/pouch_auto/oxy_meds
	name = "emergency dexalin autoinjector"

//new chems below (mostly taken from Bay)

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
		for(var/obj/item/organ/external/E in H.organs)
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

/decl/material/liquid/ultradex	//T3 oxygen chem
	name = "ultra dexalin"
	lore_text = "The optimal and exceedingly rare chemical for treating oxygen deprivation"
	taste_description = "a breath of fresh air"
	color = "#5e4fb3"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 3.7
	uid = "chem_ultradex"

/decl/material/liquid/ultradex/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
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
