/obj/item/gun/energy/laser/pistol/advanced
	name = "Laser 'Martin' EG"
	desc = "Laser pistol used by modern high-tech military groups. Compact, quick-firing, and boasts acceptable charge capacity due to advanced construction. Fires Alpha-type laser beams."
	icon = 'mods/persistence/icons/obj/guns/tier2/laspistol.dmi'
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_NORMAL
	one_hand_penalty = 0
	max_shots = 12
	fire_delay = 3
	force = 3
	origin_tech = @'{"combat":4,"magnets":3,"engineering":4,"materials":3}'
	projectile_type = /obj/item/projectile/beam/smalllaser
	material = /decl/material/solid/metal/titanium
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)