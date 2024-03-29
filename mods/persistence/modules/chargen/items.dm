/obj/item/clothing/suit/chem_suit/cheap
	name = "cheap chemical suit"
	desc = "A suit that protects against chemical contamination. This one is cheaply-made and cannot be deconstructed for any meaningful resources. It is additionally much more difficult to move around in."
	material = /decl/material/solid/metal/iron/r_styrofoam
	matter = list(
		/decl/material/solid/metal/iron/r_styrofoam = MATTER_AMOUNT_TRACE
	)
	origin_tech = @'{"materials":1}'
	color = "#33ffad"

/obj/item/clothing/suit/chem_suit/cheap/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1.5) // same as a radsuit

/obj/item/clothing/head/chem_hood/cheap
	name = "cheap chemical hood"
	desc = "A hood that protects the head from chemical contaminants. This one is cheaply-made and cannot be deconstructed for any meaningful resources."
	color = "#33ffad"
	material = /decl/material/solid/metal/iron/r_styrofoam
	matter = list(
		/decl/material/solid/metal/iron/r_styrofoam = MATTER_AMOUNT_TRACE
	)
	origin_tech = @'{"materials":1}'

/obj/item/pickaxe/cheap
	name = "cheap pickaxe"
	desc = "This pickaxe is made from 3D-printed paper and styrofoam. It takes a long time to dig anything with this."
	icon_state = "preview"
	icon = 'icons/obj/items/tool/drills/pickaxe.dmi'
	digspeed = 80 // twice as long as a regular pick
	origin_tech = @'{"materials":1}'
	drill_verb = "picking"
	sharp = 1
	color = "#33ffad"
	force = 5
	throwforce = 2
	material = /decl/material/solid/metal/iron/r_styrofoam
	matter = list(
		/decl/material/solid/metal/iron/r_styrofoam = MATTER_AMOUNT_TRACE
	)
	build_from_parts = TRUE
	hardware_color = COLOR_SILVER

/obj/item/flashlight/lantern/cheap
	name = "cheap lantern"
	desc = "A mining lantern. This one is made from 3D-printed paper and styrofoam; it doesn't emit much light."
	force = 2
	material = /decl/material/solid/metal/iron/r_styrofoam
	matter = list(
		/decl/material/solid/metal/iron/r_styrofoam = MATTER_AMOUNT_TRACE
	)
	flashlight_range = 1.5
	origin_tech = @'{"materials":1}'
	color = "#33ffad"

/obj/item/tank/oxygen/cheap
	name = "cheap oxygen tank"
	desc = "A tank of oxygen. This one is made from 3D-printed paper and styrofoam; it doesn't have much capacity."
	volume = 90
	color = "#33ffad"
	material = /decl/material/solid/metal/iron/r_styrofoam
	matter = list(
		/decl/material/solid/metal/iron/r_styrofoam = MATTER_AMOUNT_TRACE
	)
	force = 2
	origin_tech = @'{"materials":1}'

/obj/item/clothing/mask/breath/scba/cheap
	desc = "A close-fitting self contained breathing apparatus mask. Can be connected to an air supply. This one is made from 3D-printed paper and styrofoam."
	name = "\improper cheap SCBA mask"
	icon = 'icons/clothing/mask/breath_scuba.dmi'
	color = "#33ffad"
	material = /decl/material/solid/metal/iron/r_styrofoam
	matter = list(
		/decl/material/solid/metal/iron/r_styrofoam = MATTER_AMOUNT_TRACE
	)
	origin_tech = @'{"materials":1}'

/obj/item/storage/ore/cheap
	name = "cheap mining satchel"
	desc = "This bag can be used to store and transport ores. This one is made from 3D-printed paper and styrofoam; it can't hold very much at all."
	max_storage_space = 100
	color = "#33ffad"
	material = /decl/material/solid/metal/iron/r_styrofoam
	matter = list(
		/decl/material/solid/metal/iron/r_styrofoam = MATTER_AMOUNT_TRACE
	)
	origin_tech = @'{"materials":1}'

/decl/material/solid/metal/iron/r_styrofoam
	name = "reinforced styrofoam"
	codex_name = "reinforced styrofoam"
	uid = "cheap_steel"
	lore_text = "A form of styrofoam that is considerably more durable than regular styrofoam, but still worse than most metals. Often used for low-end tool fabrication."
	wall_support_value = MAT_VALUE_EXTREMELY_LIGHT
	hardness = MAT_VALUE_SOFT
	integrity = 10
	brute_armor = 0
	hitsound = 'sound/weapons/smash.ogg'
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	value = 0.01
	dissolves_into = list(
		/decl/material/solid/metal/iron/r_styrofoam = 1
	)
	default_solid_form = /obj/item/stack/material/panel
	sound_manipulate = 'sound/foley/paperpickup2.ogg'
	sound_dropped = 'sound/foley/paperpickup1.ogg'
