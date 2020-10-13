/decl/material/chem/eyedrops
	name = "polyethylene glycol"
	lore_text = "A soothing balm that helps with minor eye damage."
	taste_description = "a mild burn"
	color = "#c8a5dc86"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5

/decl/material/chem/eyedrops/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[BP_EYES]
		if(E && istype(E) && !E.is_broken())
			M.eye_blurry = max(M.eye_blurry - 5, 0)
			M.eye_blind = max(M.eye_blind - 5, 0)
			E.damage = max(E.damage - 5 * removed, 0)

/decl/material/chem/antirads
	name = "potassium iodide"  //REAL NAMES at LEASSST
	lore_text = "A synthetic recombinant protein, derived from entolimod, used in the treatment of radiation poisoning."
	taste_description = "bitterness"
	color = "#40800071"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5

/decl/material/chem/antirads/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.radiation = max(M.radiation - 30 * removed, 0)

/decl/material/chem/brute_meds
	name = "styptic powder"
	lore_text = "An analgesic and bleeding suppressant that helps with recovery from physical trauma. Can assist with mending arteries if injected in large amounts, but will cause complications."
	taste_description = "bitterness"
	taste_mult = 3
	color = "#bf00007a"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5

/decl/material/chem/brute_meds/affect_overdose(mob/living/carbon/M, alien, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		M.add_chemical_effect(CE_BLOCKAGE, (15 + REAGENT_VOLUME(holder, type))/100)
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/E in H.organs)
			if(E.status & ORGAN_ARTERY_CUT && prob(2))
				E.status &= ~ORGAN_ARTERY_CUT

/decl/material/chem/brute_meds/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(6 * removed, 0)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/decl/material/chem/burn_meds
	name = "synthskin"
	lore_text = "A synthetic sealant, disinfectant and analgesic that encourages burned tissue to recover."
	taste_description = "bitterness"
	color = "#ffaa0091"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5

/decl/material/chem/burn_meds/affect_blood(mob/living/carbon/M, alien, removed, var/datum/reagents/holder)
	M.heal_organ_damage(0, 6 * removed)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/decl/material/chem/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	lore_text = "It's magic. We don't have to explain it."
	taste_description = "100% abuse"
	color = "#c8a5dc80"
	flags = AFFECTS_DEAD //This can even heal dead people.

	glass_name = "liquid gold"
	glass_desc = "It's magic. We don't have to explain it."

/decl/material/chem/adminordrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	affect_blood(M, alien, removed, holder)

/decl/material/chem/adminordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.rejuvenate()

/decl/material/chem/antitoxins
	name = "antitoxins"
	lore_text = "A mix of broad-spectrum antitoxins used to neutralize poisons before they can do significant harm."
	taste_description = "a roll of gauze"
	color = "#00a00096"
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5
	var/remove_generic = 1
	var/list/remove_toxins = list(
		/decl/material/chem/toxin/zombiepowder
	)

/decl/material/chem/antitoxins/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(remove_generic)
		M.drowsyness = max(0, M.drowsyness - 6 * removed)
		M.adjust_hallucination(-9 * removed)
		M.add_up_to_chemical_effect(CE_ANTITOX, 1)

	var/removing = (4 * removed)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	for(var/R in ingested.reagent_volumes)
		if((remove_generic && ispath(R, /decl/material/chem/toxin)) || (R in remove_toxins))
			ingested.remove_reagent(R, removing)
			return
	for(var/R in M.reagents?.reagent_volumes)
		if((remove_generic && ispath(R, /decl/material/chem/toxin)) || (R in remove_toxins))
			M.reagents.remove_reagent(R, removing)
			return

/decl/material/chem/immunobooster
	name = "immunobooster"
	lore_text = "A drug that helps restore the immune system. Will not replace a normal immunity."
	taste_description = "chalky"
	color = "#ffc0cb7a"
	metabolism = REM
	overdose = REAGENTS_OVERDOSE
	value = 1.5
	scannable = 1

/decl/material/chem/immunobooster/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(REAGENT_VOLUME(holder, type) < REAGENTS_OVERDOSE)
		M.immunity = min(M.immunity_norm * 0.5, removed + M.immunity) // Rapidly brings someone up to half immunity.

/decl/material/chem/immunobooster/affect_overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	..()
	M.add_chemical_effect(CE_TOXIN, 1)
	M.immunity -= 0.5 //inverse effects when abused

/decl/material/chem/stimulants
	name = "erythropoietin"  //yes real dopping is made with this too.
	lore_text = "Improves the ability to concentrate."
	taste_description = "sourness"
	color = "#bf80bf93"
	scannable = 1
	metabolism = 0.01
	value = 1.5

/decl/material/chem/stimulants/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume <= 0.1 && M.chem_doses[type] >= 0.5 && world.time > REAGENT_DATA(holder, type) + 5 MINUTES)
		LAZYSET(holder.reagent_data, type, world.time)
		to_chat(M, "<span class='warning'>You lose focus...</span>")
	else
		M.drowsyness = max(M.drowsyness - 5, 0)
		M.AdjustParalysis(-1)
		M.AdjustStunned(-1)
		M.AdjustWeakened(-1)
		if(world.time > REAGENT_DATA(holder, type) + 5 MINUTES)
			LAZYSET(holder.reagent_data, type, world.time)
			to_chat(M, "<span class='notice'>Your mind feels focused and undivided.</span>")

/decl/material/chem/antidepressants
	name = "fluoxetine" //another real one
	lore_text = "Stabilizes the mind a little."
	taste_description = "bitterness"
	color = "#ff80ff86"
	scannable = 1
	metabolism = 0.01
	value = 1.5

/decl/material/chem/antidepressants/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume <= 0.1 && M.chem_doses[type] >= 0.5 && world.time > REAGENT_DATA(holder, type) + 5 MINUTES)
		LAZYSET(holder.reagent_data, type, world.time)
		to_chat(M, "<span class='warning'>Your mind feels a little less stable...</span>")
	else
		M.add_chemical_effect(CE_MIND, 1)
		M.adjust_hallucination(-10)
		if(world.time > REAGENT_DATA(holder, type) + 5 MINUTES)
			LAZYSET(holder.reagent_data, type, world.time)
			to_chat(M, "<span class='notice'>Your mind feels stable... a little stable.</span>")

/decl/material/chem/antibiotics
	name = "Penicillin" //lets go with the classics.. AY?
	lore_text = "An all-purpose antibiotic agent."
	taste_description = "bitterness"
	color = "#c1c1c186"
	metabolism = REM * 0.1
	overdose = REAGENTS_OVERDOSE/2
	scannable = 1
	value = 1.5

/decl/material/chem/antibiotics/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	M.immunity = max(M.immunity - 0.1, 0)
	M.add_chemical_effect(CE_ANTIBIOTIC, 1)
	if(volume > 10)
		M.immunity = max(M.immunity - 0.3, 0)
	if(M.chem_doses[type] > 15)
		M.immunity = max(M.immunity - 0.25, 0)

/decl/material/chem/antibiotics/affect_overdose(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	..()
	M.immunity = max(M.immunity - 0.25, 0)
	if(prob(2))
		M.immunity_norm = max(M.immunity_norm - 1, 0)

/decl/material/chem/retrovirals
	name = "retrovirals"
	lore_text = "A combination of retroviral therapy compounds and a meta-polymerase that rapidly mends genetic damage and unwanted mutations with the power of dark science."
	taste_description = "acid"
	color = "#00400096"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	value = 1.5

/decl/material/chem/retrovirals/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustCloneLoss(-20 * removed)
	M.adjustOxyLoss(-2 * removed)
	M.heal_organ_damage(20 * removed, 20 * removed)
	M.adjustToxLoss(-20 * removed)
	if(M.chem_doses[type] > 3 && ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/E in H.organs)
			E.status |= ORGAN_DISFIGURED //currently only matters for the head, but might as well disfigure them all.
	if(M.chem_doses[type] > 10)
		M.make_dizzy(5)
		M.make_jittery(5)

	var/needs_update = M.mutations.len > 0
	M.disabilities = 0
	M.sdisabilities = 0
	if(needs_update && ishuman(M))
		M.dna.ResetUI()
		M.dna.ResetSE()
		domutcheck(M, null, MUTCHK_FORCED)

/decl/material/chem/adrenaline
	name = "adrenaline"
	lore_text = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	taste_description = "rush"
	color = "#c8a5dc85"
	scannable = 1
	overdose = 20
	metabolism = 0.1
	value = 1.5

/decl/material/chem/adrenaline/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	M.add_chemical_effect(CE_STABLE)
	if(M.chem_doses[type] < 0.2)	//not that effective after initial rush
		M.add_chemical_effect(CE_PAINKILLER, min(30*volume, 80))
		M.add_chemical_effect(CE_PULSE, 1)
	else if(M.chem_doses[type] < 1)
		M.add_chemical_effect(CE_PAINKILLER, min(10*volume, 20))
	M.add_chemical_effect(CE_PULSE, 2)
	if(M.chem_doses[type] > 10)
		M.make_jittery(5)
	if(volume >= 5 && M.is_asystole())
		holder.remove_reagent(type, 5)
		if(M.resuscitate())
			var/obj/item/organ/internal/heart = M.internal_organs_by_name[BP_HEART]
			heart.take_internal_damage(heart.max_damage * 0.15)

/decl/material/chem/regenerator
	name = "regenerative serum"
	lore_text = "A broad-spectrum cellular regenerator that heals both burns and physical trauma, albeit quite slowly."
	taste_description = "metastasis"
	color = "#8040ff7e"
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5

/decl/material/chem/regenerator/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.heal_organ_damage(3 * removed, 3 * removed)

/decl/material/chem/neuroannealer
	name = "neuroannealer"
	lore_text = "A neuroplasticity-assisting compound that helps to lessen damage to neurological tissue after a injury. Can aid in healing brain tissue."
	taste_description = "bitterness"
	color = "#ffff668a"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 1.5

/decl/material/chem/neuroannealer/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_PAINKILLER, 10)
	M.add_chemical_effect(CE_BRAIN_REGEN, 1)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.confused++
		H.drowsyness++

/decl/material/chem/oxy_meds
	name = "betametasona"
	lore_text = "A biodegradable gel full of oxygen-laden synthetic molecules. Injected into suffocation victims to stave off the effects of oxygen deprivation."
	taste_description = "tasteless slickness"
	color = "#13637c91"

/decl/material/chem/oxy_meds/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_OXYGENATED, 1)
	holder.remove_reagent(/decl/material/gas/carbon_monoxide, 2 * removed)

/decl/material/chem/sotalol //you new inaprovaline
	name = "Sotalol"   //Antiarrhythmics IRL
	lore_text = "A Antiarrhythmic, that will do some pain. but it will inded stabilize you."
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
