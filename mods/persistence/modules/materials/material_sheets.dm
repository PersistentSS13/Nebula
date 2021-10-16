//
// Base material forms
//

// Dust is a product of the recycler and meant to be some sort of intermediate
// resource to be processed back into usable material with a smelter
/obj/item/stack/material/dust
	name = "dust pile"
	singular_name = "dust pile"
	plural_name = "dust pile"
	icon = 'mods/persistence/icons/obj/materials.dmi'
	icon_state = "dust"
	plural_icon_state = "dust-mult"
	max_icon_state = "dust-max"
	stack_merge_type = /obj/item/stack/material/dust
	max_amount = 200
	
/obj/item/stack/material/dust/list_recipes(mob/user, recipes_sublist)
	return // You can't make anything from dust!
	
/obj/item/stack/material/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/stack/material))
		if(!is_same(W) && !reinf_material)
			return //Prevents reinforcing dust
	else if(reinf_material && isWelder(W))
		return // Prevents melting off the reinforced material
	return ..()

//
// Mapped types
//
/obj/item/stack/material/puck/graphite
	name = "graphite"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	material = /decl/material/solid/mineral/graphite
	
/obj/item/stack/material/puck/graphite/ten
	amount = 10
	
/obj/item/stack/material/puck/graphite/fifty
	amount = 50
