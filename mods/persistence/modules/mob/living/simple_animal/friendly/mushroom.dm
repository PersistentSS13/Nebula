/mob/living/simple_animal/mushroom/before_save()
	. = ..()
	var/saved_harvest_time = max(harvest_time - world.time, 0)
	CUSTOM_SV("harvest_time", saved_harvest_time)
	SAVE_SEED_OR_SEEDNAME(seed)

/mob/living/simple_animal/mushroom/after_deserialize()
	. = ..()
	var/saved_harvest_time = LOAD_CUSTOM_SV("harvest_time")
	harvest_time = (!isnull(saved_harvest_time) && saved_harvest_time > 0)? saved_harvest_time + world.time : 0
	LOAD_SAVED_SEED_OR_SEEDNAME(seed)
	custom_saved = null

/mob/living/simple_animal/mushroom/Initialize()
	if(persistent_id)
		var/old_harvest_time = harvest_time
		. = ..()
		harvest_time = old_harvest_time
	else
		. = ..()