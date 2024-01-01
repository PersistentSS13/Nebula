/obj/item/gun/projectile/revolver/advanced
	name = ".357 'Officer' RV"
	desc = "Revolver of modern design. Uses high-power rounds and has better ammunition capacity and accuracy compared to older models. Chambered in .357."
	icon = 'mods/persistence/icons/obj/guns/tier2/revolver.dmi'
	origin_tech = "{'combat':4,'engineering':3,'materials':4}"
	caliber = CALIBER_357
	ammo_type = /obj/item/ammo_casing/threefiftyseven/advanced
	max_shells = 5
	w_class = ITEM_SIZE_NORMAL
	fire_delay = 10
	accuracy = 1
	one_hand_penalty = 2
	force = 5
	material = /decl/material/solid/metal/titanium
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/plastic = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/projectile/revolver/advanced/empty
	starts_loaded = FALSE