/obj/item/chems/food/Initialize(ml, material_key)
	var/old_nutri_amt = nutriment_amt
	if(persistent_id)
		nutriment_amt = 0 //If we loaded, prevent the init code from creating the reagents again.
	. = ..()
	if(old_nutri_amt)
		nutriment_amt = old_nutri_amt
	
SAVED_VAR(/obj/item/grown, plantname)
SAVED_VAR(/obj/item/grown, potency)

SAVED_VAR(/obj/item/chems/food, bitesize)
SAVED_VAR(/obj/item/chems/food, bitecount)
SAVED_VAR(/obj/item/chems/food, dried_type)
SAVED_VAR(/obj/item/chems/food, dry)
SAVED_VAR(/obj/item/chems/food, nutriment_amt)
SAVED_VAR(/obj/item/chems/food, nutriment_type)
SAVED_VAR(/obj/item/chems/food, nutriment_desc)
SAVED_VAR(/obj/item/chems/food, trash)

SAVED_VAR(/obj/item/chems/food/csandwich, ingredients)

SAVED_VAR(/obj/item/chems/food/fruit_slice, seed)

SAVED_VAR(/obj/item/chems/food/slice, whole_path)
SAVED_VAR(/obj/item/chems/food/slice, filled)