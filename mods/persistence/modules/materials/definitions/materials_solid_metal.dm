/decl/material/solid/metal/steel/generate_recipes(reinforce_material)
	. = ..()
	if(reinforce_material)
		return
	. += new/datum/stack_recipe/structure/iv_drip(src)