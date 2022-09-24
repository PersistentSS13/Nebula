//////////////////////////////////////////////////////////
// Material Powder
//////////////////////////////////////////////////////////

///A powdered form of a material, meant to be used in further processing and useless for construction and crafting
/obj/item/stack/material/dust
	name                 = "powder pile"
	desc                 = "Some powdered matter."
	singular_name        = "pile"
	plural_name          = "piles"
	icon_state           = "lump"
	plural_icon_state    = "lump-mult"
	max_icon_state       = "lump-max"
	w_class              = ITEM_SIZE_LARGE
	melee_accuracy_bonus = -50
	throw_speed          = 1
	throw_range          = 1
	max_amount           = 100
	attack_verb          = list("hit", "bludgeoned", "whacked")
	lock_picking_level   = 3
	matter_multiplier    = 0.3
	material             = /decl/material/solid/metal/steel
	pickup_sound         = 'sound/foley/pebblespickup1.ogg'
	drop_sound           = 'sound/foley/pebblesdrop1.ogg'

//We don't allow people to build anything from this, its just an intermediate material
/obj/item/stack/material/dust/list_recipes(mob/user, recipes_sublist)
	return