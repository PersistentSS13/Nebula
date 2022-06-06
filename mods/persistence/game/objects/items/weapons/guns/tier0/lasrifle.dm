/obj/item/gun/energy/laser/rifle/handmade
	name = "HM LR 'Tagger'"
	desc = "A cobbled-together mass of electronic components, duct tape, and hope. However, unlike most laser rifles, this model is small enough to wear around the waist. Sports dreadful ammo capacity compared to ballistic weapons but its ease of recharging makes it favored among the poor."
	icon = 'mods/persistence/icons/obj/guns/tier0/lasrifle.dmi'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	force = 5 // also lacks a butt for effective rifle-whippery
	one_hand_penalty = 3
	max_shots = 3
	fire_delay = 15
	origin_tech = "{'combat':2,'magnets':1,'engineering':1,'materials':2}"
	projectile_type = /obj/item/projectile/beam/smalllaser
