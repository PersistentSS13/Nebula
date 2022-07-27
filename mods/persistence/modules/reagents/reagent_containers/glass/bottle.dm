/obj/item/chems/glass/bottle/Initialize()
	if(persistent_id)
		initial_reagents = null //Prevent bottle from respawning on load
	. = ..()

SAVED_VAR(/obj/item/chems/glass/bottle, label_color)
SAVED_VAR(/obj/item/chems/glass/bottle, lid_color)
