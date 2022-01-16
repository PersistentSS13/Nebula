/obj/item/chems/glass/bottle/Initialize()
	if(persistent_id)
		initial_reagents = null //Prevent bottle from respawning on load
	. = ..()