/obj/item/gun/projectile/automatic/smg/advanced
	name = ".22LR 'Junior' SMG"
	desc = "Submachine gun of modern design. Somewhat accurate, and boasts both semi-automatic and fully automatic firing modes. Chambered in .22LR."
	icon = 'mods/persistence/icons/obj/guns/tier2/smg.dmi'
	caliber = CALIBER_22LR
	fire_delay = 0
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	force = 5
	origin_tech = "{'combat':4,'engineering':4,'materials':3}"
	one_hand_penalty = 0
	accuracy = 0
	auto_eject = 0
	magazine_type = /obj/item/ammo_magazine/twentytwolr/advanced
	allowed_magazines = /obj/item/ammo_magazine/twentytwolr
	material = /decl/material/solid/metal/titanium
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)
	ammo_indicator = FALSE
	firemodes = list(
		list(mode_name="semi-automatic",      burst=1, fire_delay=null, one_hand_penalty=5, burst_accuracy=null, dispersion=null),
		list(mode_name="fully-automatic",      burst=1, fire_delay=0,    burst_delay=1,      one_hand_penalty=15,                 burst_accuracy=list(0,-1,-1,-2,-3), dispersion=list(1.6, 1.6, 2.0, 2.0, 2.4), autofire_enabled=1)
	)

/obj/item/gun/projectile/automatic/smg/advanced/empty
	starts_loaded = FALSE

