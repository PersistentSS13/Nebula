/obj/item/gun/projectile/revolver/handmade
	name = "HM R 'Underdog'"
	desc = "A jury-rigged weapon fashioned not too dissimilarly to a revolver. While usable one-handed, it doesn't lend itself to it. Chambered in 10mm rounds."
	icon = 'mods/persistence/icons/obj/guns/tier0/revolver.dmi'
	origin_tech = "{'combat':2,'engineering':1,'materials':1}"
	caliber = CALIBER_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	max_shells = 3
	w_class = ITEM_SIZE_NORMAL
	fire_delay = 12
	accuracy = -1
	one_hand_penalty = 2
	force = 5
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/wood = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/projectile/revolver/handmade/empty
	starts_loaded = FALSE
