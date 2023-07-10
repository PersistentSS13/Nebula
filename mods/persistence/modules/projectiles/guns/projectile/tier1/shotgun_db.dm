/obj/item/gun/projectile/shotgun/simple
	name = "12g 'Bouncer' SG"
	desc = "Break-action shotgun of ancient design. Powerful, but struggles in prolonged engagements due to low ammo capacity. Can fire one or both chambers at a time. Chambered in 12 gauge."
	icon = 'mods/persistence/icons/obj/guns/tier1/shotgun_db.dmi'
	load_method = SINGLE_CASING
	handle_casings = HOLD_CASINGS
	max_shells = 2
	w_class = ITEM_SIZE_HUGE
	force = 10
	slot_flags = SLOT_BACK
	caliber = CALIBER_SHOTGUN
	origin_tech = "{'combat':3,'engineering':2,'materials':2}"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	screen_shake = 1
	accuracy = 0
	one_hand_penalty = 10
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/wood = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)
	burst_delay = 0
	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
		list(mode_name="fire both barrels at once", burst=2)
	)

/obj/item/gun/projectile/shotgun/simple/empty
	starts_loaded = FALSE
