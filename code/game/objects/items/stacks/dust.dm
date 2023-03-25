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
	w_class              = ITEM_SIZE_LARGE //Bulky
	melee_accuracy_bonus = -50
	throw_speed          = 1
	throw_range          = 2
	does_spin            = FALSE //Doesn't spin when thrown
	max_amount           = 1000 //Each dust pile is 200 units each, while normal sheets are 2,000 units each. This means we get the same amount in a full stack.
	matter_multiplier    = 0.1
	abstract_type        = /obj/item/stack/material/dust
	is_spawnable_type    = FALSE
	pickup_sound         = 'sound/foley/pebblespickup1.ogg'
	drop_sound           = 'sound/foley/pebblesdrop1.ogg'
	attack_verb          = list("splattered", "sprinkled", "dredged")

//We don't allow people to build anything from this, its just an intermediate material
/obj/item/stack/material/dust/list_recipes(mob/user, recipes_sublist)
	return

/obj/item/stack/material/dust/throw_impact(atom/hit_atom, datum/thrownthing/TT)
	. = ..()

	//Chop down the stack into a bunch of smaller stacks
	var/min_amount_needed = round(max_amount * (rand(5, 9) * 0.1)) //pick an amount to stop at between 50-90% of the stack left
	while(amount > min_amount_needed && can_split())
		var/percent_to_split_off = rand(20, 70) * 0.01
		split(CEILING(percent_to_split_off * amount))

	//Then try to apply a dusting of us onto whatever we hit
	var/datum/reagents/R = new(CELL_VOLUME, global.temp_reagents_holder)
	for(var/mtype in matter)
		var/amount = matter[mtype]
		if(amount)
			R.add_reagent(mtype,  amount * REAGENT_UNITS_PER_MATERIAL_UNIT)
	if(R.total_volume > 0)
		R.splash(hit_atom, R.total_volume)
	use(amount)

// Dust override
/decl/material
	var/powder_type = /obj/item/stack/material/dust

/decl/material/proc/place_dust(var/atom/target, var/matter_units, var/allow_partial_stacks = TRUE)
	if(!powder_type && matter_units <= 0)
		return
	var/list/powder_mat = atom_info_repository.get_matter_for(powder_type, type, 1)
	var/amount_per_pile = LAZYACCESS(powder_mat, type)
	if(amount_per_pile < 1)
		return

	//Make all the shards we can
	var/piles_amount = round(matter_units / amount_per_pile)
	var/matter_left  = round(matter_units % amount_per_pile)
	LAZYADD(., create_object(target, piles_amount, powder_type))

	//If we got more than expected, just make a shard with that amount
	if(allow_partial_stacks && matter_left > 0)
		var/list/O = create_object(target, 1, powder_type)
		var/obj/S = O[O.len]
		LAZYSET(S.matter, type, matter_left)
		LAZYADD(., S)