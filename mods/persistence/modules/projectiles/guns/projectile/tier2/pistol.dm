/obj/item/gun/projectile/pistol/advanced
	name = ".45 'Paco' HG"
	desc = "Pistol of modern design. Highly accurate, and boasts a reduced fire delay compared to earlier models. Chambered in .45."
	icon = 'mods/persistence/icons/obj/guns/tier2/pistol.dmi'
	caliber = CALIBER_45
	fire_delay = 3
	force = 5
	accuracy = 2
	one_hand_penalty = 1
	origin_tech = "{'combat':4,'engineering':3,'materials':4}"
	ammo_indicator = FALSE
	w_class = ITEM_SIZE_NORMAL
	magazine_type = /obj/item/ammo_magazine/fortyfive/advanced
	allowed_magazines = /obj/item/ammo_magazine/fortyfive
	material = /decl/material/solid/metal/titanium
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/projectile/pistol/advanced/empty
	starts_loaded = FALSE