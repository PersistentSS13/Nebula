/obj/item/seeds/before_save()
	. = ..()
	SAVE_SEED(seed)

/obj/item/seeds/after_deserialize()
	. = ..()
	LOAD_SAVED_SEED(seed, seed_type)
	custom_saved = null
