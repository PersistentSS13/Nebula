#define MALNUTRITION_DAMAGE 0.05

/mob/living/carbon/Life()
	. = ..()
	handle_malnutrition()

/mob/living/carbon/proc/handle_malnutrition()
	// If the player is in stasis from sleeping etc, we don't want to deal manlnutrition damage.
	if(stasis_value >= 10)
		return
	
	if(!nutrition || !hydration)
		add_chemical_effect(CE_TOXIN, 1)
		adjustToxLoss(MALNUTRITION_DAMAGE)
	
		var/obj/item/organ/internal/stomach_organ = internal_organs_by_name[BP_STOMACH]
		var/obj/item/organ/internal/kidneys_organ = internal_organs_by_name[BP_KIDNEYS]

		if(!nutrition && stomach_organ)
			stomach_organ.take_internal_damage(MALNUTRITION_DAMAGE)
			if(prob(5))
				to_chat(src, SPAN_WARNING("Your stomach cramps agonizingly with hunger pangs!"))

		if(!hydration && kidneys_organ)
			kidneys_organ.take_internal_damage(MALNUTRITION_DAMAGE)
			if(prob(5))
				to_chat(src, SPAN_WARNING("You're extremely thirsty!"))

#undef MALNUTRITION_DAMAGE