/obj/item/organ/external/tail

	organ_tag = BP_TAIL
	render_alpha = 0
	name = "tail"
	max_damage = 20
	min_broken_damage = 10
	w_class = ITEM_SIZE_NORMAL
	body_part = SLOT_LOWER_BODY
	parent_organ = BP_GROIN
	joint = "tail"
	amputation_point = "tail"
	artery_name = "vein"
	arterial_bleed_severity = 0.3
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_DISLOCATE
	skip_body_icon_draw = TRUE

	/// Name of tail state in species effects icon file. Used as a prefix for animated states.
	var/tail
	/// Icon file to use for tail states (including animations)
	var/tail_icon
	/// Blend mode for overlaying colour on the tail.
	var/tail_blend = ICON_ADD
	/// State modifier for hair overlays.
	var/tail_hair
	/// Blend mode for hair overlays.
	var/tail_hair_blend = ICON_ADD
	/// How many random tail states are available for animations.
	var/tail_states = 1

/obj/item/organ/external/tail/do_uninstall(in_place, detach, ignore_children, update_icon)
	var/mob/living/carbon/human/H = owner
	if(!(. = ..()))
		return
	if(update_icon && !istype(H) && H != owner)
		H.update_tail_showing(FALSE)

/obj/item/organ/external/tail/do_install(mob/living/carbon/human/target, affected, in_place, update_icon, detached)
	. = ..()
	if(update_icon && istype(owner))
		owner.update_tail_showing(FALSE)

/obj/item/organ/external/tail/proc/get_tail()
	return tail

/obj/item/organ/external/tail/proc/get_tail_icon()
	return tail_icon

/obj/item/organ/external/tail/proc/get_tail_states()
	return tail_states

/obj/item/organ/external/tail/proc/get_tail_blend()
	return tail_blend

/obj/item/organ/external/tail/proc/get_tail_hair()
	return tail_hair

/obj/item/organ/external/tail/proc/get_tail_hair_blend()
	return tail_hair_blend
