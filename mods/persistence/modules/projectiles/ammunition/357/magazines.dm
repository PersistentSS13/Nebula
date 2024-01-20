/obj/item/ammo_magazine/threefiftyseven
	name = "generic .357 speedloader"
	desc = "An unsettlingly generic .357 speedloader."
	icon = 'mods/persistence/icons/obj/ammunition/magazines.dmi'
	icon_state = "3571"
	mag_type = SPEEDLOADER
	caliber = CALIBER_357
	material = /decl/material/solid/metal/steel
	ammo_type = /obj/item/ammo_casing/threefiftyseven
	initial_ammo = 0
	max_ammo = 0
	multiple_sprites = 1

/obj/item/ammo_magazine/box_threefiftyseven
	name = "packet of generic .357 rounds"
	desc = "A packet of unsettlingly generic .357 rounds."
	icon_state = "box_3571"
	icon = 'mods/persistence/icons/obj/ammunition/magazines.dmi'
	material = /decl/material/solid/metal/steel
	caliber = CALIBER_357
	ammo_type = /obj/item/ammo_casing/threefiftyseven
	max_ammo = 12

/obj/item/ammo_magazine/threefiftyseven/tierzero
	name = "makeshift .357 speedloader"
	desc = ".357 speedloader of dubious origin. Suffers from reduced capacity due to flimsy materials and shoddy craftsmanship."
	icon_state = "3570"
	origin_tech = "{'combat':5,'materials':5}"
	material = /decl/material/solid/organic/plastic
	ammo_type = /obj/item/ammo_casing/threefiftyseven/handmade
	max_ammo = 3

/obj/item/ammo_magazine/box_threefiftyseven/tierzero
	name = "packet of makeshift .357 rounds"
	desc = "Container of dubious origin intended for holding loose .357 rounds."
	icon_state = "box_3570"
	origin_tech = "{'combat':5,'materials':5}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/threefiftyseven/handmade

/obj/item/ammo_magazine/threefiftyseven/tierone
	name = "standard .357 speedloader"
	desc = ".357 speedloader of ancient design. Servicable capacity, but outpaced by more modern designs."
	icon_state = "3571"
	origin_tech = "{'combat':8,'materials':8}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT
	)
	ammo_type = /obj/item/ammo_casing/threefiftyseven/simple
	max_ammo = 4

/obj/item/ammo_magazine/box_threefiftyseven/tierone
	name = "packet of standard .357 rounds"
	desc = "Container of ancient design intended for holding loose .357 rounds."
	icon_state = "box_3571"
	origin_tech = "{'combat':8,'materials':8}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/cardboard = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/threefiftyseven/simple

/obj/item/ammo_magazine/threefiftyseven/tiertwo
	name = "advanced .357 speedloader"
	desc = ".357 speedloader of modern design. Improved capacity over earlier designs."
	icon_state = "3572"
	origin_tech = "{'combat':12,'materials':12}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/cardboard = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/threefiftyseven/advanced
	max_ammo = 5

/obj/item/ammo_magazine/box_threefiftyseven/tiertwo
	name = "packet of advanced .357 rounds"
	desc = "Container of modern design intended for holding loose .357 rounds."
	icon_state = "box_3572"
	origin_tech = "{'combat':12,'materials':12}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE,
		/decl/material/solid/organic/cardboard = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/threefiftyseven/advanced
