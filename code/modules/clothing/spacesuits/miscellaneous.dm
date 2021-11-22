//Orange emergency space suit
/obj/item/clothing/head/helmet/space/emergency
	name = "emergency space helmet"
	icon = 'icons/clothing/spacesuit/emergency/helmet.dmi'
	desc = "A flimsy helmet that barely protects against vacuum. Intended to be easy to spot for rescuers."
	flash_protection = FLASH_PROTECTION_NONE

/obj/item/clothing/suit/space/emergency
	name = "emergency softsuit"
	icon = 'icons/clothing/spacesuit/emergency/suit.dmi'
	desc = "A thin, ungainly softsuit in bright orange paint. While cheap, it is flimsy and difficult to move around in."

/obj/item/clothing/suit/space/emergency/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 4)
