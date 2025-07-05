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
	. = ..()
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

///A light weight console look-alike with as only purpose displaying a nano UI.
/obj/structure/fake_computer/chargen
	should_save = FALSE
	is_spawnable_type = FALSE //Prevent unit tests from trying to spawn these outside of a chargen area
	///The chargen form currently set to be displayed by the console.
	var/datum/nano_module/chargen/current_form

INITIALIZE_IMMEDIATE(/obj/structure/fake_computer/chargen) //Init early
/obj/structure/fake_computer/chargen/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	var/area/chargen/A = get_area(src)
	if(!istype(A))
		CRASH("[log_info_line(src)] was not initialized inside a chargen area!")
	set_area(A)

/obj/structure/fake_computer/chargen/Destroy()
	var/area/chargen/A = get_area(src)
	if(istype(A))
		unset_area(A)
	QDEL_NULL(current_form)
	. = ..()

///Assign the nano ui module form that will be presented by this machine.
/obj/structure/fake_computer/chargen/proc/set_form(datum/nano_module/chargen/form)
	if(current_form && (current_form != form))
		QDEL_NULL(current_form)
	current_form = form

/obj/structure/fake_computer/chargen/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE)
	current_form.ui_interact(user, ui_key, ui, force_open)

//////////////////////
// Events Handlers
//////////////////////

/// Listen to a few events from the specified area.
/obj/structure/fake_computer/chargen/proc/set_area(area/chargen/A)
	events_repository.register(/decl/observ/chargen/player_registered,   A, src, /obj/structure/fake_computer/chargen/proc/on_player_registered)
	events_repository.register(/decl/observ/chargen/player_unregistered, A, src, /obj/structure/fake_computer/chargen/proc/on_player_unregistered)

/// Stop listening to events from the specified area.
/obj/structure/fake_computer/chargen/proc/unset_area(area/chargen/A)
	events_repository.unregister(/decl/observ/chargen/player_registered,   A, src, /obj/structure/fake_computer/chargen/proc/on_player_registered)
	events_repository.unregister(/decl/observ/chargen/player_unregistered, A, src, /obj/structure/fake_computer/chargen/proc/on_player_unregistered)

///Called by the area when a player is assigned to the area containing this chargen console
/obj/structure/fake_computer/chargen/proc/on_player_registered(area/chargen/source, mob/player)
	set_form(new /datum/nano_module/chargen(src, null, player, source))

///Called by the area when a player is unassigned to the area containing this chargen console
/obj/structure/fake_computer/chargen/proc/on_player_unregistered(area/chargen/source, mob/player)
	set_form(null)
