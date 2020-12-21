/datum/extension/assembly/attackby(var/obj/item/W, var/mob/user)
	. = ..()
	if(istype(W, /obj/item/memory)) // Memory, try to insert it.
		var/obj/item/stock_parts/computer/mem_slot/mem_slot = get_component(PART_MEM)
		if(!mem_slot)
			to_chat(user, SPAN_WARNING("You try to insert [W] into [holder], but it does not have an memory slot installed."))
			return TRUE
		mem_slot.insert_memory(W, user)
		return TRUE
