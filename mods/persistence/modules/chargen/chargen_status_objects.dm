
/////////////////////////////////////////////////////////////////////
// Status Indicators
/////////////////////////////////////////////////////////////////////

///A fake status screen to display status updates to the user.
/obj/chargen/screen
	name = "status display"
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	var/current_overlay_name
	var/form_incomplete_overlay = "lockdown"
	var/form_complete_overlay   = "ai_urist"
	var/awaiting_spawn_overlay  = "ai_shipscan"

/obj/chargen/screen/Initialize(mapload)
	. = ..()
	set_overlay(form_incomplete_overlay)

/obj/chargen/screen/on_update_icon()
	cut_overlays()
	add_overlay(image('icons/obj/status_display.dmi', icon_state=current_overlay_name))

/obj/chargen/screen/proc/set_overlay(overlay_name)
	current_overlay_name = overlay_name
	update_icon()

/obj/chargen/screen/proc/on_chargen_state_changed(area/source, new_state, old_state)
	set_light(2, 0.5, COLOR_WHITE)
	switch(new_state)
		if(CHARGEN_STATE_FORM_INCOMPLETE)
			set_overlay(form_incomplete_overlay)
		if(CHARGEN_STATE_FORM_COMPLETE)
			set_overlay(form_complete_overlay)
		if(CHARGEN_STATE_AWAITING_SPAWN)
			set_overlay(awaiting_spawn_overlay)

///Fake status light to display chargen status to the user.
/obj/chargen/status_light
	name = "launch clearance indicator"
	desc = "Will light up green when you're cleared for launch."
	icon = 'icons/obj/machines/door_timer.dmi'
	icon_state = "doortimer1"
	var/completed_chargen = FALSE

/obj/chargen/status_light/Initialize(mapload)
	. = ..()
	update_icon()
	var/area/chargen/A = get_area(src)
	if(istype(A))
		A.register_chargen_state_change_listener(src, /obj/chargen/status_light/proc/on_chargen_state_changed)

/obj/chargen/status_light/proc/set_chargen_completed(val)
	completed_chargen = !!val
	update_icon()

/obj/chargen/status_light/proc/on_chargen_state_changed(area/source, new_state, old_state)
	if(new_state == CHARGEN_STATE_FORM_COMPLETE || new_state == CHARGEN_STATE_AWAITING_SPAWN)
		set_chargen_completed(TRUE)
	else
		set_chargen_completed(FALSE)

/obj/chargen/status_light/on_update_icon()
	icon_state = "doortimer[completed_chargen? "2" : "1"]"
	if(completed_chargen)
		set_light(2, 0.5, COLOR_GREEN)
	else
		set_light(1, 0.3, COLOR_RED)
