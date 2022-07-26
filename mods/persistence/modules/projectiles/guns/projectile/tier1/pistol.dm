/obj/item/gun/projectile/pistol/simple
	name = "ZSS HG 'Colt'"
	desc = "Nobody knows who 'Colt' actually was, but historians generally believe he was a master gunsmith from the ancient past. The 'Colt' pistol is one of his most well-known designs. Because the design to make this model was cracked decades ago, many groups have made their own bastardized versions of the firearm. This one in particular is chambered in 10mm rounds."
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
