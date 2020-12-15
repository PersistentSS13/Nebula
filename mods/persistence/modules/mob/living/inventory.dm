// Hands rebuild their slots on load. Reequip items that were held before hand.
/mob/living/add_held_item_slot(var/slot, var/new_ui_loc, var/new_overlay_slot, var/new_label)  
	var/obj/item/held = get_equipped_item(slot)

	. = ..()	

	if(held)
		equip_to_slot_or_store_or_drop(held, slot)