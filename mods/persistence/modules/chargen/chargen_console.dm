///////////////////////////////////////////////////////////////////////////////////
// Fake Computer
///////////////////////////////////////////////////////////////////////////////////

///Simple structure displaying a nanoui on interact
/obj/structure/fake_computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = TRUE
	anchored = TRUE

/obj/structure/fake_computer/attack_hand(mob/user)
	if((. = ..()))
		return .
	ui_interact(user)
	return TRUE

/obj/structure/fake_computer/on_update_icon()
	cut_overlays()
	icon = initial(icon)
	icon_state = initial(icon_state)

	//Slap on the screen overlay
	var/image/screen_overlay = image(icon, "generic", layer)
	screen_overlay.appearance_flags |= RESET_COLOR
	add_overlay(screen_overlay)

	//Slap on the keyboard overlay
	var/image/keyboard_overlay = image(icon, "generic_key", layer)
	keyboard_overlay.appearance_flags |= RESET_COLOR
	add_overlay(keyboard_overlay)

	//Light it up
	set_light(2, 1, light_color)

/obj/structure/fake_computer/CouldUseTopic(var/mob/user)
	..()
	playsound(src, "keyboard", 40)

///////////////////////////////////////////////////////////////////////////////////
// Chargen console
///////////////////////////////////////////////////////////////////////////////////

/obj/structure/fake_computer/chargen
	should_save = FALSE
	var/datum/nano_module/chargen/current_form

/obj/structure/fake_computer/chargen/Destroy()
	QDEL_NULL(current_form)
	. = ..()

/obj/structure/fake_computer/chargen/proc/set_form(datum/nano_module/chargen/form)
	if(current_form && (current_form != form))
		QDEL_NULL(current_form)
	current_form = form

/obj/structure/fake_computer/chargen/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE)
	current_form.ui_interact(user, ui_key, ui, force_open)

// /obj/structure/fake_computer/chargen/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
// 	var/list/data = ui_data(user)
// 	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
// 	if (!ui)
// 		ui = new(user, src, ui_key, "chargen.tmpl", name, 1024, 780)
// 		ui.set_initial_data(data)
// 		ui.open()
// 		ui.set_auto_update(1)
