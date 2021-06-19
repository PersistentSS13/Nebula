/mob/observer/eye/blueprints/area_control
	name = "Area Control Eye"
	desc = "A visual projection used to assist in the creation and protection of areas."
	name_sufix = "Area Control Eye"

	var/obj/machinery/network/area_controller/ac

/mob/observer/eye/blueprints/area_control/Initialize(mapload, var/list/valid_zls, var/area_p, var/obj/machinery/network/area_controller/holder)
	. = ..()
	if(!holder)
		release(owner)
	
	ac = holder

/mob/observer/eye/blueprints/area_control/proc/claim_area()
	var/area/A = get_area(src)
	if(A in global.protected_areas)
		to_chat(owner, SPAN_WARNING("This area is already being protected!"))
		return FALSE
	to_chat(owner, SPAN_NOTICE("You add the area to the area controller's protected areas."))
	ac.add_area(A)
	return TRUE

/mob/observer/eye/blueprints/area_control/proc/release_area()
	var/area/A = get_area(src)
	if(!(A in global.protected_areas))
		to_chat(owner, SPAN_WARNING("This area isn't being protected!"))
		return FALSE
	if(!(A in ac.owned_areas))
		to_chat(owner, SPAN_WARNING("This area is being protected by another area controller!"))
		return FALSE
	to_chat(owner, SPAN_NOTICE("You remove the area from the area controller's protected areas."))
	ac.remove_area(A)
	return TRUE

// Override for area ownership.
/mob/observer/eye/blueprints/area_control/create_area()
	var/area_name = sanitizeSafe(input("New area name:","Area Creation", ""), MAX_NAME_LEN)
	if(!area_name || !length(area_name))
		return
	if(length(area_name) > 50)
		to_chat(owner, SPAN_WARNING("That name is too long!"))
		return

	if(!check_selection_validity())
		to_chat(owner, SPAN_WARNING("Could not mark area: [english_list(errors)]!"))
		return

	if(!ac)
		to_chat(owner, SPAN_WARNING("Could not find area controller!"))
		release(owner)
		return

	var/area/A = new
	A.SetName(area_name)
	A.power_equip = 0
	A.power_light = 0
	A.power_environ = 0
	A.always_unpowered = 0
	for(var/turf/T in selected_turfs)
		ChangeArea(T, A)
	ac.add_area(A)
	remove_selection() // Reset the selection for clarity.

/mob/observer/eye/blueprints/area_control/remove_area()
	var/area/A = get_area(src)
	if(!check_modification_validity())
		return
	if(A.apc)
		to_chat(owner, SPAN_WARNING("You must remove the APC from this area before you can remove it from the blueprints!"))
		return
	if(!ac)
		to_chat(owner, SPAN_WARNING("Could not find area controller!"))
		release(owner)
		return
	to_chat(owner, SPAN_NOTICE("You scrub [A.name] off the blueprints."))
	log_and_message_admins("deleted area [A.name] via station blueprints.")
	ac.remove_area(A)
	qdel(A)

/mob/observer/eye/blueprints/area_control/check_modification_validity()
	var/area/A = get_area(src)
	if((A in global.protected_areas) && global.protected_areas[A] && global.protected_areas[A] != ac)
		to_chat(owner, SPAN_WARNING("This area is being protected by another area controller!"))
		return FALSE
	. = ..()
	