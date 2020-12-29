/mob/living/carbon/Move(NewLoc, direct)
	if(!nutrition || !hydration)
		add_chemical_effect(CE_TOXIN, 1)
		adjustToxLoss(DEFAULT_HUNGER_FACTOR/1000)

	for(var/obj/item/organ/internal/stomach/stomach in src)
		if(!nutrition)
			stomach.take_internal_damage(DEFAULT_HUNGER_FACTOR/1000)
			
	for(var/obj/item/organ/internal/kidneys/kidneys in src)
		if(!hydration)
			kidneys.take_internal_damage(DEFAULT_HUNGER_FACTOR/1000)
	. = ..()

/mob/living/carbon/human/handle_regular_status_updates()
	if(!nutrition || !hydration)
		add_chemical_effect(CE_TOXIN, 1)
		adjustToxLoss(0.5001)
		
	for(var/obj/item/organ/internal/stomach/stomach in src)
		if(!nutrition)
			stomach.take_internal_damage(0.1001)
			
	for(var/obj/item/organ/internal/kidneys/kidneys in src)
		if(!hydration)
			kidneys.take_internal_damage(0.1001)
		
	. = ..()
