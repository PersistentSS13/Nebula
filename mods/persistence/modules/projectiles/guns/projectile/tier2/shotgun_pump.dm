/obj/item/gun/projectile/shotgun/pump/advanced
	name = "12g 'Gladdy' T2-SG"
	desc = "Pump-action shotgun of modern design. Possesses an increased ammunition capacity and shorter fire delay compared to earlier models . Chambered in 12 gauge."
	icon = 'mods/persistence/icons/obj/guns/tier2/shotgun_pump.dmi'
	max_shells = 7
	fire_delay = 8
	w_class = ITEM_SIZE_HUGE
	force = 10
	slot_flags = SLOT_BACK
	caliber = CALIBER_12G
	origin_tech = "{'combat':15,'engineering':15,'materials':6}"
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/twelvegauge/slug/advanced
	handle_casings = HOLD_CASINGS
	one_hand_penalty = 10
	material = /decl/material/solid/metal/titanium
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/projectile/shotgun/pump/advanced/empty
	starts_loaded = FALSE
