/decl/material/chem/eyedrops
	name = "polyethylene glycol"
	color = "#c8a5dc86"

/decl/material/chem/antirads
	name = "potassium iodide"  //REAL NAMES at LEASSST
	color = "#40800071"

/decl/material/chem/brute_meds
	color = "#bf00007a"

/decl/material/chem/burn_meds
	color = "#ffaa0091"

/decl/material/chem/adminordrazine //An OP chemical for admins
	color = "#c8a5dc80"

/decl/material/chem/antitoxins
	color = "#00a00096"

/decl/material/chem/immunobooster
	color = "#ffc0cb7a"

/decl/material/chem/stimulants
	name = "erythropoietin"
	color = "#bf80bf93"

/decl/material/chem/antidepressants
	name = "fluoxetine" //another real one
	color = "#ff80ff86"

/decl/material/chem/antibiotics
	name = "Penicillin" //lets go with the classics.. AY?
	color = "#00400096"

/decl/material/chem/adrenaline
	color = "#c8a5dc85"

decl/material/chem/regenerator
	color = "#8040ff7e"

/decl/material/chem/neuroannealer
	color = "#ffff668a"

/decl/material/chem/oxy_meds
	name = "betametasona"

/decl/material/chem/sotalol //you new inaprovaline
	name = "Sotalol"   //Antiarrhythmics IRL
	lore_text = "A antiarrhythmic, that will do some pain. but it will inded stabilize you."
	taste_description = "acid"
	color = "#248f6286"
	scannable = 1
	overdose = 120
	value = 1 //cheaper 

/decl/material/chem/sotalol/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	M.add_chemical_effect(CE_STABLE)
	M.add_chemical_effect(CE_PAINKILLER, -10)
	if(volume >= 5 && M.is_asystole())
		holder.remove_reagent(type, 5)
		if(M.resuscitate())
			var/obj/item/organ/internal/heart = M.internal_organs_by_name[BP_HEART]
			heart.take_internal_damage(heart.max_damage * 0.30)

/decl/material/chem/arganbalm //as the old greek medicine
	name = "argan based balm" 
	lore_text = "cheaper alternative for the stytipic powder, not as good. and for a matter of fact might give tons of pain."
	taste_description = "vinegar"
	taste_mult = 3
	color = "#5713177a"
	scannable = 0
	overdose = 60

/decl/material/chem/arganbalm/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(6 * removed, 0)
	M.add_chemical_effect(CE_PAINKILLER, -20 * 0.5)

/decl/material/chem/garamycin // 1963 medicine for burns.
	name = "Garamycin"
	lore_text = "cheaper alternative for the synthskin, not as good. "
	taste_description = "slime"
	taste_mult = 2
	color = "#adc4278c"
	scannable = 0
	overdose = 60

/decl/material/chem/garamycin/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(1 , 6 * removed)
	M.add_chemical_effect(CE_PAINKILLER, 5) //weak but still helps a bit. i mean you are already getting tox. and brute. lets give you some relief
	M.add_chemical_effect(CE_TOXIN, 0.5)

/decl/material/chem/charcoalcalcium // Activated Charcoal-Calcium Car
	name = "Charcoal-Calcium"
	lore_text = "ghetto medicine for your tox. needs. will make you slugish."
	taste_description = "burnt"
	taste_mult = 2
	color = "#0000007a"
	scannable = 0
	overdose = 60

/decl/material/chem/charcoalcalcium/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_TOXIN, 1 * removed)
	M.add_chemical_effect(CE_SPEEDBOOST, 0.5 * removed) //this is bad enough as it is already speed is all 

/decl/material/chem/laudanum //with white wine and some herbs a primitive painkiller
	name = "laudanum"
	lore_text = "one of the oldest painkilers of time, might work. but will certainly get you drunk."
	taste_description = "white whine and herbs"
	taste_mult = 1
	color = "#8f6f807e"
	scannable = 0
	overdose = 30 //always lower than the same medicine of the same tier

/decl/material/chem/laudanum/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	M.make_dizzy(4)
	M.make_jittery(2)
	M.hallucination(60, 30)
	M.slurring = max(M.slurring, 15)
	M.eye_blurry = max(M.eye_blurry, 5)
	M.add_chemical_effect(CE_PAINKILLER, 40 * 0.12)

/decl/material/chem/stemcells //hard to get use blod and sum high level bulshit resource
	name = "stem cells" 
	lore_text = "the ultimate healing solution,for burns and brutes."
	taste_description = "blood"
	taste_mult = 5
	color = "#ff11009c"
	scannable = 1
	overdose = 15

/decl/material/chem/stemcells/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(8 * removed, 8 * removed)

/decl/material/chem/thrombin
	name = "thrombin" 
	lore_text = "helps the blood to create clots closing the wounds, but might thicken your blood a bit slowing the BPM" //might not be how it work IRL but. balance
	taste_description = "blood"
	taste_mult = 5
	color = "#2e1b0b81"
	scannable = 1
	overdose = 20

/decl/material/chem/thrombin/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(8 * removed, 0)
	M.add_chemical_effect(CE_PULSE, -1)

/decl/material/chem/silversulfadiazine //irl chem for burns. irl toxics. it acutally causes pain but lets help the player a bit
	name = "Silver Sulfadiazine" 
	lore_text = "helps your body on healing burns. usualy reserved for 3rd degree burns, works as a mild painkiler, might be toxic." 
	taste_description = "metallic"
	taste_mult = 5
	color = "#a7a09d93"
	scannable = 1
	overdose = 20

/decl/material/chem/silversulfadiazine/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(0, 8 * removed)
	M.add_chemical_effect(CE_TOXIN, 0.25)
	M.add_chemical_effect(CE_PAINKILLER, 20)

/decl/material/chem/ursodiol // irl treats liver
	name = "ursodiol"
	lore_text = "the best antitox one can get the hands on, just, too strong sometimes."
	taste_description = "strong sour milk"
	taste_mult = 8
	color = "#0d681c8e"
	scannable = 0
	overdose = 15

/decl/material/chem/ursodiol/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_TOXIN, 3 * removed)
	M.make_dizzy(2)
	M.slurring = max(M.slurring, 30)

/decl/material/chem/dexametasona // irl thing. for asthma picked this one for having DEX as dexalin
	name = "Dexametasona"
	lore_text = "glucocorticoid that helps you lung to dillatate stave off the effects of oxygen deprivation."
	taste_description = "tasteless slickness"
	color = "#1535c59f"
	scannable = 0
	overdose = 15

/decl/material/chem/dexametasona/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_OXYGENATED, 3)
	holder.remove_reagent(/decl/material/gas/carbon_monoxide, 4 * removed)
