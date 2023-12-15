/obj/machinery/recycler/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance > 2)
		return
	if(was_bloodied)
		to_chat(user, SPAN_WARNING("The rollers seem covered in blood!"))
	to_chat(user, "The power light is [(operable() && (use_power > POWER_USE_OFF))? "on" : "off"].")
	to_chat(user, "The safety-mode light is [(recycler_state & RECYCLER_FLAG_UNSAFE) ? "off" : "on"].")
	to_chat(user, "The safety-sensors status light is [emagged ? "off" : "on"].")
	to_chat(user, "The internal tank reads [reagents.total_volume]/[reagents.maximum_volume] units of reagents.")
	var/nb_blockers = LAZYLEN(emergency_stopping_objects)
	if(nb_blockers > 0)
		var/blockers_string = ""
		for(var/atom/movable/AM in emergency_stopping_objects)
			blockers_string += "<li>\icon[AM][AM]</li>"
		to_chat(user, "The panel warns there is still [nb_blockers] forbidden objects inside the machine:")
		to_chat(user, "<ul style=\"list-style-type:disc\">[blockers_string]</ul>")

/obj/machinery/recycler/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	if(emagged)
		return .
	if(remaining_charges < 1)
		to_chat(user, SPAN_WARNING("\The [emag_source] is out of charges!"))
		return .
	emagged = TRUE
	if(!(recycler_state & RECYCLER_FLAG_UNSAFE))
		recycler_state |= RECYCLER_FLAG_UNSAFE
		update_icon()
	playsound(src, "sparks", 75, TRUE, extrarange = -1)
	spark_at(src, 2, TRUE, user)
	to_chat(user, SPAN_NOTICE("You use \the [emag_source] on \the [src]."))
	return 1 //One use

/obj/machinery/recycler/attackby(obj/item/I, mob/user)
	if(is_running() && (recycler_state & RECYCLER_FLAG_SHORTED) && (I.obj_flags & OBJ_FLAG_CONDUCTIBLE))
		try_shock_thing(user)
	if(ATOM_IS_OPEN_CONTAINER(I) && (reagents.total_volume > 0))
		var/freespc = REAGENTS_FREE_SPACE(I?.reagents)
		if(freespc > 0)
			playsound(loc, 'sound/effects/bottle_fill_1.ogg', 25, TRUE)
			reagents.trans_to(I, min(freespc, reagents.total_volume))
			return TRUE
	. = ..()

/obj/machinery/recycler/attack_generic(mob/user)
	if(is_running() && (recycler_state & RECYCLER_FLAG_SHORTED))
		try_shock_thing(user)
	. = ..()

/obj/machinery/recycler/physical_attack_hand(mob/user)
	if(is_running() && (recycler_state & RECYCLER_FLAG_SHORTED))
		try_shock_thing(user)
		return FALSE
	if(get_dir(loc, user.loc) == dir)
		to_chat(user, SPAN_NOTICE("You can't reach the controls from this direction."))
		return FALSE

	//Toggle on/off
	visible_message(SPAN_NOTICE("\The [user] toggle [use_power? "off" : "on"] \the [src]."), SPAN_NOTICE("You toggle [use_power? "off" : "on"] \the [src]."))
	update_use_power(use_power? POWER_USE_OFF : POWER_USE_IDLE)
	return TRUE

/obj/machinery/recycler/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!can_crush(mover) || !is_running())
		return FALSE //Don't let in things that can't be crushed, or let in anything while the thing is off
	if(get_dir(loc, target) & dir)
		return TRUE //Can move in from the front only
	return ..()

/obj/machinery/recycler/CheckExit(atom/movable/O, target)
	var/mover_dir = get_dir(O.loc, target)
	if((mover_dir == dir) || (mover_dir == global.reverse_dir[dir]))
		return TRUE //Can always leave from those directions
	return FALSE //Can't get out any other ways

/obj/machinery/recycler/Bump(atom/movable/AM)
	. = ..()
	if(istype(AM))
		Bumped(AM)

/obj/machinery/recycler/Bumped(atom/movable/AM)
	if(!QDELETED(AM) && !AM.anchored && AM.simulated && is_running())
		try_shock_thing(AM) //Handle touching from any sides

//try shock the thing
/obj/machinery/recycler/proc/try_shock_thing(var/atom/movable/AM)
	if(!is_running() || QDELETED(AM))
		return
	if(isliving(AM))
		shock(AM, 100)
		return TRUE
	else
		spark_at(AM, 20, FALSE, src)
		use_power_oneoff(active_power_usage)
		return TRUE
