/obj/item/gun/projectile/revolver/simple
	name = ".45 'Chief' RV"
	desc = "Revolver of ancient design. Reliable, but struggles against armored targets. Chambered in .45."
	icon = 'mods/persistence/icons/obj/guns/tier1/revolver.dmi'
	origin_tech = "{'combat':3,'engineering':2,'materials':2}"
	caliber = CALIBER_45
	ammo_type = /obj/item/ammo_casing/fortyfive/simple
	max_shells = 5
	w_class = ITEM_SIZE_NORMAL
	fire_delay = 10
	accuracy = 2
	one_hand_penalty = 1
	force = 5
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/wood = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/projectile/revolver/simple/empty
	starts_loaded = FALSE
