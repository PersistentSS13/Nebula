#define MALNUTRITION_DAMAGE 0.05
#define SLEEPING_DELAY 5 MINUTES

/mob/living/carbon
	var/logged_out_time

/mob/living/carbon/Initialize()
	. = ..()
	if(!client && !logged_out_time)
		logged_out_time = world.time + SLEEPING_DELAY

/mob/living/carbon/Life()
	. = ..()
	handle_malnutrition()
	handle_sleep_stasis()

/mob/living/carbon/proc/handle_malnutrition()
	// If the player is in stasis from sleeping etc, we don't want to deal manlnutrition damage.
	if(stasis_value >= 10)
		return

	if(!nutrition || !hydration)
		add_chemical_effect(CE_TOXIN, 1)
		adjustToxLoss(MALNUTRITION_DAMAGE)

		var/obj/item/organ/internal/stomach_organ = get_organ(BP_STOMACH)
		var/obj/item/organ/internal/kidneys_organ = get_organ(BP_KIDNEYS)

		if(!nutrition && stomach_organ)
			stomach_organ.take_internal_damage(MALNUTRITION_DAMAGE)
			if(prob(5))
				to_chat(src, SPAN_WARNING("Your stomach cramps agonizingly with hunger pangs!"))

		if(!hydration && kidneys_organ)
			kidneys_organ.take_internal_damage(MALNUTRITION_DAMAGE)
			if(prob(5))
				to_chat(src, SPAN_WARNING("You're extremely thirsty!"))

/mob/living/carbon/proc/handle_sleep_stasis()
	if(!client)
		if(!logged_out_time)
			logged_out_time = world.time
		if(world.time > logged_out_time + SLEEPING_DELAY)
			var/stasis_level
			if(locate(/obj/structure/bed) in get_turf(src))
				stasis_level = 20
			else
				stasis_level = 10
			//Apply sleeping stasis.
			set_stasis(stasis_level, STASIS_SLEEP)
	else
		logged_out_time = null

#undef MALNUTRITION_DAMAGE