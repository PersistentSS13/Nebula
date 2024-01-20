/obj/item/gun/projectile/revolver/tiertwo
	name = ".357 'Officer' T2-RV"
	desc = "Revolver of modern design. Uses high-power rounds and has better ammunition capacity and accuracy compared to older models. Chambered in .357."
	icon = 'mods/persistence/icons/obj/guns/tier2/revolver.dmi'
	origin_tech = "{'combat':15,'engineering':15,'materials':6}"
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
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/projectile/revolver/tiertwo/empty
	starts_loaded = FALSE
