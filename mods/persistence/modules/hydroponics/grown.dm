/obj/item/chems/food/grown/before_save()
	. = ..()
	SAVE_SEED_OR_SEEDNAME(seed)

/obj/item/chems/food/grown/after_deserialize()
	. = ..()
	LOAD_SAVED_SEED_OR_SEEDNAME(seed)
	if(seed)
		plantname = seed.name //The seed is replaced on init by whatever seed matches the plantname...
	custom_saved = null

/obj/item/chems/food/grown/fill_reagents()
	//Yay for people not cutting up their code into several procs!
	if(persistent_id && seed && seed.chems)
		potency = seed.get_trait(TRAIT_POTENCY)
		update_desc()
		if(reagents.total_volume > 0)
			bitesize = 1+round(reagents.total_volume / 2, 1)
		return
	. = ..()

//Fruit slices are cursed
/obj/item/chems/food/fruit_slice/Initialize(mapload, var/datum/seed/S)
	if(!istype(S) && seed)
		S = seed //Have to do this otherwise it'll qdel on init if there's no seed as paramter! Fun!
	. = ..(mapload, S) 

/obj/item/chems/food/fruit_slice/before_save()
	. = ..()
	SAVE_SEED_OR_SEEDNAME(seed)

/obj/item/chems/food/fruit_slice/after_deserialize()
	. = ..()
	LOAD_SAVED_SEED_OR_SEEDNAME(seed)
	custom_saved = null