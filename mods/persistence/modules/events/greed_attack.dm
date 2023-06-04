
/datum/event/greed_attack
	announceWhen	= 45
	endWhen			= 75
	var/no_show = FALSE // greed are laggy, so if there is too much stuff going on we're going to dial it down.
	var/spawned_greed	//for debugging purposes only?
	var/greed_per_z = 8
	var/greed_per_event = 5

/datum/event/greed_attack/setup()
	announceWhen = rand(30, 60)
	endWhen += severity*25


/datum/event/greed_attack/announce()
	var/announcement = ""
	if(severity > EVENT_LEVEL_MODERATE)
		announcement = "A massive migration of unknown biological entities has been detected in the vicinity of the [location_name()]. Exercise external operations with caution."
	else
		announcement = "A large migration of unknown biological entities has been detected in the vicinity of the [location_name()]. Caution is advised."

	command_announcement.Announce(announcement, "[location_name()] Sensor Array", zlevels = affecting_z)

/datum/event/greed_attack/tick()
	spawn_greed()

/datum/event/greed_attack/proc/spawn_greed(var/direction, var/speed)
	if(!living_observers_present(affecting_z))
		return
	var/Z = pick(affecting_z)

	if(!direction)
		direction = pick(global.cardinal)

	if(!speed)
		speed = rand(1,3)

	var/n = rand(severity-1, severity*2)
	var/I = 0
	while(I < n)
		var/turf/T = get_random_edge_turf(direction,TRANSITIONEDGE + 2, Z)
		if(isspaceturf(T))
			var/mob/living/simple_animal/hostile/M
			if(prob(100))
				M = new /mob/living/simple_animal/hostile/greed(T)
	//		else
	//			M = new /mob/living/simple_animal/hostile/greed/pike(T)
	//			I += 3
			spawned_greed ++
			M.throw_at(get_random_edge_turf(global.reverse_dir[direction],TRANSITIONEDGE + 2, Z), 250, speed, callback = CALLBACK(src,/datum/event/greed_attack/proc/check_gib,M))
		I++
		if(no_show)
			break

/datum/event/greed_attack/proc/check_gib(var/mob/living/simple_animal/hostile/greed/M)	//awesome road kills
	if(M.health <= 0 && prob(60))
		M.gib()

/proc/get_random_edge_turf(var/direction, var/clearance = TRANSITIONEDGE + 1, var/Z)
	if(!direction)
		return

	switch(direction)
		if(NORTH)
			return locate(rand(clearance, world.maxx - clearance), world.maxy - clearance, Z)
		if(SOUTH)
			return locate(rand(clearance, world.maxx - clearance), clearance, Z)
		if(EAST)
			return locate(world.maxx - clearance, rand(clearance, world.maxy - clearance), Z)
		if(WEST)
			return locate(clearance, rand(clearance, world.maxy - clearance), Z)

/datum/event/greed_attack/end()
	log_debug("greed attack event spawned [spawned_greed] greed.")

/datum/event/greed_attack/overmap
	announceWhen = 1
	greed_per_z = 5
	greed_per_event = 10
	var/obj/effect/overmap/visitable/ship/victim

/datum/event/greed_attack/overmap/Destroy()
	victim = null
	. = ..()

/datum/event/greed_attack/overmap/tick()
	var/speed
	if(victim && !victim.is_still())
		speed = round(victim.get_speed()* (1000 + (victim.get_helm_skill()-SKILL_MIN)*250))//more skill more roadkills

	spawn_greed((victim && prob(80)? victim.fore_dir : null), speed)