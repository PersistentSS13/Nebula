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
	if(!(A in ac.owned_areas))
		to_chat(owner, SPAN_WARNING("This area is being protected by another area controller!"))
		return FALSE
	if(!(A in global.protected_areas))
		to_chat(owner, SPAN_WARNING("This area isn't being protected!"))
		return FALSE
	to_chat(owner, SPAN_NOTICE("You remove the area from the area controller's protected areas."))
	ac.remove_area(A)
	return TRUE

// Override for area ownership.
/mob/observer/eye/blueprints/area_control/finalize_area(area/A)
	var/area/created = ..()
	if(istype(created))
		ac.add_area(created)

/mob/observer/eye/blueprints/area_control/remove_area()
	if(!ac)
		to_chat(owner, SPAN_WARNING("Could not find area controller!"))
		release(owner)
		return

	var/area/A = get_area(src)
	if(!check_modification_validity())
		return
	if(A.apc)
		to_chat(owner, SPAN_WARNING("You must remove the APC from this area before you can remove it from the blueprints!"))
		return
	to_chat(owner, SPAN_NOTICE("You remove [A.proper_name] from \the [ac]'s blueprints."))
	log_and_message_admins("deleted area [A.proper_name] via area control server.")
	var/turf/our_turf = get_turf(src)
	var/datum/level_data/our_level_data = SSmapping.levels_by_z[our_turf.z]
	var/area/base_area = our_level_data.get_base_area_instance()
	for(var/turf/T in A.contents)
		ChangeArea(T, base_area)
	if(!(locate(/turf) in A))
		qdel(A) // uh oh, is this safe?

	return TRUE


/mob/observer/eye/blueprints/area_control/check_modification_validity()
	var/area/A = get_area(src)
	if((A in global.protected_areas) && global.protected_areas[A] && global.protected_areas[A] != ac)
		to_chat(owner, SPAN_WARNING("This area is being protected by another area controller!"))
		return FALSE
	. = ..()
