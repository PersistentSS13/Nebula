/obj/machinery/portable_atmospherics/hydroponics/before_save()
	. = ..()
	if(temp_chem_holder && round(temp_chem_holder.reagents.total_volume) > 0)
		CUSTOM_SV("temp_chem_holder", temp_chem_holder)
	SAVE_SEED_OR_SEEDNAME(seed)

	//Save time dependent stuff
	var/saved_last_cycle = max(lastcycle - world.time, 0)
	CUSTOM_SV("saved_last_cycle", saved_last_cycle)
	var/saved_last_produce = max(lastproduce - world.time, 0)
	CUSTOM_SV("saved_last_produce", saved_last_produce)

/obj/machinery/portable_atmospherics/hydroponics/after_deserialize()
	. = ..()
	var/obj/saved_chemholder = LOAD_CUSTOM_SV("temp_chem_holder")
	if(saved_chemholder)
		temp_chem_holder = saved_chemholder
	LOAD_SAVED_SEED_OR_SEEDNAME(seed)

	lastcycle = LOAD_CUSTOM_SV("saved_last_cycle")
	lastproduce = LOAD_CUSTOM_SV("saved_last_produce")
	if(lastcycle)
		lastcycle += world.time
	if(lastproduce)
		lastproduce += world.time

/obj/machinery/portable_atmospherics/hydroponics/Initialize()
	if(persistent_id)
		//The init just does a lot of damage so gotta do a lot of copying beforehand
		var/obj/prev_temp_chem_holder = temp_chem_holder
		temp_chem_holder = null
		. = ..()
		if(prev_temp_chem_holder)
			QDEL_NULL(temp_chem_holder)
			temp_chem_holder = prev_temp_chem_holder
		if(. != INITIALIZE_HINT_QDEL)
			return INITIALIZE_HINT_NORMAL // Don't let it lateinit because it might attempt to plant anything that might be on the same tile
	else
		. = ..()

/obj/machinery/portable_atmospherics/hydroponics/soil/attackby(obj/item/O, mob/user)
	if(IS_SHOVEL(O))
		var/obj/item/shovel/S = O
		if(S.do_tool_interaction(TOOL_SHOVEL, user, src, 10 SECONDS, "flattening", "flattening", null, null, SKILL_HAULING) && !QDELETED(O))
			physically_destroyed()
		return TRUE
	. = ..()

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/Initialize(mapload, datum/seed/newseed, start_mature)
	if(persistent_id)
		newseed = seed
	else if(istext(newseed))
		newseed = SSplants.seeds[newseed]

	// TODO: As above, Init resets health. Move things into appropriate procs upstream when possible.
	var/old_health = plant_health
	. = ..(mapload, newseed, start_mature)
	plant_health = old_health
	check_plant_health()