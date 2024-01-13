/obj/item/clothing/Initialize()
	// Call on_attached on each accessory to allow for the addition of verbs etc.
	if(persistent_id)
		if(islist(starting_accessories))
			starting_accessories.Cut()
		if(length(accessories))
			for(var/obj/item/clothing/accessory/A in accessories)
				A.on_attached(src, null)
				if(A.removable)
					src.verbs |= /obj/item/clothing/proc/removetie_verb
			update_accessory_slowdown()
			update_icon()
			update_clothing_icon()
	. = ..()

SAVED_VAR(/obj/item/clothing, tint)
SAVED_VAR(/obj/item/clothing, accessories)
SAVED_VAR(/obj/item/clothing, ironed_state)

//Underwears are dumb
SAVED_VAR(/obj/item/underwear, icon)
