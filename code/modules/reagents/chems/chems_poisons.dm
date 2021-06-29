/decl/material/liquid/vecuronium_bromide
	name = "vecuronium bromide"
	lore_text = "A powerful paralytic agent."
	taste_description = "metallic"
	color = "#ff337d"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	value = 1.5

/decl/material/liquid/vecuronium_bromide/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/threshold = 2
	var/dose = LAZYACCESS(M.chem_doses, type)
	if(dose >= metabolism * threshold * 0.5)
		SET_STATUS_MAX(M, STAT_CONFUSE, 2)
		M.add_chemical_effect(CE_VOICELOSS, 1)
	if(dose > threshold * 0.5)
		ADJ_STATUS(M, STAT_DIZZY, 3)
		SET_STATUS_MAX(M, STAT_WEAK, 2)
	if(dose == round(threshold * 0.5, metabolism))
		to_chat(M, SPAN_WARNING("Your muscles slacken and cease to obey you."))
	if(dose >= threshold)
		M.add_chemical_effect(CE_SEDATE, 1)
		SET_STATUS_MAX(M, STAT_BLURRY, 10)

	if(dose > 1 * threshold)
		M.adjustToxLoss(removed)

/decl/material/liquid/cryptobiolin
	name = "cryptobiolin"
	lore_text = "A compound that causess presyncopic effects in the taker, including confusion and dizzyness."
	taste_description = "sourness"
	color = "#000055"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	heating_point = 61 CELSIUS
	heating_products = list(
		/decl/material/solid/potassium =        0.3, 
		/decl/material/liquid/acetone =         0.3, 
		/decl/material/liquid/nutriment/sugar = 0.4
	)
	value = 1.5

/decl/material/liquid/cryptobiolin/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/drug_strength = 4
	ADJ_STATUS(M, STAT_DIZZY, drug_strength)
	SET_STATUS_MAX(M, STAT_CONFUSE, drug_strength * 5)
