/obj/effect/vine/before_save()
	. = ..()
	CUSTOM_SV("mature_time_left", max(mature_time - world.time, 0))
	SAVE_SEED_OR_SEEDNAME(seed)

/obj/effect/vine/after_deserialize()
	. = ..()
	mature_time = LOAD_CUSTOM_SV("mature_time_left")
	if(mature_time > 0)
		mature_time = world.time + mature_time
	LOAD_SAVED_SEED_OR_SEEDNAME(seed)
	custom_saved = null

/obj/effect/vine/Initialize(mapload, datum/seed/newseed, obj/effect/vine/newparent, start_matured)
	if(persistent_id)
		
		newseed = seed
		newparent = parent
		start_matured = (mature_time == 0)

		var/prev_max_growth = max_growth
		var/prev_health = health
		. = ..(mapload, newseed, newparent, start_matured)
		max_growth = prev_max_growth //Prevents vines from growing more on each save load
		health = prev_health
	else
		. = ..()
