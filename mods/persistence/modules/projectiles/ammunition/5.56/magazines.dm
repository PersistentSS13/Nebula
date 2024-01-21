/obj/item/ammo_magazine/fivefiftysix
	name = "generic 5.56x45mm magazine"
	desc = "An unsettlingly generic 5.56x45mm magazine."
	icon = 'mods/persistence/icons/obj/ammunition/magazines.dmi'
	icon_state = "5561"
	mag_type = MAGAZINE
	caliber = CALIBER_556
	material = /decl/material/solid/metal/steel
	ammo_type = /obj/item/ammo_casing/fivefiftysix
	initial_ammo = 0
	max_ammo = 0
	multiple_sprites = 1

/obj/item/ammo_magazine/box_fivefiftysix
	name = "packet of generic 5.56x45mm rounds"
	desc = "A packet of unsettlingly generic 5.56x45mm rounds."
	icon_state = "box_5561"
	icon = 'mods/persistence/icons/obj/ammunition/magazines.dmi'
	material = /decl/material/solid/metal/steel
	caliber = CALIBER_556
	ammo_type = /obj/item/ammo_casing/fivefiftysix
	max_ammo = 50

/obj/item/ammo_magazine/fivefiftysix/tierzero
	name = "makeshift 5.56x45mm magazine"
	desc = "5.56x45mm magazine of dubious origin. Suffers from reduced capacity due to flimsy materials and shoddy craftsmanship."
	icon_state = "5560"
	origin_tech = "{'combat':5,'materials':5}"
	material = /decl/material/solid/organic/plastic
	ammo_type = /obj/item/ammo_casing/fivefiftysix/tierzero
	max_ammo = 12

/obj/item/ammo_magazine/box_fivefiftysix/tierzero
	name = "packet of makeshift 5.56x45mm rounds"
	desc = "Container of dubious origin intended for holding loose 5.56x45mm rounds."
	icon_state = "box_5560"
	origin_tech = "{'combat':1,'materials':1}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/fivefiftysix/tierzero

/obj/item/ammo_magazine/fivefiftysix/tierone
	name = "standard 5.56x45mm magazine"
	desc = "5.56x45mm magazine of ancient design. Servicable capacity, but outpaced by more modern designs."
	icon_state = "5561"
	origin_tech = "{'combat':2}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT
	)
	ammo_type = /obj/item/ammo_casing/fivefiftysix/tierone
	max_ammo = 20

/obj/item/ammo_magazine/box_fivefiftysix/tierone
	name = "packet of standard 5.56x45mm rounds"
	desc = "Container of ancient design intended for holding loose 5.56x45mm rounds."
	icon_state = "box_5561"
	origin_tech = "{'combat':2,'materials':2}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/cardboard = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/fivefiftysix/tierone

/obj/item/ammo_magazine/fivefiftysix/tiertwo
	name = "advanced 5.56x45mm magazine"
	desc = "5.56x45mm magazine of modern design. Good capacity compared to earlier models."
	icon_state = "5562"
	origin_tech = "{'combat':3}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT
	)
	ammo_type = /obj/item/ammo_casing/fivefiftysix/tiertwo
	max_ammo = 30

/obj/item/ammo_magazine/box_fivefiftysix/tiertwo
	name = "packet of advanced 5.56x45mm rounds"
	desc = "Container of modern design intended for holding loose 5.56x45mm rounds."
	icon_state = "box_5562"
	origin_tech = "{'combat':3,'materials':3}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE,
		/decl/material/solid/organic/cardboard = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/fivefiftysix/tiertwo