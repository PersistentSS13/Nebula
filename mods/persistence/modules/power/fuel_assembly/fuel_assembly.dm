/obj/item/fuel_assembly/Initialize(mapload, _material, list/makeup, _colour)
	// This fuel assembly has been saved - pass along its material upward
	if(persistent_id)
		var/old_initial_amount = initial_amount
		. = ..(mapload, null, matter, color)
		initial_amount = old_initial_amount
		return
	return ..()
	