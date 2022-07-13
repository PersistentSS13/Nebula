/obj/item/organ/external/Initialize(mapload, material_key, datum/dna/given_dna)
	. = ..()
	//For loose limbs only do this if we have no owner, because the proc would call stuff on the owner out of order otherwise
	if(LAZYLEN(wounds) && !owner) 
		update_wounds()
	if(persistent_id)
		update_damage_ratios()