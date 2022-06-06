/obj/item/gun/projectile/bolt_action/simple
	name = "ZSS BA 'Mosin'"
	desc = "The Mosin model is a particularly ancient design. Very little is known about its origins, but in the modern day Mosin models are mostly produced for hunting purposes. However, due to its ease of production and decent loading capacity, many colonist and rebel groups use Mosin rifles in their armies. Chambered in 5.56mm rounds."
	icon = 'mods/persistence/icons/obj/guns/tier1/boltaction.dmi'
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = "{'combat':3,'engineering':2,'materials':2}"
	caliber = CALIBER_RIFLE
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/rifle
	one_hand_penalty = 10
	fire_delay = 12
	accuracy = 0

/obj/item/gun/projectile/bolt_action/simple/empty
	starts_loaded = FALSE