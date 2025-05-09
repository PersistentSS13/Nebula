/obj/item/gun/energy/laser/rifle/tierzero
	name = "Laser 'Tagger' T0-EG"
	desc = "Laser rifle of dubious origin. Shoddy craftsmanship results in low charge capacity and weak output. Fires Alpha-type laser beams."
	icon = 'mods/persistence/icons/obj/guns/tier0/lasrifle.dmi'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	force = 5 // also lacks a butt for effective rifle-whippery
	one_hand_penalty = 3
	max_shots = 3
	fire_delay = 15
	origin_tech = "{'combat':5,'engineering':5,'materials':2,'magnets':2}"
	projectile_type = /obj/item/projectile/beam/smalllaser
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE
	)
