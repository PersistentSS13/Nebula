// Hands rebuild their slots on load. Reequip items that were held before hand.
/mob/living/add_held_item_slot(var/slot, var/new_ui_loc, var/new_overlay_slot, var/new_label)  
	var/datum/inventory_slot/IS = held_item_slots? held_item_slots[slot] : null
	var/obj/item/prev_held = IS?.holding
	QDEL_NULL(IS) //Gonna get replaced anyways
	. = ..()
	if(prev_held)
		IS = held_item_slots? held_item_slots[slot] : null
		IS.holding = prev_held
		prev_held.screen_loc = IS.ui_loc
