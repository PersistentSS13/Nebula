/obj/item/clothing/suit/chem_suit/cheap
	name = "cheap chemical suit"
	desc = "A suit that protects against chemical contamination. This one is cheaply-made and cannot be deconstructed for any meaningful resources. It is additionally much more difficult to move around in."
	material = /decl/material/solid/organic/paper
	matter = list(
		/decl/material/solid/organic/paper = MATTER_AMOUNT_REINFORCEMENT
	)
	origin_tech = "{'materials':0}"
	color = "#33ffad"

/obj/item/clothing/suit/chem_suit/disposable/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1.5) // same as a radsuit

/obj/item/clothing/head/chem_hood/cheap
	name = "cheap chemical hood"
	desc = "A hood that protects the head from chemical contaminants. This one is cheaply-made and cannot be deconstructed for any meaningful resources."
	color = "#33ffad"
	material = /decl/material/solid/organic/paper
	matter = list(
		/decl/material/solid/organic/paper = MATTER_AMOUNT_REINFORCEMENT
	)
	origin_tech = "{'materials':0}"

/obj/item/pickaxe/cheap
	name = "cheap pickaxe"
	desc = "This pickaxe is made from 3D-printed paper and styrofoam. It takes a long time to dig anything with this."
	icon_state = "preview"
	icon = 'icons/obj/items/tool/drills/pickaxe.dmi'
	digspeed = 80 // twice as long as a regular pick
	origin_tech = "{'materials':0}"
	drill_verb = "picking"
	sharp = 1
	color = "#33ffad"
	force = 5
	throwforce = 2
	material = /decl/material/solid/organic/paper
	matter = list(
		/decl/material/solid/organic/paper = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/flashlight/lantern/cheap
	name = "cheap lantern"
	desc = "A mining lantern. This one is made from 3D-printed paper and styrofoam; it doesn't emit much light."
	icon = 'icons/obj/lighting/lantern.dmi'
	force = 2
	attack_verb = list ("bludgeoned", "bashed", "whack")
	material = /decl/material/solid/organic/paper
	matter = list(
		/decl/material/solid/organic/paper = MATTER_AMOUNT_REINFORCEMENT
	)
	flashlight_range = 1.5
	light_wedge = LIGHT_OMNI
	light_color = LIGHT_COLOR_FIRE
	origin_tech = "{'materials':0}"
	color = "#33ffad"

/obj/item/tank/oxygen/cheap
	name = "cheap oxygen tank"
	desc = "A tank of oxygen. This one is made from 3D-printed paper and styrofoam; it doesn't have much capacity."
	icon = 'icons/obj/items/tanks/tank_blue.dmi'
	starting_pressure = list(/decl/material/gas/oxygen = 6 ATM)
	volume = 90
	color = "#33ffad"
	material = /decl/material/solid/organic/paper
	matter = list(
		/decl/material/solid/organic/paper = MATTER_AMOUNT_REINFORCEMENT
	)
	force = 2

/obj/item/clothing/mask/breath/scba/cheap
	desc = "A close-fitting self contained breathing apparatus mask. Can be connected to an air supply. This one is made from 3D-printed paper and styrofoam."
	name = "\improper cheap SCBA mask"
	icon = 'icons/clothing/mask/breath_scuba.dmi'
	color = "#33ffad"
	material = /decl/material/solid/organic/paper
	matter = list(
		/decl/material/solid/organic/paper = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/storage/ore/cheap
	name = "cheap mining satchel"
	desc = "This bag can be used to store and transport ores. This one is made from 3D-printed paper and styrofoam; it can't hold very much at all."
	max_storage_space = 100
	color = "#33ffad"
	material = /decl/material/solid/organic/paper
	matter = list(
		/decl/material/solid/organic/paper = MATTER_AMOUNT_REINFORCEMENT
	)