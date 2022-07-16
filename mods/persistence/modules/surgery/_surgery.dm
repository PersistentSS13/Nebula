/decl/surgery_step/get_skill_reqs(mob/living/user, mob/living/target, obj/item/tool, target_zone)
	if(delicate)
		return PERSISTENCE_SURGERY_SKILLS_DELICATE
	else
		return PERSISTENCE_SURGERY_SKILLS_GENERIC

// stuff that happens when the step fails
/decl/surgery_step/success_chance(mob/living/user, mob/living/target, obj/item/tool, target_zone)
	. = tool_quality(tool)
	if(user == target)
		. -= 10

	var/skill_reqs = get_skill_reqs(user, target, tool, target_zone)
	for(var/skill in skill_reqs)
		var/penalty = delicate ? 40 : 20
		. -= max(0, penalty * (skill_reqs[skill] - user.get_skill_value(skill)))
		if(user.skill_check(skill, SKILL_PROF))
			. += 20

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		. -= round(H.shock_stage * 0.5)
		if(GET_STATUS(H, STAT_BLURRY))
			. -= 20
		if(GET_STATUS(H, STAT_BLIND))
			. -= 60

	if(delicate)
		if(HAS_STATUS(user, STAT_SLUR))
			. -= 10
		if(!target.lying)
			. -= 30
		var/turf/T = get_turf(target)
		if(locate(/obj/machinery/optable, T))
			. += 10
		else if(locate(/obj/structure/bed, T))
			. -= 10
		else if(locate(/obj/structure/table, T))
			. -= 20
		else if(locate(/obj/effect/rune/, T))
			. -= 20
	. = max(., 0)