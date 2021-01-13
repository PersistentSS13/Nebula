/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/obj_mask.dmi'
	slot_flags = SLOT_FACE
	body_parts_covered = SLOT_FACE|SLOT_EYES
	blood_overlay_type = "maskblood"

	var/voicechange = 0
	var/list/say_messages
	var/list/say_verbs
	var/down_gas_transfer_coefficient = 0
	var/down_body_parts_covered = 0
	var/down_icon_state = 0
	var/down_item_flags = 0
	var/down_flags_inv = 0
	var/pull_mask = 0
	var/hanging = 0
	var/list/filtered_gases

/obj/item/clothing/mask/proc/filters_water()
	return FALSE

/obj/item/clothing/mask/Initialize()
	. = ..()
	if(pull_mask)
		action_button_name = "Adjust Mask"
		verbs += .verb/adjust_mask

/obj/item/clothing/mask/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_mask()

/obj/item/clothing/mask/proc/filter_air(datum/gas_mixture/air)
	return

/obj/item/clothing/mask/verb/adjust_mask()
	set category = "Object"
	set name = "Adjust Mask"
	set src in usr

	if(!ismob(usr))
		return

	var/mob/user = usr
	if(!user.incapacitated(INCAPACITATION_DISABLED))
		if(!pull_mask)
			to_chat(usr, SPAN_NOTICE("You cannot pull down your [src.name]."))
			return
		else
			src.hanging = !src.hanging
			if (src.hanging)
				gas_transfer_coefficient = down_gas_transfer_coefficient
				body_parts_covered = down_body_parts_covered
				icon_state = down_icon_state
				item_state = down_icon_state
				item_flags = down_item_flags
				flags_inv = down_flags_inv
				to_chat(usr, "You pull [src] below your chin.")
			else
				gas_transfer_coefficient = initial(gas_transfer_coefficient)
				body_parts_covered = initial(body_parts_covered)
				icon_state = initial(icon_state)
				item_state = initial(icon_state)
				item_flags = initial(item_flags)
				flags_inv = initial(flags_inv)
				to_chat(usr, "You pull [src] up to cover your face.")
			update_clothing_icon()
			user.update_action_buttons()

/obj/item/clothing/mask/attack_self(mob/user)
	if(pull_mask)
		adjust_mask()