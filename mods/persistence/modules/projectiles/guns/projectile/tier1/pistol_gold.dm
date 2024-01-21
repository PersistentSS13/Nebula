/obj/item/gun/projectile/pistol/tierone/golden
	name = ".45 'Colt-M' T1-HG"
	desc = "Luxurious pistol of ancient design. Reliable and fabulous, but struggles against armored targets. Chambered in .45."
	icon = 'mods/persistence/icons/obj/guns/tier1/pistol_gold.dmi'
	origin_tech = "{'combat':10,'engineering':10,'materials':25}" // really high design requirements to support 'luxury' status - 5 design stipulations
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/wood = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/projectile/pistol/tierone/golden/empty
	starts_loaded = FALSE
