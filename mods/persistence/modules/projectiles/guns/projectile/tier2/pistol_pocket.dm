/obj/item/gun/projectile/pistol_pocket/advanced
	name = ".22LR 'Triple-Threat' HG"
	desc = "Pistol of modern design. Small enough to store in pockets, and possesses both semi-automatic and three-round burst fire modes. Chambered in .22LR."
	icon = 'mods/persistence/icons/obj/guns/tier2/pistol_pocket.dmi'
	fire_delay = 2
	force = 5
	accuracy = 1
	one_hand_penalty = 0
	origin_tech = "{'combat':4,'engineering':4,'materials':4}"
	caliber = CALIBER_22LR
	ammo_indicator = FALSE
	w_class = ITEM_SIZE_SMALL
	magazine_type = /obj/item/ammo_magazine/twentytwolr/advanced
	allowed_magazines = /obj/item/ammo_magazine/twentytwolr
	material = /decl/material/solid/metal/titanium
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/plastic = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)
	firemodes = list(
		list(mode_name="semi-automatic",      burst=1, fire_delay=2, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=2, one_hand_penalty=1, burst_accuracy=list(1,0,-1),       dispersion=list(0.0, 1.6, 2.4, 2.4)),
	)

/obj/item/gun/projectile/pistol_pocket/advanced/empty
	starts_loaded = FALSE