/turf/simulated/wall/Initialize(ml, materialtype, rmaterialtype)
	if(istype(material, /decl/material/))
		materialtype = material.type
	if(istype(reinf_material, /decl/material))
		rmaterialtype = reinf_material.type
	. = ..()