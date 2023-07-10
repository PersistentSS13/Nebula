/obj/item/gun/energy/laser/rifle/simple
	name = "Laser 'Marine' EG"
	desc = "Laser rifle used by modern spacers. Powerful, but bulky and suffers from low charge capacity. Fires Beta-type laser beams."
	icon = 'mods/persistence/icons/obj/guns/tier1/lasrifle.dmi'
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_HUGE
	one_hand_penalty = 3
	max_shots = 5
	fire_delay = 12
	force = 10
	origin_tech = "{'combat':3,'magnets':2,'engineering':2,'materials':3}"
	projectile_type = /obj/item/projectile/beam/midlaser
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT
	)
