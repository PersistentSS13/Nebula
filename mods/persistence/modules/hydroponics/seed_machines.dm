/obj/machinery/botany/extractor/before_save()
	. = ..()
	SAVE_SEED_OR_SEEDNAME(genetics)

/obj/machinery/botany/extractor/after_deserialize()
	. = ..()
	LOAD_SAVED_SEED_OR_SEEDNAME(genetics)
	custom_saved = null
