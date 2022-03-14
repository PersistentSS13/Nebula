/datum/seed_pile
	should_save = TRUE

/datum/seed_pile/New(var/obj/item/seeds/O, var/ID)
	if(!O)
		return //Hack to allow saved seed_piles to load from save
	. = ..()

/datum/seed_pile/before_save()
	. = ..()
	SAVE_SEED_OR_SEEDNAME(seed_type)

/datum/seed_pile/after_deserialize()
	. = ..()
	LOAD_SAVED_SEED_OR_SEEDNAME(seed_type)
	custom_saved = null

// Seed storage machine
/obj/machinery/seed_storage/Initialize(mapload)
	if(persistent_id)
		starting_seeds = null //Don't let the thing spawn duplcates
	. = ..()

