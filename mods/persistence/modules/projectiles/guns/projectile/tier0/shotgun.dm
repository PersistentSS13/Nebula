/obj/item/gun/projectile/shotgun/handmade
	name = "HM SG 'Slider'"
	desc = "A simple single-barrel shotgun made from a pipe and some spare parts. Inaccurate and sports nigh-unmanageable recoil. Chambered in 12g shells."
	icon = 'mods/persistence/icons/obj/guns/tier0/shotgun.dmi'
	load_method = SINGLE_CASING
	handle_casings = HOLD_CASINGS
	max_shells = 1
	w_class = ITEM_SIZE_HUGE
	force = 5 // lacks a butt for effective rifle-whipping
	slot_flags = SLOT_BACK
	caliber = CALIBER_SHOTGUN
	origin_tech = "{'combat':2,'engineering:'1,'materials':1}"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	screen_shake = 2
	accuracy = -1
	one_hand_penalty = 10

/obj/item/gun/projectile/shotgun/handmade/empty
	starts_loaded = FALSE
