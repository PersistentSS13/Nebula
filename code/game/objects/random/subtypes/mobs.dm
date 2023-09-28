/obj/random/hostile
	name = "Random Hostile Mob"
	desc = "This is a random hostile mob."
	icon = 'icons/mob/amorph.dmi'
	icon_state = "standing"
	spawn_nothing_percentage = 50



/obj/random/hostile/spawn_choices()
	var/static/list/spawnable_choices = list(
		/mob/living/simple_animal/hostile/hivebot/mega =        1,
		/mob/living/simple_animal/hostile/hivebot/tele =        1,
		/mob/living/simple_animal/hostile/hivebot/tele/range =  1,
		/mob/living/simple_animal/hostile/hivebot/tele/strong = 1,
		/mob/living/simple_animal/hostile/hivebot =             1000,
		/mob/living/simple_animal/hostile/hivebot/range =       100,
		/mob/living/simple_animal/hostile/hivebot/rapid =       100,
		/mob/living/simple_animal/hostile/hivebot/strong =      50,
	)
	return spawnable_choices

/obj/spawner
	anchored = TRUE
	invisibility = 101
	var/list/spawn_typecache
	var/list/spawn_types
	var/list/spawned_creatures = list()


/obj/spawner/Initialize()
	. = ..()
	START_PROCESSING(SSspwn,src)
	spawn_types = spawn_choices()
	spawn_typecache = typecacheof(spawn_types)

/obj/spawner/Destroy()
	STOP_PROCESSING(SSspwn,src)
	return ..()

/obj/spawner/Process()
	for (var/weakref/track in spawned_creatures)
		var/mob/possible_living_mob = track.resolve()
		if(possible_living_mob?.stat != DEAD)
			return
		else
			spawned_creatures -= possible_living_mob
	var/spawn_type = pickweight(spawn_types)
	var/new_creature = new spawn_type(loc)
	spawned_creatures += weakref(new_creature)


/obj/spawner/proc/spawn_choices()
	return list()

/obj/spawner/hostile/spawn_choices()
	var/static/list/spawnable_choices = list(
		/mob/living/simple_animal/hostile/hivebot/mega =        1,
		/mob/living/simple_animal/hostile/hivebot/tele =        1,
		/mob/living/simple_animal/hostile/hivebot/tele/range =  1,
		/mob/living/simple_animal/hostile/hivebot/tele/strong = 1,
		/mob/living/simple_animal/hostile/hivebot =             1000,
		/mob/living/simple_animal/hostile/hivebot/range =       100,
		/mob/living/simple_animal/hostile/hivebot/rapid =       100,
		/mob/living/simple_animal/hostile/hivebot/strong =      50,
	)
	return spawnable_choices