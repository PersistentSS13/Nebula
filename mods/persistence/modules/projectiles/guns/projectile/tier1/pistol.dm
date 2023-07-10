/obj/item/gun/projectile/pistol/simple
	name = "10mm 'Colt' HG"
	desc = "Pistol of ancient design. Reliable, but struggles against armored targets. Chambered in 10mm."
	icon = 'mods/persistence/icons/obj/guns/tier1/pistol.dmi'
	fire_delay = 5
	force = 5
	accuracy = 1
	one_hand_penalty = 0
	origin_tech = "{'combat':3,'engineering':2,'materials':2}"
	ammo_indicator = FALSE
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/wood = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/projectile/pistol/simple/empty
	starts_loaded = FALSE
