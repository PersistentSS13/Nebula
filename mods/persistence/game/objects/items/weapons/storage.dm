/obj/item/storage/Initialize()
	if(persistent_id)
		startswith = null
	. = ..()

// This is called at Initialize() to match an items storage capabilities to its current items, which is undesirable
// for items which have been loaded.
/obj/item/storage/make_exact_fit()
	if(persistent_id)
		return
	. = ..()

/obj/item/storage/internal/pockets/Initialize(mapload, slots, slot_size)
	if(persistent_id)
		slots = storage_slots
		slot_size = max_w_class
	. = ..()

SAVED_VAR(/obj/item/storage, can_hold)
SAVED_VAR(/obj/item/storage, cant_hold)

// We only save them for this subtype, since they generate them during runtime.
SAVED_VAR(/obj/item/storage/internal/pockets, storage_slots)
SAVED_VAR(/obj/item/storage/internal/pockets, max_w_class)