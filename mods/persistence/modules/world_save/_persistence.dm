//
// Datum override
//
var/global/list/custom_saved_lists = list() // Custom saved lists are kept here during the save and after their parent nulls them. This
											// is to ensure the ref of the list is not reused during the save.

/datum
	var/tmp/should_save = TRUE
	var/persistent_id				// This value should be constant across save/loads. It is first generated on serialization.
	var/list/custom_saved = null	//Associative list with a name and value to save extra data without creating a new pointless var)
								 	// Post-load its your responsability to clear it!!!
SAVED_VAR(/datum, persistent_id)
SAVED_VAR(/datum, custom_saved)

/**
 * Called right before the entity is saved.
 */
/datum/proc/before_save()
	custom_saved = null

/**
 * Called right after the entity has been saved.
*/
/datum/proc/after_save()
	custom_saved_lists |= list(custom_saved)
#ifndef SAVE_DEBUG
	custom_saved = null //Clear it since its no longer needed
#endif

/** 
 * Called immediately after the datum has been loaded from save during SSMapping's init, and before Initialize().
 * DO NOT call anything relying on subsystems being initialized in this!!
*/ 
/datum/proc/after_deserialize()
	return

/**Used to check and override whether an entity should be saved. */
/datum/proc/should_save()
	return should_save
