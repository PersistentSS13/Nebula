/obj/item/Initialize(ml, material_key)
	if(!material_key && istype(material, /decl/material))
		return ..(ml, material.type)
	else
		return ..()