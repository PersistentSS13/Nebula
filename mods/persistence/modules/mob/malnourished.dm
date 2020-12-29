/mob/living/carbon/Move(NewLoc, direct)

	if(!nutrition)
		add_chemical_effect(CE_TOXIN, 1)
		adjustToxLoss(DEFAULT_HUNGER_FACTOR/1000)
	if(!hydration)
		add_chemical_effect(CE_TOXIN, 1)
		adjustToxLoss(DEFAULT_HUNGER_FACTOR/1000)
	. = ..()

/mob/living/carbon/human/handle_regular_status_updates()

	if(!nutrition)
		add_chemical_effect(CE_TOXIN, 1)
		adjustToxLoss(0.25005)
	if(!hydration)
		add_chemical_effect(CE_TOXIN, 1)
		adjustToxLoss(0.25005)
	. = ..()
