/obj/item/gun/projectile/pistol/simple
	name = ".45 'Colt' HG"
	desc = "Pistol of ancient design. Reliable, but struggles against armored targets. Chambered in .45."
	icon = 'mods/persistence/icons/obj/guns/tier1/pistol.dmi'
	caliber = CALIBER_45
	fire_delay = 5
	force = 5
	accuracy = 1
	one_hand_penalty = 1
	origin_tech = @'{"combat":3,"engineering":2,"materials":2}'
	ammo_indicator = FALSE
	w_class = ITEM_SIZE_NORMAL
	magazine_type = /obj/item/ammo_magazine/fortyfive/simple
	allowed_magazines = /obj/item/ammo_magazine/fortyfive
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/wood = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/projectile/pistol/simple/empty
	starts_loaded = FALSE
