/decl/bodytype/monkey
	name =              "humanoid"
	bodytype_category = BODYTYPE_MONKEY
	icon_base =         'icons/mob/human_races/species/monkey/monkey_body.dmi'
	blood_overlays =    'icons/mob/human_races/species/monkey/blood_overlays.dmi'
	health_hud_intensity = 1.75
	bodytype_flag = BODY_FLAG_MONKEY
	override_limb_types = list(
		BP_HEAD = /obj/item/organ/external/head/no_eyes,
		BP_TAIL = /obj/item/organ/external/tail/monkey
	)
	mob_size = MOB_SIZE_SMALL

/decl/bodytype/monkey/Initialize()
	equip_adjust = list(
		BP_L_HAND =          list("[NORTH]" = list( 1, 3), "[EAST]" = list(-3, 2), "[SOUTH]" = list(-1, 3), "[WEST]" = list( 3, 2)),
		BP_R_HAND =          list("[NORTH]" = list(-1, 3), "[EAST]" = list( 3, 2), "[SOUTH]" = list( 1, 3), "[WEST]" = list(-3, 2)),
		slot_shoes_str =     list("[NORTH]" = list( 0, 7), "[EAST]" = list(-1, 7), "[SOUTH]" = list( 0, 7), "[WEST]" = list( 1, 7)),
		slot_head_str =      list("[NORTH]" = list( 0, 0), "[EAST]" = list(-2, 0), "[SOUTH]" = list( 0, 0), "[WEST]" = list( 2, 0)),
		slot_wear_mask_str = list("[NORTH]" = list( 0, 0), "[EAST]" = list(-1, 0), "[SOUTH]" = list( 0, 0), "[WEST]" = list( 1, 0))
	)
	. = ..()

/obj/item/organ/external/tail/monkey
	tail      = "chimptail"
	tail_icon = 'icons/mob/human_races/species/monkey/monkey_tail.dmi'
