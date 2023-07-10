/obj/item/gun/projectile/revolver/handmade
	name = "10mm 'Underdog' RV"
	desc = "Revolver of dubious origin. Shoddy craftsmanship results in low ammo capacity and high recoil. Chambered in 10mm."
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
