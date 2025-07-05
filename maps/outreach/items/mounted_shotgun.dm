/obj/item/gun/projectile/shotgun/magshot/mounted
	name             = "mounted automatic shotgun"
	desc             = "A very unwieldy version of an automatic shotgun adapted to be mounted onto remote weapon platforms. As a results, many basic ergonomic and safety features are missing."
	obj_flags        =  OBJ_FLAG_CONDUCTIBLE
	slot_flags       = 0
	load_method      = SINGLE_CASING
	handle_casings   = EJECT_CASINGS
	ammo_type        = /obj/item/ammo_casing/shotgun
	one_hand_penalty = 16
	bulk             = GUN_BULK_RIFLE + 5
	has_safety       = FALSE
	sel_mode         = 1 //Semi-auto

