/obj/item/ammo_magazine/fortyfive
	name = "generic .45 magazine"
	desc = "An unsettlingly generic .45 magazine."
	icon = 'mods/persistence/icons/obj/ammunition/magazines.dmi'
	icon_state = "451"
	mag_type = MAGAZINE
	caliber = CALIBER_45
	material = /decl/material/solid/metal/steel
	ammo_type = /obj/item/ammo_casing/fortyfive
	initial_ammo = 0
	max_ammo = 0
	multiple_sprites = 1

/obj/item/ammo_magazine/box/fortyfive
	name = "packet of generic .45 rounds"
	desc = "A packet of unsettlingly generic .45 rounds."
	icon_state = "box_451"
	icon = 'mods/persistence/icons/obj/ammunition/magazines.dmi'
	material = /decl/material/solid/metal/steel
	caliber = CALIBER_45
	ammo_type = /obj/item/ammo_casing/fortyfive
	max_ammo = 20

/obj/item/ammo_magazine/fortyfive/handmade
	name = "makeshift .45 magazine"
	desc = ".45 magazine of dubious origin. Suffers from reduced capacity due to flimsy materials and shoddy craftsmanship."
	icon_state = "450"
	origin_tech = "{'combat':1}"
	material = /decl/material/solid/organic/plastic
	ammo_type = /obj/item/ammo_casing/fortyfive/handmade
	max_ammo = 3

/obj/item/ammo_magazine/box/fortyfive/handmade
	name = "packet of makeshift .45 rounds"
	desc = "Container of dubious origin intended for holding loose .45 rounds."
	icon_state = "box_450"
	origin_tech = "{'combat':1,'materials':1}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/fortyfive/handmade

/obj/item/ammo_magazine/fortyfive/simple
	name = "standard .45 magazine"
	desc = ".45 magazine of ancient design. Servicable capacity, but outpaced by more modern designs."
	icon_state = "451"
	origin_tech = "{'combat':2}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT
	)
	ammo_type = /obj/item/ammo_casing/fortyfive/simple
	max_ammo = 7

/obj/item/ammo_magazine/box/fortyfive/simple
	name = "packet of standard .45 rounds"
	desc = "Container of ancient design intended for holding loose .45 rounds."
	icon_state = "box_451"
	origin_tech = "{'combat':2,'materials':2}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/cardboard = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/fortyfive/simple