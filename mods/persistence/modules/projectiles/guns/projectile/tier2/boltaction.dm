/obj/item/gun/projectile/bolt_action/advanced
	name = "5.56x45mm 'Deadshot' BA"
	desc = "Bolt-action rifle of modern design. Accurate, and comes with a built-in 2x scope alongside an increased ammunition capacity compared to earlier models. Chambered in 5.56x45mm."
	icon = 'mods/persistence/icons/obj/guns/tier2/boltaction.dmi'
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = @'{"combat":4,"engineering":4,"materials":3}'
	caliber = CALIBER_556
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 7
	w_class = ITEM_SIZE_HUGE
	ammo_type = /obj/item/ammo_casing/fivefiftysix
	one_hand_penalty = 10
	fire_delay = 10
	accuracy = 2
	scoped_accuracy = 5
	scope_zoom = 2
	material = /decl/material/solid/metal/titanium
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/projectile/bolt_action/advanced/empty
	starts_loaded = FALSE