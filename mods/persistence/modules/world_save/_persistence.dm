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

//Called after a save
/datum/proc/after_save()
	custom_saved_lists |= list(custom_saved)
#ifndef SAVE_DEBUG
	custom_saved = null //Clear it since its no longer needed
#endif

//Called before save
/datum/proc/before_save()
	custom_saved = null

//Called immediately after the datum has been loaded from save during SSMapping's init.
// DO NOT call anything relying on other subsystems being initialized in this
/datum/proc/after_deserialize()

/datum/proc/should_save()
	return should_save

/datum/proc/get_saved_vars(var/list/tosave = null)
	return global.saved_vars[type] || get_default_vars()

/datum/proc/get_default_vars()
	testing("called get_default_vars on type '[type]'!")
	var/savedlist = list()
	for(var/v in vars)
		if(issaved(vars[v]) && !(v in global.blacklisted_vars))
			LAZYADD(savedlist, v)
	return savedlist

//
// Common overrides
//
/atom/should_save()
	return should_save

/atom/movable/openspace/multiplier
	should_save = FALSE

/mob/observer
	should_save = FALSE

/obj/after_deserialize()
	..()

/obj/machinery/embedded_controller
	var/saved_memory
/obj/machinery/embedded_controller/before_save()
	..()
	saved_memory = program.memory
/obj/machinery/embedded_controller/after_deserialize()
	..()
	if(saved_memory)
		program.memory = saved_memory

/datum/computer_file/report/after_deserialize()
	..()
	for(var/datum/report_field/field in fields)
		field.owner = src

/obj/item/storage/after_deserialize()
	..()
	startswith = null

/obj/item/tank/after_deserialize()
	..()
	starting_pressure = 0

/obj/item/extinguisher/after_deserialize()
	..()
	starting_water = 0

/obj/structure/cable/after_deserialize()
	..()
	var/turf/T = src.loc			// hide if turf is not intact
	if(level==1) hide(!T.is_plating())

/obj/item/tankassemblyproxy
	should_save = FALSE

/area/proc/get_turf_coords()
	var/list/coord_list = list()
	for(var/turf/T in contents)
		coord_list.Add("[T.x],[T.y],[T.z]")
	return coord_list
