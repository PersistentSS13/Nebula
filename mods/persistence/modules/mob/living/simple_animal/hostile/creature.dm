#define ATTACK_MODE_MELEE    "melee"
#define ATTACK_MODE_SLUG    "slugvomit"
/mob/living/simple_animal/hostile/greed
	name = "GREED"
	desc = "It hurts to look at her."
	icon = 'icons/mob/simple_animal/creature.dmi'
	speak_emote = list("gibbers")
	health = 100
	maxHealth = 100
	natural_weapon = /obj/item/natural_weapon/bite/strong
	speed = 4
	supernatural = 1
	var/max_slugs = 2
	faction = "Hostile Fauna"
	var/attack_mode = ATTACK_MODE_MELEE
	unrelenting = 1
	natural_weapon_terrain = /obj/item/natural_weapon/bite/smasher
	destroy_surroundings = 1
	break_stuff_probability = 85

		//Space carp aren't affected by atmos.
	min_gas = null
	max_gas = null
	minbodytemp = 0

	break_stuff_probability = 25
	faction = "carp"
	bleed_colour = "#5d0d71"
	pass_flags = PASS_FLAG_TABLE

	meat_type = /obj/item/chems/food/meat/greed
	skin_material = /decl/material/solid/skin/greed
	bone_material = /decl/material/solid/bone/cartilage


/mob/living/simple_animal/hostile/greed/Process_Spacemove()
	return 1	// No drifting for GREED. original mob do not steal//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/greed/Shoot(target, start, user, bullet)
	if(target == start)
		return

	var/obj/item/A = new projectiletype(get_turf(user))
	playsound(user, projectilesound, 100, 1)
	if(!A)	return
	A.throw_at(target, 12, 10)
	max_slugs--
	switch_mode(ATTACK_MODE_MELEE)

/mob/living/simple_animal/hostile/greed/AttackingTarget()
	. = ..()
	if(ATTACK_MODE_MELEE)
		if(prob(10) && max_slugs)
			switch_mode(ATTACK_MODE_SLUG)

/mob/living/simple_animal/hostile/greed/death()
	..()
	if(prob(25))
		var/obj/item/glutslugegg/egg = new(loc)
		egg.throw_at_random(FALSE, rand(2,4), 4)
		visible_message(SPAN_MFAUNA("\The [src]'s explodes into viscera leaving creatures behind!"))
		gib()
		if(prob(50))
			egg = new(loc)
			egg.throw_at_random(FALSE, rand(2,4), 4)

/mob/living/simple_animal/hostile/greed/proc/switch_mode(var/new_mode)
	if(!new_mode || new_mode == attack_mode)
		return
	switch(new_mode)
		if(ATTACK_MODE_MELEE)
			ranged = FALSE
			projectilesound = null
			projectiletype = null
		if(ATTACK_MODE_SLUG)
			ranged = TRUE
			projectilesound = 'sound/effects/gore/flesh_born.ogg'
			projectiletype = /obj/item/glutslugegg
			fire_desc = "vomits"
			visible_message(SPAN_MFAUNA("\The [src]'s maw distends as it births another terror!"))


#undef ATTACK_MODE_MELEE
#undef ATTACK_MODE_SLUG
