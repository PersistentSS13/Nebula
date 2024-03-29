/obj/item/gun/energy/laser/rifle/advanced
	name = "Laser 'Frontrunner' EG"
	desc = "Laser rifle used by modern high-tech military groups. Powerful compared to previous models of laser weapons, and boasts decent charge capacity. Fires Beta-type laser beams."
	icon = 'mods/persistence/icons/obj/guns/tier2/lasrifle.dmi'
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_HUGE
	one_hand_penalty = 3
	max_shots = 8
	fire_delay = 12
	force = 10
	origin_tech = @'{"combat":4,"magnets":4,"engineering":3,"materials":3}'
	projectile_type = /obj/item/projectile/beam/midlaser
	material = /decl/material/solid/metal/titanium
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)