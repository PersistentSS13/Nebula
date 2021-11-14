/obj/item/forensics/sample_kit
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/forensics/sample_kit/swabs
	material = /decl/material/solid/plastic
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/forensics/sample_kit/powder
	material = /decl/material/solid/plastic
	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY)

/datum/fabricator_recipe/forensics
	category = "Forensics"

/datum/fabricator_recipe/forensics/sample_kit
	path = /obj/item/forensics/sample_kit

/datum/fabricator_recipe/forensics/swab_kit
	path = /obj/item/forensics/sample_kit/swabs

/datum/fabricator_recipe/forensics/fingerprint_powder
	path = /obj/item/forensics/sample_kit/powder

/datum/fabricator_recipe/forensics/uv_light
	path = /obj/item/uv_light

/datum/fabricator_recipe/forensics/print_card
	path = /obj/item/forensics/sample/print

