/obj/item/grown/before_save()
	. = ..()
	if(plantname)
		var/datum/seed/sref = SSplants.seeds[plantname]
		CUSTOM_SV("saved_seed_ref", sref)

/obj/item/grown/after_deserialize()
	. = ..()
	var/datum/seed/sref = LOAD_CUSTOM_SV("saved_seed_ref")
	if(sref)
		SSplants.seeds[sref.name] = sref //Makes sure the seed is actually loaded before we need it

/obj/item/grown/Initialize(mapload, planttype)
	if(persistent_id)
		planttype = plantname
		if(planttype && !SSplants.seeds[planttype])
			log_debug("Seems like the seed '[src]' uses isn't loaded yet?? This is bad.")
	. = ..(mapload, planttype)
	