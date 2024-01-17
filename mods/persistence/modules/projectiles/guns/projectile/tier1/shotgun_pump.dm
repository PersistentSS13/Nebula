/obj/item/gun/projectile/shotgun/pump/simple
	name = "12g 'Teufort' T1-SG"
	desc = "Pump-action shotgun of ancient design. Powerful, but fires slowly due to pump-action mechanism and high recoil. Chambered in 12 gauge."
	icon = 'mods/persistence/icons/obj/guns/tier1/shotgun_pump.dmi'
	max_shells = 5
	fire_delay = 12
	w_class = ITEM_SIZE_HUGE
	force = 10
	slot_flags = SLOT_BACK
	caliber = CALIBER_12G
	origin_tech = "{'combat':10,'engineering':10,'materials':4}"
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/twelvegauge/slug/simple
	handle_casings = HOLD_CASINGS
	one_hand_penalty = 10
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/wood = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/titanium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/projectile/shotgun/pump/simple/empty
	starts_loaded = FALSE
