/obj/effect/decal/cleanable
	should_save = TRUE

/obj/effect/decal/cleanable/blood/should_save()
	. = ..()
	//Only bother saving if they're not dry
	//Dried puddles lose all forensic properties..
	return . && (world.time <= drytime)

/obj/effect/decal/cleanable/blood/before_save()
	. = ..()
	CUSTOM_SV("drytime", max(0, drytime - world.time))

/obj/effect/decal/cleanable/blood/after_deserialize()
	. = ..()
	var/_drytime = LOAD_CUSTOM_SV("drytime")
	//Don't care if its 0, so we properly apply drying effects
	drytime = _drytime + world.time
	CLEAR_SV("drytime")

/obj/effect/decal/cleanable/blood/Initialize()
	. = ..()
	//Make sure the thing is dried now if needed so we don't waste time processing it
	if(world.time > drytime)
		dry()