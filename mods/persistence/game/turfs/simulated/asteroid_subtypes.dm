

/turf/exterior/wall/asteroid
	strata = /decl/strata/asteroid
	floor_type = /turf/space // Leave space behind when destroyed.

/turf/exterior/wall/random/asteroid
	strata = /decl/strata/asteroid
	floor_type = /turf/space

/turf/exterior/wall/comet
	strata = /decl/strata/permafrost
	floor_type = /turf/space

/turf/exterior/wall/random/comet
	strata = /decl/strata/permafrost
	floor_type = /turf/space

/turf/exterior/wall/random/comet/get_weighted_mineral_list()
	. = list()
	var/list/ices = decls_repository.get_decls_of_subtype(/decl/material/ice)
	for(var/ice_type in ices)
		var/decl/material/ice_mat = ices[ice_type]
		.[ice_type] = ice_mat.rich_material_weight // Comets are *the* place to get ice 

/turf/exterior/wall/carp_flesh
	material = /decl/material/solid/skin/fish/purple
	floor_type = /turf/space

/turf/exterior/wall/carp_flesh/update_strings()
	name = "carp flesh mass"
	desc = "A disgusting mass of flesh composed of [material.solid_name]."