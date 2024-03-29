/*
	The below procs are called on the atom you're dragging.  In a lot of circumstances we want to use the
	recieving object instead, so that's the default action.  This allows you to drag
	almost anything into a trash can.
*/

/atom/MouseDrop(atom/over)
	SHOULD_CALL_PARENT(TRUE)
	if(!can_mouse_drop(over, usr) || !handle_mouse_drop(over, usr))
		. = ..()

/atom/proc/handle_mouse_drop(var/atom/over, var/mob/user)
	. = over?.receive_mouse_drop(src, user)

// Can the user drop something onto this atom?
/atom/proc/user_can_mousedrop_onto(var/mob/user, var/atom/being_dropped, var/incapacitation_flags)
	return !user.incapacitated(incapacitation_flags) && check_mousedrop_interactivity(user) && user.check_dexterity(DEXTERITY_EQUIP_ITEM)

/atom/proc/check_mousedrop_interactivity(var/mob/user)
	return CanPhysicallyInteract(user)

// This proc checks if an atom can be mousedropped onto the target by the user.
/atom/proc/can_mouse_drop(var/atom/over, var/mob/user = usr, var/incapacitation_flags = INCAPACITATION_DEFAULT)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(user) || !istype(over) ||QDELETED(user) || QDELETED(over) || QDELETED(src))
		return FALSE
	if(!over.user_can_mousedrop_onto(user, src, incapacitation_flags))
		return FALSE
	if(!check_mousedrop_adjacency(over, user))
		return FALSE
	return TRUE

/atom/proc/check_mousedrop_adjacency(var/atom/over, var/mob/user)
	. = (Adjacent(user) && ((over in user?.client?.screen) || over.Adjacent(user)))

// Receive a mouse drop.
// Returns false if the atom is valid for dropping further up the chain, true if the drop has been handled.
/atom/proc/receive_mouse_drop(var/atom/dropping, var/mob/user)
	var/mob/living/H = user
	if(istype(H) && !H.anchored && can_climb(H) && dropping == user)
		do_climb(dropping)
		return TRUE
	return FALSE
