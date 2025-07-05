//#define STARTING_POINTS 30

//Make sure players cannot build this pod
/obj/item/stock_parts/circuitboard/cryopod/get_buildable_types()
	return ..() - /obj/machinery/cryopod/chargen

/////////////////////////////////////////////////////////////////
// Chargen Pod
/////////////////////////////////////////////////////////////////

/obj/machinery/cryopod/chargen
	base_type         = /obj/machinery/cryopod/chargen //Prevents using the circuit board from the base cryopod
	construct_state   = /decl/machine_construction/noninteractive //Prevents tampering, and needing components
	frame_type        = null
	interact_offline  = TRUE //Don't worry about power
	stat_immune       = ~0 //Immune to everything
	is_spawnable_type = FALSE //Prevent unit tests from trying to spawn these outside of a chargen area

	///The spawn point provider that player completing chargen will be sent to.
	var/spawn_decl = /decl/spawnpoint/arrival_chargen

/obj/machinery/cryopod/chargen/Initialize(mapload, d, populate_parts)
	. = ..()
	icon_state = occupied_icon_state //Those starts closed
	var/area/chargen/A = get_area(src)
	if(istype(A))
		A.register_chargen_state_change_listener(src, /obj/machinery/cryopod/chargen/proc/on_chargen_state_changed)
	else
		CRASH("[log_info_line(src)] was not initialized inside a chargen area!")

/obj/machinery/cryopod/chargen/proc/on_chargen_state_changed(area/source, new_state, old_state)
	if(new_state == CHARGEN_STATE_FORM_COMPLETE)
		ready_for_mingebag()
	if(new_state == CHARGEN_STATE_FORM_INCOMPLETE)
		unready()

/**
 * Open the canopy and light up to let the player that just finished the form get in!
 */
/obj/machinery/cryopod/chargen/proc/ready_for_mingebag()
	set_light(10, 1, COLOR_CYAN_BLUE)
	icon_state = base_icon_state
	if(open_sound)
		playsound(src, open_sound, 40)

/obj/machinery/cryopod/chargen/proc/unready()
	icon_state = occupied_icon_state
	set_light(0, null)
	if(close_sound)
		playsound(src, close_sound, 40)

/**
 * Setup the player and move them to the actual station.
 */
/obj/machinery/cryopod/chargen/proc/send_to_outpost()
	if(!istype(occupant))
		return

	// Add the mob to limbo for safety. Mark for removal on the next save.
	SSpersistence.AddToLimbo(list(occupant, occupant.mind), occupant.mind.unique_id, LIMBO_MIND, occupant.mind.key, occupant.mind.current.real_name, TRUE, occupant.mind.key)
	SSpersistence.limbo_removals += list(list(sanitize_sql(occupant.mind.unique_id), LIMBO_MIND))
	SSchargen.queue_player_world_spawn(occupant, GET_DECL(spawn_decl))

/obj/machinery/cryopod/chargen/check_occupant_allowed(mob/M)
	. = ..()
	if(!.)
		return
	var/allowed = (M.mind.chargen_state >= CHARGEN_STATE_FORM_COMPLETE)
	if(!allowed)
		to_chat(M, SPAN_NOTICE("The [src] beeps: Please finish your dossier on the terminal before proceeding to cryostasis."))
	return allowed

///Called when the occupant is force moved outside the pod
/obj/machinery/cryopod/chargen/proc/on_occupant_forcemoved_out(mob/living/carbon/human/occupant)
	//#FIXME: Once cryopods are less shitty and properly clean up the client.eye remove this..
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	set_occupant(null)

/obj/machinery/cryopod/chargen/set_occupant(mob/living/carbon/human/occupant, silent)
	var/mob/previous_occupant = occupant
	//Attempt to prevent dropping any held items when transfering
	if(occupant)
		for(var/atom/movable/thing in occupant.get_held_items())
			occupant.equip_to_storage(thing)
	. = ..()
	if(src.occupant)
		events_repository.register(/decl/observ/moved, src.occupant, src, /obj/machinery/cryopod/chargen/proc/on_occupant_forcemoved_out)
		src.occupant.mind.set_player_chargen_state(CHARGEN_STATE_AWAITING_SPAWN)
		if(!silent)
			to_chat(src.occupant, SPAN_NOTICE("The [src] beeps: Launch procedure initiated. Please wait..."))
		addtimer(CALLBACK(src, /obj/machinery/cryopod/chargen/proc/send_to_outpost), 2 SECONDS)
	else
		if(previous_occupant)
			events_repository.unregister(/decl/observ/moved, previous_occupant, src, /obj/machinery/cryopod/chargen/proc/on_occupant_forcemoved_out)
			if(previous_occupant.mind?.chargen_state == CHARGEN_STATE_AWAITING_SPAWN)
				previous_occupant.mind.set_player_chargen_state(CHARGEN_STATE_FORM_COMPLETE)
				if(!silent)
					to_chat(previous_occupant, SPAN_DANGER("The [src] beeps: Launch procedure ABORTED."))

/obj/machinery/cryopod/chargen/Process()
	return PROCESS_KILL

//#undef STARTING_POINTS