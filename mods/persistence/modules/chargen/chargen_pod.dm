//#define STARTING_POINTS 30

/////////////////////////////////////////////////////////////////
// Chargen Pod
/////////////////////////////////////////////////////////////////

/obj/machinery/cryopod/chargen
	///The spawn point provider that player completing chargen will be sent to.
	var/spawn_decl = /decl/spawnpoint/arrival_chargen

/obj/machinery/cryopod/chargen/Initialize(mapload, d, populate_parts)
	. = ..()
	icon_state = occupied_icon_state //Those starts closed
	var/area/chargen/A = get_area(src)
	if(istype(A))
		A.register_chargen_state_change_listener(src, /obj/machinery/cryopod/chargen/proc/on_chargen_state_changed)
	else
		log_warning("[src] char generator crypod spawned in non-chargen area [get_area(src)].")

/obj/machinery/cryopod/chargen/proc/on_chargen_state_changed(new_state, old_state)
	if(new_state == CHARGEN_STATE_FORM_COMPLETE)
		ready_for_mingebag()
	if(new_state == CHARGEN_STATE_FORM_INCOMPLETE)
		unready()

/obj/machinery/cryopod/chargen/proc/set_chargen_awaiting_spawn()
	var/area/chargen/A = get_area(src)
	if(!istype(A))
		CRASH("[src] is placed inside an area type that wasn't a subtype of '/area/chargen'!:\n[log_info_line(src)]")
	A.set_chargen_state(CHARGEN_STATE_AWAITING_SPAWN)

/obj/machinery/cryopod/chargen/proc/ready_for_mingebag()
	set_light(10, 1, COLOR_CYAN_BLUE)
	icon_state = base_icon_state
	if(open_sound)
		playsound(src, open_sound, 40)

/obj/machinery/cryopod/chargen/proc/unready()
	icon_state = occupied_icon_state
	set_light(0, null)

// Chargen pod
/obj/machinery/cryopod/chargen/proc/send_to_outpost()
	set waitfor = FALSE
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
	var/allowed = M.mind.finished_chargen
	if(!allowed)
		to_chat(M, SPAN_NOTICE("The [src] beeps: Please finish your dossier on the terminal before proceeding to cryostasis."))
	return allowed

/obj/machinery/cryopod/chargen/set_occupant(mob/living/carbon/human/occupant, silent)
	//Attempt to prevent dropping any held items when transfering
	if(occupant)
		for(var/atom/movable/thing in occupant.get_held_items())
			occupant.equip_to_storage(thing)
	. = ..()
	if(occupant)
		set_chargen_awaiting_spawn() //Tell the area we're awaiting spawn
		to_chat(occupant, SPAN_NOTICE("The [src] beeps: Launch procedure initiated. Please wait..."))
		addtimer(CALLBACK(src, /obj/machinery/cryopod/chargen/proc/send_to_outpost), 5 SECONDS)

/obj/machinery/cryopod/chargen/Process()
	return PROCESS_KILL

//#undef STARTING_POINTS