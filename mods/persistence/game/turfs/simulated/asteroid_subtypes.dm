/turf/simulated/wall/natural/asteroid
	strata = /decl/strata/asteroid
	floor_type = /turf/space // Leave space behind when destroyed.

/turf/simulated/wall/natural/random/asteroid
	strata = /decl/strata/asteroid
	floor_type = /turf/space

/turf/simulated/wall/natural/comet
	strata = /decl/strata/permafrost
	floor_type = /turf/space

/turf/simulated/wall/natural/random/comet
	strata = /decl/strata/permafrost
	floor_type = /turf/space

/turf/simulated/wall/natural/random/comet/get_weighted_mineral_list()
	. = list()
	var/list/ices = decls_repository.get_decls_of_subtype(/decl/material/ice)
	for(var/ice_type in ices)
		var/decl/material/ice_mat = ices[ice_type]
		.[ice_type] = ice_mat.rich_material_weight // Comets are *the* place to get ice 

/turf/simulated/wall/natural/carp_flesh
	material = /decl/material/solid/skin/fish/purple
	floor_type = /turf/space

/turf/simulated/wall/natural/carp_flesh/update_strings()
	name = "carp flesh mass"
	desc = "A disgusting mass of flesh composed of [material.solid_name]."