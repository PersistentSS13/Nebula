/obj/item/gun/projectile/bolt_action/handmade
	name = "5.56 'Minuteman' BA"
	desc = "Bolt-action rifle of dubious origin. Shoddy craftsmanship results in extremely low ammo capacity. Chambered in 5.56."
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
	material = /decl/material/solid/wood
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/projectile/bolt_action/handmade/empty
	starts_loaded = FALSE
