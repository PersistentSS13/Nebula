/obj/item/gun/projectile/pistol/simple/golden
	name = "ZSS HG 'Midas'"
	desc = "This particular 'Colt' handgun has been made using an alloy of gold and an unknown material. It's been handmade by an expert artisan who has been lost to time. This gun isn't so much a weapon as it is a piece of art. This one in particular is chambered in 10mm rounds and is functionally identical to a normal 'Colt' handgun."
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
