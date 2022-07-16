// Override since storage recreates pockets on load.
// TODO: Move the creation upstream to a new proc.
/obj/item/clothing/suit/storage/Initialize()
	if(persistent_id && pockets)
		var/old_pockets = pockets
		. = ..()
		QDEL_NULL(pockets)
		pockets = old_pockets
	else
		return ..()