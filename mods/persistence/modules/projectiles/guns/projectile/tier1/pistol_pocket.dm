/obj/item/gun/projectile/pistol_pocket/simple
	name = ".22LR 'Rimfire' HG"
	desc = "Pistol of ancient design. Small enough to store in pockets, but struggles in combat due to weak caliber. Chambered in .22LR."
	icon = 'mods/persistence/icons/obj/guns/tier1/pistol_pocket.dmi'
	fire_delay = 3
	force = 5
	accuracy = 1
	one_hand_penalty = 0
	origin_tech = "{'combat':3,'engineering':2,'materials':2}"
	caliber = CALIBER_22LR
	ammo_indicator = FALSE
	w_class = ITEM_SIZE_SMALL
	magazine_type = /obj/item/ammo_magazine/twentytwolr/simple
	allowed_magazines = /obj/item/ammo_magazine/twentytwolr
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/wood = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/projectile/pistol_pocket/simple/empty
	starts_loaded = FALSE