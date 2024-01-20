/obj/item/gun/projectile/bolt_action/tierone
	name = "5.56x45mm 'Mosin' T1-BA"
	desc = "Bolt-action rifle of ancient design. Reliable, but slow-firing. Chambered in 5.56x45mm."
	icon = 'mods/persistence/icons/obj/guns/tier1/boltaction.dmi'
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = "{'combat':10,'engineering':10,'materials':4}"
	caliber = CALIBER_556
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 5
	w_class = ITEM_SIZE_HUGE
	ammo_type = /obj/item/ammo_casing/fivefiftysix
	one_hand_penalty = 10
	fire_delay = 12
	accuracy = 0
	material = /decl/material/solid/organic/wood
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/projectile/bolt_action/tierone/empty
	starts_loaded = FALSE
