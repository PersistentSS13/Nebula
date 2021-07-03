//Basic gray softsuit
/obj/item/clothing/head/helmet/space/alt
	name = "EVA softsuit helmet"
	icon = 'mods/persistence/icons/obj/clothing/spacesuits/softsuits/genericspacehelm.dmi'
	desc = "A flimsy helmet designed for work in a hazardous, low-pressure environment."
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)

/obj/item/clothing/suit/space/alt
	name = "EVA softsuit"
	desc = "Your average general use softsuit. Though lacking in protection that modern voidsuits give, its cheap cost and portable size makes it perfect for the pioneer on the go."
	icon = 'mods/persistence/icons/obj/clothing/spacesuits/softsuits/genericspacesuit.dmi'
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank/emergency,
		/obj/item/suit_cooling_unit
		)

//Engineering softsuit
/obj/item/clothing/head/helmet/space/engineering
	name = "engineering softsuit helmet"
	icon = 'mods/persistence/icons/obj/clothing/spacesuits/softsuits/engspacehelm.dmi'
	desc = "A flimsy helmet with basic radiation shielding. Its visor protects the user from bright UV lights."
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)

/obj/item/clothing/suit/space/engineering
	name = "engineering softsuit"
	icon = 'mods/persistence/icons/obj/clothing/spacesuits/softsuits/engspacesuit.dmi'
	desc = "A general use softsuit. The cloth fibers on this suit protect the user from minor amounts of radiation."
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank/emergency,
		/obj/item/suit_cooling_unit,
		/obj/item/storage/toolbox,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/t_scanner
		)

//Security softsuit
/obj/item/clothing/head/helmet/space/security
	name= "security softsuit helmet"
	icon = 'mods/persistence/icons/obj/clothing/spacesuits/softsuits/secspacehelm.dmi'
	desc = "A flimsy helmet equipped with heat-resistent fabric."
	armor = list(
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bio = ARMOR_BIO_SHIELDED,
		)

/obj/item/clothing/suit/space/security
	name = "security softsuit"
	icon = 'mods/persistence/icons/obj/clothing/spacesuits/softsuits/secspacesuit.dmi'
	desc = "A general use softsuit equipped with heat-resistent fabric."
	armor = list(
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bio = ARMOR_BIO_SHIELDED,
		)

//Medical softsuit
/obj/item/clothing/head/helmet/space/medical
	name = "medical softsuit helmet"
	icon = 'mods/persistence/icons/obj/clothing/spacesuits/softsuits/medspacehelm.dmi'
	desc = "A flimsy helmet that protects the user just enough to be considered spaceworthy."
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		)
	flash_protection = FLASH_PROTECTION_NONE

/obj/item/clothing/suit/space/medical
	name = "medical softsuit"
	icon = 'mods/persistence/icons/obj/clothing/spacesuits/softsuits/medspacesuit.dmi'
	desc = "A general use softsuit that sacrifices radiation shielding in turn for enhanced mobility."
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		)
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank/emergency,
		/obj/item/suit_cooling_unit,
		/obj/item/storage/firstaid,
		/obj/item/scanner/health,
		/obj/item/stack/medical
		)

/obj/item/clothing/suit/space/medical/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 0.5)

//Mining softsuit
/obj/item/clothing/head/helmet/space/mining
	name = "mining softsuit helmet"
	icon = 'mods/persistence/icons/obj/clothing/spacesuits/softsuits/minerspacehelm.dmi'
	desc = "A flimsy helmet equipped with extra thick fabric."
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
		)

/obj/item/clothing/suit/space/mining
	name = "mining softsuit"
	icon = 'mods/persistence/icons/obj/clothing/spacesuits/softsuits/minerspacesuit.dmi'
	desc = "A general use softsuit equipped with extra thick fabric."
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
		)
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank/emergency,
		/obj/item/stack/flag,
		/obj/item/suit_cooling_unit,
		/obj/item/storage/ore,
		/obj/item/pickaxe
		)

//Science softsuit
/obj/item/clothing/head/helmet/space/science
	name = "scientist softsuit helmet"
	icon = 'mods/persistence/icons/obj/clothing/spacesuits/softsuits/scispacehelm.dmi'
	desc = "A flimsy helmet that provides basic protection from radiation."
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)

/obj/item/clothing/suit/space/science
	name = "scientist softsuit"
	icon = 'mods/persistence/icons/obj/clothing/spacesuits/softsuits/scispacesuit.dmi'
	desc = "A general use softsuit retrofitted with basic radiation shielding."
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank/emergency,
		/obj/item/suit_cooling_unit,
		/obj/item/stack/flag,
		/obj/item/storage/excavation,
		/obj/item/pickaxe,
		/obj/item/scanner/health,
		/obj/item/measuring_tape,
		/obj/item/ano_scanner,
		/obj/item/depth_scanner,
		/obj/item/core_sampler,
		/obj/item/gps,
		/obj/item/pinpointer/radio,
		/obj/item/radio/beacon,
		/obj/item/pickaxe/xeno,
		/obj/item/storage/bag/fossils
		)

//Emergency softsuit
/obj/item/clothing/head/helmet/space/emergency/alt
	name = "emergency softsuit helmet"
	icon = 'mods/persistence/icons/obj/clothing/spacesuits/softsuits/crisisspacehelm.dmi'
	desc = "A simple helmet with a built in light, smells like mothballs."
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		)

/obj/item/clothing/suit/space/emergency/alt
	name = "emergency softsuit"
	icon = 'mods/persistence/icons/obj/clothing/spacesuits/softsuits/crisisspacesuit.dmi'
	desc = "A thin, ungainly softsuit colored in blaze orange for rescuers to easily locate, looks pretty fragile."
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		)
	allowed = list(
		/obj/item/tank/emergency,
		/obj/item/suit_cooling_unit
		)

//We don't need the 4.0 speed debuff that the default variant has
/obj/item/clothing/suit/space/emergency/alt/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1.0)