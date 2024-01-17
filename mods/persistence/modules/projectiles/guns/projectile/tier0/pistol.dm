/obj/item/gun/projectile/pistol/handmade
	name = ".22LR 'Zip' T0-HG"
	desc = "Pistol of dubious origin. Struggles against armored targets, but carries the benefits of magazines over hand-loading. Chambered in .22LR."
	icon = 'mods/persistence/icons/obj/guns/tier0/pistol.dmi'
	fire_delay = 8
	force = 5
	accuracy = 0
	one_hand_penalty = 2
	origin_tech = "{'combat':5,'engineering':5,'materials':2}"
	caliber = CALIBER_22LR
	ammo_indicator = FALSE
	w_class = ITEM_SIZE_NORMAL
	magazine_type = /obj/item/ammo_magazine/twentytwolr/handmade
	allowed_magazines = /obj/item/ammo_magazine/twentytwolr
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/wood = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/projectile/pistol/handmade/empty
	starts_loaded = FALSE
