/obj/item/gun/projectile/shotgun/pump/simple
	name = "ZSS SG 'Teufort'"
	desc = "A straightforward pump-action shotgun intended for hunting medium-sized game. The Teufort isn't one of the first or best pump shotguns to exist, but its fairly cheap for how effective it is. Chambered in 12g shells."
	icon = 'mods/persistence/icons/obj/guns/tier1/shotgun_pump.dmi'
	max_shells = 5
	fire_delay = 12
	w_class = ITEM_SIZE_HUGE
	force = 10
	slot_flags = SLOT_BACK
	caliber = CALIBER_SHOTGUN
	origin_tech = "{'combat':3,'engineering':2,'materials':2}"
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	handle_casings = HOLD_CASINGS
	one_hand_penalty = 10
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/wood = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/plasteel = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/projectile/shotgun/pump/simple/empty
	starts_loaded = FALSE
