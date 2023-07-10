/obj/item/gun/projectile/shotgun/handmade
	name = "12g 'Slider' SG"
	desc = "Break-action shotgun of dubious origin. Shoddy craftsmanship results in extremely low ammo capacity and high recoil. Chambered in 12 gauge."
	icon = 'mods/persistence/icons/obj/guns/tier0/shotgun.dmi'
	load_method = SINGLE_CASING
	handle_casings = HOLD_CASINGS
	max_shells = 1
	w_class = ITEM_SIZE_HUGE
	force = 5 // lacks a butt for effective rifle-whipping
	slot_flags = SLOT_BACK
	caliber = CALIBER_SHOTGUN
	origin_tech = "{'combat':2,'engineering':1,'materials':1}"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	screen_shake = 2
	accuracy = -1
	one_hand_penalty = 10
	material = /decl/material/solid/wood
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/projectile/shotgun/handmade/empty
	starts_loaded = FALSE
