/datum/extension/eye/stellar_anchor
	expected_type = /obj/machinery/network/stellar_anchor
	eye_type = /mob/observer/eye/stellar_anchor

	action_type = /datum/action/eye/stellar_anchor

/datum/extension/eye/stellar_anchor/proc/toggle_area()
	if(!holder || !istype(holder, expected_type) || !extension_eye)
		return
	
	var/obj/machinery/network/stellar_anchor/holder_anchor = holder
	var/area/A = get_area(extension_eye)
	if(A in holder_anchor.anchored_areas)
		holder_anchor.remove_area(A)
		to_chat(current_looker, SPAN_NOTICE("\The [holder_anchor] is no longer anchoring [A.name]."))
	else
		var/list/errors = holder_anchor.add_area(A)
		if(!LAZYLEN(errors))
			to_chat(current_looker, SPAN_NOTICE("\The [holder_anchor] is now anchoring [A.name]."))
		else
			to_chat(current_looker, SPAN_WARNING("\The [holder_anchor] is unable to anchor [A.name] because [english_list(errors)]!"))

	var/mob/observer/eye/stellar_anchor/eye = extension_eye
	eye.update_images(holder)

/datum/extension/eye/stellar_anchor/look()
	. = ..()
	if(.)
		var/mob/observer/eye/stellar_anchor/eye = extension_eye
		eye.update_images(holder)

/datum/action/eye/stellar_anchor/toggle_area
	name = "Anchor area"
	procname = "toggle_area"
	button_icon_state = "toggle_anchor"
	target_type = EXTENSION_TARGET