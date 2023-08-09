///////////////////////////////////////////////////////////////////
// Recycler
///////////////////////////////////////////////////////////////////

///Recycling machine for crushing trash and sometimes mobs into raw materials.
/obj/machinery/recycler
	name                           = "industrial crusher"
	desc                           = "A large crushing machine meant for reducing waste into smaller more easily processed bits."
	icon                           = 'icons/obj/recycling.dmi'
	icon_state                     = "grinder-o0"
	layer                          = ABOVE_HUMAN_LAYER
	anchored                       = TRUE
	density                        = TRUE
	use_power                      = POWER_USE_IDLE
	idle_power_usage               = 100
	active_power_usage             = 2.5 KILOWATTS
	core_skill                     = SKILL_ENGINES
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES
	wires                          = /datum/wires/recycler
	construct_state                = /decl/machine_construction/default/panel_closed
	uncreated_component_parts      = null
	maximum_component_parts        = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator     = 4,
		/obj/item/stock_parts/matter_bin      = 4,
		/obj/item/stock_parts                 = 16,
	)
	// stock_part_presets             = list(
	// 	/decl/stock_part_preset/radio/receiver/recycler,
	// )
	///Bitflag for keeping track of internal status
	var/recycler_state = 0
	///Percentage of materials recovered from the recycled item. Starting value is the maximum it'll go
	var/tmp/efficiency = 0.2
	///The maximum possible efficiency value for this machine.
	var/max_efficiency = 0.9

	///Prefix of the icon state for the grinder
	var/tmp/icon_prefix = "grinder-o"
	///Looped sound of the machine idling
	var/tmp/sound_idle       = 'sound/machines/creaky_loop.ogg'
	///Sound played when something is being grinded by the machine
	var/tmp/sound_processing = 'sound/machines/machine_wirr.ogg'
	///Sound played when materials are released from the machine
	var/tmp/sound_outputs    = 'sound/machines/hiss.ogg'
	///Sound played when something forbidden cause an emergency stop
	var/tmp/sound_emergency  = 'sound/machines/buzz-sigh.ogg'
	///Sound played when an obstruction is cleared and the machine is restarting
	var/tmp/sound_all_clear  = 'sound/machines/ping.ogg'
	///Sound played when something is still blocking the machine into emergency stop mode
	var/tmp/sound_obstructed = 'sound/machines/triple_beep.ogg'

	///Sound token to the looping grinder sound
	var/tmp/datum/sound_token/sound_looping
	///Amount of time the recycler will pause when it encounters an object triggering its emergency stop mode.
	var/emergency_stop_time = 5 SECONDS
	///Timer id for the looping jam warning timer
	var/tmp/timer_id_jam_warning
	///Things that caused the machine to emergency stop. When it's empty, we're clear to restart, if it has anything in it, we still have something blocking us
	var/tmp/list/emergency_stopping_objects
	///List of the mats we've just dispensed, to avoid processing them as trash.
	var/tmp/list/recently_dispensed_mats

	///Time we last outputed material dust
	var/tmp/time_last_output = 0
	///Time we last crushed something
	var/tmp/time_last_crush = 0
	///Time we last emitted a crush sound
	var/tmp/time_last_crush_sound = 0
	///Time we last issued a warning tone to users.
	var/tmp/time_last_warning_sound = 0
	///Time we last told users something bad is happening
	var/tmp/time_last_warning_msg = 0
	///Time we last told users an item clogging us was cleared
	var/tmp/time_last_cleared_msg = 0

	///Listener for things coming into the machine
	var/datum/proximity_trigger/square/crush_listener
	///The solid materials that were reclaimed from the recycled atoms. Kept separately from reagents, since phase shift isn't really working well rn.
	var/list/stored_materials
	///Types that should never be allowed in the recycler
	var/static/list/recycler_blacklist = list(
		/obj/item/projectile,
		/obj/item/disk/nuclear,
		/obj/machinery/nuclearbomb,
		/obj/item/integrated_circuit/manipulation/wormhole,
		/obj/item/integrated_circuit/input/teleporter_locator,
		/obj/item/card/id/captains_spare,
		/obj/item/pinpointer,
		/mob/living/silicon/pai,
		/obj/item/organ/internal/stack, //Avoid eating stacks for gameplay reasons
		/obj/item/holo,
		/obj/structure/holostool,
		/obj/structure/holohoop,
		/obj/structure/holonet,
		/obj/structure/holosign,
	)
	///Types of objects which are ignored only when the safeties are on
	var/static/list/recycler_safety_blacklist = list(
		/mob/living/bot,
		/mob/living/carbon/human,
		/mob/living/silicon/robot,
		/mob/living/simple_animal/cat,
		/mob/living/simple_animal/corgi,
		/mob/living/simple_animal/opossum,
		/mob/living/simple_animal/chick,
		/mob/living/simple_animal/chicken,
		/mob/living/simple_animal/cow,
		/obj/structure/closet,
		/obj/structure/safe,
		/obj/structure/aicore,
		/obj/structure/ship_munition,
		/obj/structure/stasis_cage,
		/obj/structure/artifact,
		/obj/item/anobattery,
		/obj/item/anodevice,
		/obj/item/grenade,
		/obj/item/gun,
		/obj/item/missile,
		/obj/item/harpoon/bomb,
		/obj/item/plastique,
		/obj/item/storage/secure,
		/obj/item/storage/lockbox,
		/obj/item/aicard,
		/obj/item/mmi,
		/obj/item/paicard,
	)

/obj/machinery/recycler/Initialize(mapload, d = 0, populate_parts = TRUE)
	. = ..()
	initialize_reagents()
	setup_turf_listener()
	update_icon()
	events_repository.register(/decl/observ/moved, src, src, /obj/machinery/recycler/proc/on_moved)

/obj/machinery/recycler/Destroy()
	events_repository.unregister(/decl/observ/moved, src, src, /obj/machinery/recycler/proc/on_moved)
	QDEL_NULL(crush_listener)
	QDEL_NULL(sound_looping)
	LAZYCLEARLIST(emergency_stopping_objects)
	return ..()

/obj/machinery/recycler/initialize_reagents(populate)
	if(!reagents)
		create_reagents(RECYCLER_INTERNAL_VOLUME)
	else
		reagents.maximum_volume = RECYCLER_INTERNAL_VOLUME
		reagents.update_total()
	. = ..()

///Install listener on the turf for anything that may come into it. Doesn't do anything in nullspace
/obj/machinery/recycler/proc/setup_turf_listener()
	if(!loc)
		return
	if(!QDELETED(crush_listener))
		QDEL_NULL(crush_listener)
	crush_listener = new(src, /obj/machinery/recycler/proc/on_atom_entered, null, 0, proc_owner = src) //Set range to 0, otherwise it picks everything around
	crush_listener.register_turfs()

/obj/machinery/recycler/proc/on_moved(var/atom/movable/am, var/atom/old_loc)
	if(am == old_loc || QDELETED(src))
		return
	setup_turf_listener()

/obj/machinery/recycler/power_change()
	. = ..()
	update_icon()
	update_sound()
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/recycler/update_use_power(new_use_power)
	. = ..()
	update_sound()
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/recycler/set_broken(new_state, cause)
	. = ..()
	update_sound()
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/recycler/RefreshParts()
	. = ..()
	var/scanner_rating = total_component_rating_of_type(/obj/item/stock_parts/scanning_module) //Max 3
	// var/manipulator_rating = total_component_rating_of_type(/obj/item/stock_parts/manipulator)     //Max 12
	// var/matter_bin_rating  = total_component_rating_of_type(/obj/item/stock_parts/matter_bin)      //

	//Scanner decides of the actual resulting efficiency
	efficiency = round((scanner_rating * max_efficiency) / 3, 0.1)

/obj/machinery/recycler/on_update_icon()
	cut_overlays()
	var/prefix = "[icon_prefix][is_running()]"
	icon_state = prefix
	if(blood_color)
		add_overlay(overlay_image(icon, "[prefix]-blood-overlay", blood_color))

///Update looping sounds depending on the state of the machine
/obj/machinery/recycler/proc/update_sound()
	if(is_running())
		if(!sound_looping)
			sound_looping = play_looping_sound(src, "recycler", sound_idle, volume = 12, range = 8, falloff = 2/*, prefer_mute = TRUE*/)
		else
			sound_looping.Unpause()
			sound_looping.Unmute()
	else if(sound_looping)
		sound_looping.Pause()
		sound_looping.Mute()

/obj/machinery/recycler/Process()
	if(inoperable() || !length(stored_materials))
		return PROCESS_KILL

	if((time_last_output + RECYCLER_OUTPUT_INTERVAL) < REALTIMEOFDAY)
		try_output()

///Output a sound warning about the thing being jammed.
/obj/machinery/recycler/proc/warn_about_jam()
	if(!(recycler_state & RECYCLER_FLAG_EMERGENCY))
		deltimer(timer_id_jam_warning)
		timer_id_jam_warning = null
		set_light(0)
		return //Stop warning

	playsound(src, sound_obstructed, 40, frequency = 32000)
	if(light_power > 0.5)
		set_light(1, 0.2, COLOR_RED_LIGHT)
	else
		set_light(2, 0.9, COLOR_RED_LIGHT)

///Attempt setting the machine into standby mode
/obj/machinery/recycler/proc/try_standby()
	if(inoperable() || (use_power < POWER_USE_ACTIVE))
		return
	update_use_power(POWER_USE_IDLE)

///Returns whether the recycler is powered, operational and not in emergency mode.
/obj/machinery/recycler/proc/is_running()
	return operable() && use_power && !(recycler_state & (RECYCLER_FLAG_EMERGENCY | RECYCLER_FLAG_POWER_CUT))

///Returns false if something is on one of the forbidden list, depending on whether safe mode is on or not.
/obj/machinery/recycler/proc/is_allowed_to_crush(var/atom/movable/AM)
	if(is_type_in_list(AM, recycler_blacklist))
		return FALSE
	//When safety on, we don't grind living mobs, or the deceased that are/were player owned
	if(!(recycler_state & RECYCLER_FLAG_UNSAFE))
		if(is_type_in_list(AM, recycler_safety_blacklist))
			return FALSE
		if(isliving(AM) && is_mob_player_owned(AM))
			return FALSE //Don't let living player controlled movs go through in safe mode
	return TRUE

///Whether the given atom can even be crushed by the machine.
/obj/machinery/recycler/proc/can_crush(var/atom/movable/AM)
	. = !QDELETED(AM) && !AM.anchored && AM.simulated && !LAZYISIN(recently_dispensed_mats, AM)

/obj/machinery/recycler/add_blood(mob/living/carbon/human/M)
	. = ..()
	update_icon()

////////////////////////////////////////////////////
// Emergency Stop Handling
////////////////////////////////////////////////////

///Stop grinding things for a few seconds
/obj/machinery/recycler/proc/try_emergency_stop(var/atom/movable/stopper)
	if(stopper)
		track_forbidden_object(stopper)
	if(!is_running())
		return

	//Warn about new things clogging us up once in a while, or if it's the first block since unblocked
	if(!(recycler_state & RECYCLER_FLAG_EMERGENCY) || ((time_last_warning_msg + RECYCLER_FORBIDDEN_NAG_INTERVAL) <= REALTIMEOFDAY))
		time_last_warning_msg = REALTIMEOFDAY
		state(SPAN_WARNING("Warning forbidden object detected \icon[stopper][stopper]!"), "red")
		playsound(src, sound_emergency, 20, vary = FALSE, extrarange = 8, falloff = 3)
		//Start the nagging warning timer
		timer_id_jam_warning = addtimer(CALLBACK(src, /obj/machinery/recycler/proc/warn_about_jam), RECYCLER_EMERGENCY_NAG_INTERVAL, TIMER_UNIQUE | TIMER_LOOP | TIMER_STOPPABLE)

	if((recycler_state & RECYCLER_FLAG_EMERGENCY))
		return

	//make sure the flag is set as soon as something is in the list
	recycler_state |= RECYCLER_FLAG_EMERGENCY
	update_icon()
	update_sound()

///Restart the machine after an emergency stop
/obj/machinery/recycler/proc/try_clear_emergency_stop(var/atom/movable/stopper)
	if(stopper)
		untrack_forbidden_object(stopper)
	if(!(recycler_state & RECYCLER_FLAG_EMERGENCY))
		return //Don't play the sound again

	//make sure the flag is cleared as soon as the list is empty
	if(!LAZYLEN(emergency_stopping_objects))
		recycler_state &= ~RECYCLER_FLAG_EMERGENCY

	if(time_last_cleared_msg + (RECYCLER_CLEARED_MSG_INTERVAL) <= REALTIMEOFDAY)
		time_last_cleared_msg = REALTIMEOFDAY
		//state("Obstruction cleared! Attempting to resume..", "blue")
		playsound(src, sound_all_clear, 20, vary = FALSE, extrarange = 8, falloff = 3)

	update_icon()
	update_sound()

///Adds some listener onto a given object to tell when it leaves our turf, and we should be safe to restart
/obj/machinery/recycler/proc/track_forbidden_object(var/atom/movable/stopper)
	LAZYDISTINCTADD(emergency_stopping_objects, stopper)
	events_repository.register(/decl/observ/moved,     stopper, src, /obj/machinery/recycler/proc/on_forbidden_atom_exited)
	events_repository.register(/decl/observ/destroyed, stopper, src, /obj/machinery/recycler/proc/on_forbidden_atom_exited)

///Stop tracking an object that's been blocking us in emergency stop mode.
/obj/machinery/recycler/proc/untrack_forbidden_object(var/atom/movable/stopper)
	LAZYREMOVE(emergency_stopping_objects, stopper)
	events_repository.unregister(/decl/observ/moved,     stopper, src, /obj/machinery/recycler/proc/on_forbidden_atom_exited)
	events_repository.unregister(/decl/observ/destroyed, stopper, src, /obj/machinery/recycler/proc/on_forbidden_atom_exited)

///Track outgoing material stacks so we don't consume them again, and still let them glide gracefully out the back.
/obj/machinery/recycler/proc/track_dispensed_materials(var/list/dispensed)
	for(var/atom/movable/AM in dispensed)
		LAZYDISTINCTADD(recently_dispensed_mats, AM)
		events_repository.register(/decl/observ/moved,     AM, src, /obj/machinery/recycler/proc/on_dispensed_exited)
		events_repository.register(/decl/observ/destroyed, AM, src, /obj/machinery/recycler/proc/on_dispensed_exited)

///Called by the turf listener when something enters our turf.
/obj/machinery/recycler/proc/on_atom_entered(var/atom/movable/AM)
	if(QDELETED(AM) || !istype(AM) || AM.anchored || !AM.simulated)
		return
	crush(AM)

///Called by forbidden object leaving our turf.
/obj/machinery/recycler/proc/on_forbidden_atom_exited(var/atom/movable/AM)
	if(get_turf(AM) == get_turf(src))
		return
	try_clear_emergency_stop(AM)

///Called when one of the stacks we've dispensed leaves the turf.
/obj/machinery/recycler/proc/on_dispensed_exited(var/atom/movable/AM)
	if(get_turf(AM) == get_turf(src))
		return
	LAZYREMOVE(recently_dispensed_mats, AM)
	events_repository.unregister(/decl/observ/moved,     AM, src, /obj/machinery/recycler/proc/on_dispensed_exited)
	events_repository.unregister(/decl/observ/destroyed, AM, src, /obj/machinery/recycler/proc/on_dispensed_exited)

////////////////////////////////////////////////////
//Trash Processing
////////////////////////////////////////////////////

///Handles crushing a given atom.
/obj/machinery/recycler/proc/crush(var/atom/movable/AM, var/crushsound = TRUE, var/recursive_depth = 1)
	if(!is_running())
		return
	if(recycler_state & RECYCLER_FLAG_SHORTED)
		try_shock_thing(AM)
	if(!can_crush(AM))
		LAZYREMOVE(recently_dispensed_mats, AM)
		return

	time_last_crush = world.timeofday
	if(!is_allowed_to_crush(AM))
		try_emergency_stop(AM)
		return

	if(use_power != POWER_USE_ACTIVE)
		update_use_power(POWER_USE_ACTIVE)

	//Make sure we try outputing and also go to standby later.
	addtimer(CALLBACK(src, /obj/machinery/recycler/proc/try_standby), RECYCLER_STANDBY_INTERVAL, TIMER_STOPPABLE | TIMER_UNIQUE)
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

	if(isliving(AM))
		crush_mob(AM, crushsound, recursive_depth)
	else
		crush_thing(AM, crushsound, recursive_depth)

///Crushes an object and its contents
/obj/machinery/recycler/proc/crush_thing(var/obj/O, var/crushsound = TRUE, var/recursive_depth = 1)
	//Prevent the conveyor belt from moving the thing as we're destroying it
	O.anchored = TRUE

	//Extract Matter
	for(var/matpath in O.matter)
		if(O.matter[matpath] <= 0)
			continue
		store_solid(matpath, O.matter[matpath])
	//Extract Reagents
	if(O.reagents?.total_volume >= 0)
		store_reagents(O.reagents)

	//Handle contents
	for(var/atom/movable/AM in O.get_contained_external_atoms())
		if(!can_crush(AM) || !is_allowed_to_crush(AM))
			continue
		crush(AM, FALSE, recursive_depth + 1)

	//Destroy the thing
	O.physically_destroyed()

	//Play sound effects
	if(crushsound && (world.realtime >= (time_last_crush_sound + 1 SECONDS))) //Prevent sound spam
		time_last_crush_sound = world.realtime
		addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, src, sound_processing, 45, TRUE, 8, 3), 0, TIMER_UNIQUE)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, src, RECYCLER_SOUND_CRUSH_OBJECT, 50, TRUE), 1, TIMER_UNIQUE)

///Crushes a mob and it's contents
/obj/machinery/recycler/proc/crush_mob(var/mob/living/L, var/crushsound = TRUE, var/recursive_depth = 1)
	if(L.key)
		log_and_message_staff("\The [L] played by key:[L.ckey], was crushed by \the [src] ([x],[y],[z]).", L, loc)

	add_blood(L)
	L.apply_damage(RECYCLER_MOB_CRUSH_DAMAGE, BRUTE, null, DAM_DISPERSED | DAM_EDGE, "[src]", 50, TRUE)

	//Chance to lose a limb
	for(var/obj/item/organ/external/E in L.get_external_organs())
		if(!E.is_vital_to_owner() && prob(10))
			E.dismember(FALSE, DISMEMBER_METHOD_BLUNT, FALSE, FALSE, TRUE)

	L.apply_damage(15, PAIN, null, DAM_DISPERSED, silent = TRUE)
	SET_STATUS_MAX(L, WEAKEN, 2)
	SET_STATUS_MAX(L, STUN,   5)
	//L.apply_effect(2, WEAKEN)
	//L.apply_effect(5, STUN)

	//Play engine straining sound
	if(crushsound)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, src, sound_processing, 45, TRUE, 8, 3), 0, TIMER_UNIQUE)
	//Play break down sound #TODO: Ideally, use the break sound of each things when that's implemented
	if(isrobot(L))
		addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, src, RECYCLER_SOUND_CRUSH_OBJECT, 50, TRUE), 1, TIMER_UNIQUE)
	else
		addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, src, RECYCLER_SOUND_CRUSH_ORGANIC, 50, TRUE), 1, TIMER_UNIQUE)

	if(L.is_dead() || (L.mob_size <= MOB_SIZE_TINY))
		L.gib()
		return

	//If alive, eat some of their gear. Using disposals to travel isn't free >:)
	for(var/obj/item/I in L.get_equipped_items())
		if(prob(90))
			continue //90% chances to keep your items if alive
		if(L.unequip(I))
			crush(I, FALSE, recursive_depth + 1)

////////////////////////////////////////////////////
//Material Storage/Handling
////////////////////////////////////////////////////

/obj/machinery/recycler/proc/store_solid(var/matpath, var/amount)
	var/newamount = LAZYACCESS(stored_materials, matpath) + amount
	LAZYSET(stored_materials, matpath, newamount)
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/recycler/proc/remove_solid(var/matpath, var/amount)
	var/newamount = LAZYACCESS(stored_materials, matpath) - amount
	LAZYSET(stored_materials, matpath, newamount)
	if(stored_materials[matpath] <= 0)
		LAZYREMOVE(stored_materials, matpath)

/obj/machinery/recycler/proc/store_reagents(var/datum/reagents/incoming)
	if(incoming?.total_volume <= 0)
		return
	var/overflow = max(0, (incoming.total_volume + reagents.total_volume) - reagents.maximum_volume)
	incoming.trans_to_obj(src, efficiency * min(incoming.total_volume, reagents.maximum_volume))
	if(overflow && loc)
		incoming.trans_to(loc, overflow)

///Attempts expelling the results of the grinding. Returns the amount of matter sheets created.
/obj/machinery/recycler/proc/try_output(var/play_sound = TRUE)
	if(!is_running())
		return
	. = 0
	for(var/matpath in stored_materials)
		var/decl/material/M = GET_DECL(matpath)
		var/list/powder_mat = atom_info_repository.get_matter_for(M.powder_type, M.type, 1)
		var/amount_per_pile = LAZYACCESS(powder_mat, M.type)

		if(stored_materials[matpath] >= amount_per_pile)
			var/list/newstacks = M.place_dust(null, stored_materials[matpath], FALSE)
			track_dispensed_materials(newstacks) //Prevents us from consuming the stacks right after spawning them
			for(var/obj/item/stack/material/dust/D in newstacks)
				. += D.amount
				remove_solid(matpath, D.matter[matpath])
				D.forceMove(loc)

		if(. > 0)
			break //Only output a single type of material per call!

	if(. > 0)
		if(play_sound && (world.timeofday >= (time_last_output + 2 SECONDS))) //Prevent sound spam
			playsound(src, sound_outputs, 30, frequency = rand(42000, 55000), extrarange = 8, falloff = 3)
		time_last_output = world.timeofday

/obj/machinery/recycler/dump_contents()
	. = ..()
	if(isnull(loc))
		return //Don't drop anything in nullspace

	for(var/matpath in stored_materials)
		var/decl/material/M = GET_DECL(matpath)
		M.place_dust(loc, stored_materials[matpath], TRUE)
		LAZYREMOVE(stored_materials, matpath)

	if(reagents?.total_volume > 0)
		reagents.trans_to(loc, reagents.total_volume)
