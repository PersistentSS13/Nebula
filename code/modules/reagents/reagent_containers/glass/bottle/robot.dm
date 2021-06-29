
/obj/item/chems/glass/bottle/robot
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,50,100]"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	volume = 60
	var/reagent = ""

/obj/item/chems/glass/bottle/robot/inaprovaline
	name = "internal inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle-4"
	reagent = /decl/material/liquid/inaprovaline

/obj/item/chems/glass/bottle/robot/inaprovaline/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/inaprovaline, 60)
	update_icon()

/obj/item/chems/glass/bottle/robot/dylovene
	name = "internal dylovene bottle"
	desc = "A small bottle of dylovene. Counters poisons, and repairs damage, a wonder drug."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle-4"
	reagent = /decl/material/liquid/dylovene

/obj/item/chems/glass/bottle/robot/dylovene/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/dylovene, 60)
	update_icon()