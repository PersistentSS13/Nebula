/obj/item/gun/projectile/revolver/tierzero
	name = ".45 'Underdog' T0-RV"
	desc = "Revolver of dubious origin. Shoddy craftsmanship results in low ammo capacity and high recoil. Chambered in .45."
	icon = 'mods/persistence/icons/obj/guns/tier0/revolver.dmi'
	origin_tech = "{'combat':5,'engineering':5,'materials':2}"
	caliber = CALIBER_45
	ammo_type = /obj/item/ammo_casing/fortyfive/handmade
	max_shells = 3
	w_class = ITEM_SIZE_NORMAL
	fire_delay = 12
	accuracy = -1
	one_hand_penalty = 2
	force = 5
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/wood = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/projectile/revolver/tierzero/empty
	starts_loaded = FALSE
