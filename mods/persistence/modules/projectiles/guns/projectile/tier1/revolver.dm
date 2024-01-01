/obj/item/gun/projectile/revolver/simple
	name = ".357 'Chief' RV"
	desc = "Revolver of ancient design. Uses high-power rounds, but struggles with a low ammunition capacity and poor armor penetration. Chambered in .357."
	icon = 'mods/persistence/icons/obj/guns/tier1/revolver.dmi'
	origin_tech = "{'combat':3,'engineering':2,'materials':2}"
	caliber = CALIBER_357
	ammo_type = /obj/item/ammo_casing/threefiftyseven/simple
	max_shells = 4
	w_class = ITEM_SIZE_NORMAL
	fire_delay = 10
	accuracy = 0
	one_hand_penalty = 2
	force = 5
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/wood = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/projectile/revolver/simple/empty
	starts_loaded = FALSE
