/turf/exterior/wall/Initialize(ml, materialtype, rmaterialtype)
	if(istype(reinf_material, /decl/material))
		return ..(ml, materialtype, reinf_material.type)
	return ..()

/turf/exterior/wall/update_material(update_neighbors, check_mining_gen = TRUE)
	if(check_mining_gen && (z in global.using_map.mining_levels))
		SSmining_update.turfs_to_update |= src
		SSmining_update.wake()
		return
	return ..()