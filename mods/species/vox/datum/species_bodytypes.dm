/decl/bodytype/vox
	name                = "soldier voxform"
	bodytype_category   = BODYTYPE_VOX
	icon_base           = 'mods/species/vox/icons/body/soldier/body.dmi'
	icon_deformed       = 'mods/species/vox/icons/body/deformed_body.dmi'
	husk_icon           = 'mods/species/vox/icons/body/husk.dmi'
	blood_overlays      = 'mods/species/vox/icons/body/blood_overlays.dmi'
	eye_icon            = 'mods/species/vox/icons/body/soldier/eyes.dmi'
	bodytype_flag       = BODY_FLAG_VOX
	limb_blend          = ICON_MULTIPLY
	eye_blend           = ICON_MULTIPLY
	appearance_flags    = HAS_EYE_COLOR | HAS_HAIR_COLOR | HAS_SKIN_COLOR
	base_hair_color     = "#160900"
	base_eye_color      = "#d60093"
	base_color          = "#526d29"
	body_flags          = BODY_FLAG_NO_DNA
	default_h_style     = /decl/sprite_accessory/hair/vox/short
	vital_organs        = list(
		BP_STACK,
		BP_BRAIN
	)
	override_limb_types = list(
		BP_GROIN = /obj/item/organ/external/groin/vox,
		BP_TAIL = /obj/item/organ/external/tail/vox
	)
	has_organ           = list(
		BP_STOMACH =    /obj/item/organ/internal/stomach/vox,
		BP_HEART =      /obj/item/organ/internal/heart/vox,
		BP_LUNGS =      /obj/item/organ/internal/lungs/vox,
		BP_LIVER =      /obj/item/organ/internal/liver/vox,
		BP_KIDNEYS =    /obj/item/organ/internal/kidneys/vox,
		BP_BRAIN =      /obj/item/organ/internal/brain,
		BP_EYES =       /obj/item/organ/internal/eyes/vox,
		BP_STACK =      /obj/item/organ/internal/voxstack,
		BP_HINDTONGUE = /obj/item/organ/internal/hindtongue
	)
	base_markings       = list(
		/decl/sprite_accessory/marking/vox/beak =   "#bc7d3e",
		/decl/sprite_accessory/marking/vox/scutes = "#bc7d3e",
		/decl/sprite_accessory/marking/vox/crest =  "#bc7d3e",
		/decl/sprite_accessory/marking/vox/claws =  "#a0a654"
	)

/decl/bodytype/vox/Initialize()
	if(!length(equip_adjust))
		equip_adjust = list(
			BP_L_HAND =           list("[NORTH]" = list(0, -2), "[EAST]" = list(0, -2), "[SOUTH]" = list( 0, -2),  "[WEST]" = list( 0, -2)),
			BP_R_HAND =           list("[NORTH]" = list(0, -2), "[EAST]" = list(0, -2), "[SOUTH]" = list( 0, -2),  "[WEST]" = list( 0, -2)),
			slot_head_str =       list("[NORTH]" = list(0, -2), "[EAST]" = list(3, -2), "[SOUTH]" = list( 0, -2),  "[WEST]" = list(-3, -2)),
			slot_wear_mask_str =  list("[NORTH]" = list(0,  0), "[EAST]" = list(4,  0), "[SOUTH]" = list( 0,  0),  "[WEST]" = list(-4,  0)),
			slot_wear_suit_str =  list("[NORTH]" = list(0, -1), "[EAST]" = list(0, -1), "[SOUTH]" = list( 0, -1),  "[WEST]" = list( 0, -1)),
			slot_w_uniform_str =  list("[NORTH]" = list(0, -1), "[EAST]" = list(0, -1), "[SOUTH]" = list( 0, -1),  "[WEST]" = list( 0, -1)),
			slot_underpants_str = list("[NORTH]" = list(0, -1), "[EAST]" = list(0, -1), "[SOUTH]" = list( 0, -1),  "[WEST]" = list( 0, -1)),
			slot_undershirt_str = list("[NORTH]" = list(0, -1), "[EAST]" = list(0, -1), "[SOUTH]" = list( 0, -1),  "[WEST]" = list( 0, -1)),
			slot_back_str =       list("[NORTH]" = list(0,  0), "[EAST]" = list(3,  0), "[SOUTH]" = list( 0,  0),  "[WEST]" = list(-3,  0))
		)
	return ..()

/decl/bodytype/vox/servitor
	name                = "servitor voxform"
	bodytype_category   = BODYTYPE_HUMANOID
	icon_base           = 'mods/species/vox/icons/body/servitor/body.dmi'
	icon_deformed       = 'mods/species/vox/icons/body/deformed_body.dmi'
	husk_icon           = 'mods/species/vox/icons/body/husk.dmi'
	blood_overlays      = 'mods/species/vox/icons/body/blood_overlays.dmi'
	eye_icon            = 'mods/species/vox/icons/body/servitor/eyes.dmi'
	base_markings       = list(
		/decl/sprite_accessory/marking/vox/beak/servitor =   "#bc7d3e",
		/decl/sprite_accessory/marking/vox/scutes/servitor = "#bc7d3e",
		/decl/sprite_accessory/marking/vox/crest/servitor =  "#bc7d3e",
		/decl/sprite_accessory/marking/vox/claws/servitor =  "#a0a654"
	)
	default_h_style     = /decl/sprite_accessory/hair/vox/short/servitor
	override_limb_types = list(
		BP_GROIN = /obj/item/organ/external/groin/vox,
		BP_TAIL = /obj/item/organ/external/tail/vox/servitor
	)

/decl/bodytype/vox/stanchion
	name                = "stanchion voxform"
	bodytype_category   = BODYTYPE_VOX_LARGE
	blood_overlays      = 'mods/species/vox/icons/body/stanchion/blood_overlays.dmi'
	damage_overlays     = 'mods/species/vox/icons/body/stanchion/damage_overlays.dmi'
	icon_base           = 'mods/species/vox/icons/body/stanchion/body.dmi'
	eye_icon            = 'mods/species/vox/icons/body/stanchion/eyes.dmi'
	icon_template       = 'mods/species/vox/icons/body/stanchion/template.dmi'
	base_markings       = list(
		/decl/sprite_accessory/marking/vox/beak/stanchion =   "#bc7d3e",
		/decl/sprite_accessory/marking/vox/scutes/stanchion = "#bc7d3e",
		/decl/sprite_accessory/marking/vox/crest/stanchion =  "#bc7d3e",
		/decl/sprite_accessory/marking/vox/claws/stanchion =  "#a0a654"
	)
	default_h_style     = /decl/sprite_accessory/hair/vox/short/stanchion
	override_limb_types = list(
		BP_GROIN = /obj/item/organ/external/groin/vox,
		// Commenting this out so that tail validation doesn't try to find a species using this bodytype.
		//BP_TAIL = /obj/item/organ/external/tail/vox/stanchion
	)

/decl/bodytype/vox/servitor/alchemist
	name       = "alchemist voxform"
	icon_base  = 'mods/species/vox/icons/body/servitor/body_alchemist.dmi'
	eye_icon   = 'mods/species/vox/icons/body/servitor/eyes_alchemist.dmi'

/obj/item/organ/external/tail/vox
	tail       = "voxtail"
	tail_icon  = 'mods/species/vox/icons/body/soldier/tail.dmi'
	tail_blend = ICON_MULTIPLY

/obj/item/organ/external/tail/vox/servitor
	tail_icon  = 'mods/species/vox/icons/body/servitor/tail.dmi'

/obj/item/organ/external/tail/vox/stanchion
	tail_icon  = 'mods/species/vox/icons/body/stanchion/tail.dmi'
