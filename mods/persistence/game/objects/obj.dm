/////////////////////////////////////
// Saved Variables Definition
/////////////////////////////////////
SAVED_VAR(/obj, sharp)
SAVED_VAR(/obj, edge)
SAVED_VAR(/obj, anchor_fall)
SAVED_VAR(/obj, holographic)
SAVED_VAR(/obj, buckled_mob)

// Override to stop reagents from repopulating on save/load.

/obj/initialize_reagents(populate)
	if(persistent_id)
		return // We don't call parent since it checks if reagents are already initialized.
	else
		. = ..()