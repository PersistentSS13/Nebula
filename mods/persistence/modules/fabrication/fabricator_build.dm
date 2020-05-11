/obj/machinery/fabricator/try_queue_build(var/datum/computer_file/data/blueprint/blueprint, var/multiplier)
	// Do some basic sanity checking.
	if(!is_functioning() || !istype(blueprint))
		return
	multiplier = sanitize_integer(multiplier, 1, 100, 1)
	if(!ispath(blueprint.recipe, /obj/item/stack) && multiplier > 1)
		multiplier = 1

	// Check if sufficient resources exist.
	var/list/resources = blueprint.get_resources()
	for(var/material in resources)
		if(stored_material[material] < round(resources[material] * mat_efficiency) * multiplier)
			return

	// Generate and track a new order.
	var/datum/fabricator_build_order/order = new
	order.remaining_time = blueprint.get_build_time()
	order.target_recipe =  blueprint.recipe
	order.multiplier =     multiplier
	queued_orders +=       order

	// Remove/earmark resources.
	for(var/material in resources)
		var/removed_mat = round(resources[material] * mat_efficiency) * multiplier
		stored_material[material] = max(0, stored_material[material] - removed_mat)
		order.earmarked_materials[material] = removed_mat

	if(!currently_building)
		get_next_build()
	else
		start_building()