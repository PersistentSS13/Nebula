/turf/exterior/wall/Initialize(ml, materialtype, rmaterialtype)
    if(istype(reinf_material, /decl/material))
        return ..(ml, materialtype, reinf_material.type)
    return ..()
    