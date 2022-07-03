// Don't create multiple storage containers
/obj/item/clothing/accessory/storage/create_storage()
	if(persistent_id)
		return
	. = ..()

// Additional override since this doesn't call parent
/obj/item/clothing/accessory/storage/drop_pouches/create_storage()
	if(persistent_id)
		return
	. = ..()

SAVED_VAR(/obj/item/clothing/accessory/storage, hold)