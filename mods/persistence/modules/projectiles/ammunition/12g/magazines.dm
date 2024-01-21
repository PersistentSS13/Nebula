/obj/item/ammo_magazine/box_twelvegauge
	name = "packet of generic 12g shells"
	desc = "A packet of unsettlingly generic 12g shells."
	icon_state = "box_12g1_slug"
	icon = 'mods/persistence/icons/obj/ammunition/magazines.dmi'
	material = /decl/material/solid/metal/steel
	caliber = CALIBER_12G
	ammo_type = /obj/item/ammo_casing/twelvegauge
	max_ammo = 16

/obj/item/ammo_magazine/box_twelvegauge/slug
	name = "packet of generic 12g slug shells"
	desc = "A packet of unsettlingly generic 12g slug shells."
	icon_state = "box_12g1_slug"
	ammo_type = /obj/item/ammo_casing/twelvegauge/slug

/obj/item/ammo_magazine/box_twelvegauge/buckshot
	name = "packet of generic 12g buckshot shells"
	desc = "A packet of unsettlingly generic 12g buckshot shells."
	icon_state = "box_12g1_buckshot"
	ammo_type = /obj/item/ammo_casing/twelvegauge/buckshot

/obj/item/ammo_magazine/box_twelvegauge/slug/tierzero
	name = "packet of makeshift 12g slug shells"
	desc = "Container of dubious origin intended for holding loose 12g slug shells."
	icon_state = "box_12g0_slug"
	origin_tech = "{'combat':5,'materials':5}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/twelvegauge/slug/tierzero

/obj/item/ammo_magazine/box_twelvegauge/buckshot/tierzero
	name = "packet of makeshift 12g buckshot shells"
	desc = "Container of dubious origin intended for holding loose 12g buckshot shells."
	icon_state = "box_12g0_buckshot"
	origin_tech = "{'combat':5,'materials':5}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/twelvegauge/buckshot/tierzero

/obj/item/ammo_magazine/box_twelvegauge/slug/tierone
	name = "packet of standard 12g slug shells"
	desc = "Container of ancient design intended for holding loose 12g slug shells."
	icon_state = "box_12g1_slug"
	origin_tech = "{'combat':8,'materials':8}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/cardboard = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/twelvegauge/slug/tierone

/obj/item/ammo_magazine/box_twelvegauge/buckshot/tierone
	name = "packet of standard 12g buckshot shells"
	desc = "Container of ancient design intended for holding loose 12g buckshot shells."
	icon_state = "box_12g1_buckshot"
	origin_tech = "{'combat':8,'materials':8}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/cardboard = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/twelvegauge/buckshot/tierone

/obj/item/ammo_magazine/box_twelvegauge/slug/tiertwo
	name = "packet of advanced 12g slug shells"
	desc = "Container of modern design intended for holding loose 12g slug shells."
	icon_state = "box_12g2_slug"
	origin_tech = "{'combat':12,'materials':12}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE,
		/decl/material/solid/organic/cardboard = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/twelvegauge/slug/tiertwo

/obj/item/ammo_magazine/box_twelvegauge/buckshot/tiertwo
	name = "packet of advanced 12g buckshot shells"
	desc = "Container of modern design intended for holding loose 12g buckshot shells."
	icon_state = "box_12g2_buckshot"
	origin_tech = "{'combat':12,'materials':12}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE,
		/decl/material/solid/organic/cardboard = MATTER_AMOUNT_TRACE
	)
	ammo_type = /obj/item/ammo_casing/twelvegauge/buckshot/tiertwo
