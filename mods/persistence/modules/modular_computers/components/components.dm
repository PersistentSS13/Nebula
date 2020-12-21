/datum/extension/interactive/ntos/proc/get_inserted_memory()
	var/obj/item/stock_parts/computer/mem_slot/mem_slot = get_component(PART_MEM)
	if(mem_slot)
		return mem_slot.stored_memory
