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

SAVED_VAR(/obj/item/storage, opened)
// We only save them for this subtype, since they generate them during runtime.
SAVED_VAR(/obj/item/storage/internal/pockets, storage_slots)
SAVED_VAR(/obj/item/storage/internal/pockets, max_w_class)

// Only subtypes which call make_exact_fit() need to save these variables.
SAVED_VAR(/obj/item/storage/box/glasses, can_hold)
SAVED_VAR(/obj/item/storage/box/glasses, storage_slots)

SAVED_VAR(/obj/item/storage/box/mixed_glasses, can_hold)
SAVED_VAR(/obj/item/storage/box/mixed_glasses, storage_slots)

SAVED_VAR(/obj/item/storage/csi_markers, can_hold)
SAVED_VAR(/obj/item/storage/csi_markers, storage_slots)

SAVED_VAR(/obj/item/storage/secure/briefcase/heavysniper, can_hold)
SAVED_VAR(/obj/item/storage/secure/briefcase/heavysniper, storage_slots)

SAVED_VAR(/obj/item/storage/mre, can_hold)
SAVED_VAR(/obj/item/storage/mre, storage_slots)

SAVED_VAR(/obj/item/storage/med_pouch, can_hold)
SAVED_VAR(/obj/item/storage/med_pouch, storage_slots)

SAVED_VAR(/obj/item/storage/box/lights, can_hold)
SAVED_VAR(/obj/item/storage/box/lights, storage_slots)

SAVED_VAR(/obj/item/storage/bible, can_hold)
SAVED_VAR(/obj/item/storage/bible, storage_slots)