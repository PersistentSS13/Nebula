/obj/item/gun/projectile/pistol/simple/golden
	name = "10mm 'Colt-M' HG"
	desc = "Luxurious pistol of ancient design. Reliable and fabulous, but struggles against armored targets. Chambered in 10mm."
	icon = 'mods/persistence/icons/obj/guns/tier1/pistol_gold.dmi'
	origin_tech = "{'combat':3,'engineering':2,'materials':5}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/wood = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/projectile/pistol/simple/golden/empty
	starts_loaded = FALSE
