/obj/item/gun/projectile/bolt_action/handmade
	name = "HM BA 'Minuteman'"
	desc = "A homemade bolt-action rifle of dubious quality. While it can chamber high-damage ammunition, it's difficult to load and rather inaccurate for a rifle. It's still favored by colonists for being effective for its low cost. Chambered in 5.56mm rounds."
	icon = 'mods/persistence/icons/obj/guns/tier0/boltaction.dmi'
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = "{'combat':2,'engineering':1,'materials':1}"
	caliber = CALIBER_RIFLE
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/rifle
	one_hand_penalty = 20
	fire_delay = 20
	accuracy = -1

/obj/item/gun/projectile/bolt_action/handmade/empty
	starts_loaded = FALSE