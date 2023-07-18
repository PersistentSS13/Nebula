/obj/item/gun/energy/laser/pistol/simple
	name = "Laser 'Settler' EG"
	desc = "Laser pistol used by modern spacers. Compact, but suffers from low charge capacity because of this. Fires Alpha-type laser beams."
	icon = 'mods/persistence/icons/obj/guns/tier1/laspistol.dmi'
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_NORMAL
	one_hand_penalty = 0
	max_shots = 6
	fire_delay = 5
	force = 3 // made of light-ish plastics rather than wood and metal
	origin_tech = "{'combat':3,'magnets':2,'engineering':2,'materials':3}"
	projectile_type = /obj/item/projectile/beam/smalllaser
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE
	)
