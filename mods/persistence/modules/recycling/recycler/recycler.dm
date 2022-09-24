#define RECYCLER_INTERNAL_VOLUME 2500          ///Internal reagent volume of the reagent's storage
#define RECYCLER_OUTPUT_INTERVAL 2 SECONDS     ///Delay between outputs of dust
#define RECYCLER_MAX_SANE_CONTAINER_DEPTH 50   ///Used to prevent ending up with a near infinite recursion when adding up contained items

///////////////////////////////////////////////////////////////////
// Recycler
///////////////////////////////////////////////////////////////////
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
	base_type                      = /obj/machinery/recycler/buildable
	construct_state                = /decl/machine_construction/default/panel_closed
	uncreated_component_parts      = list(
		/obj/item/stock_parts/power/apc/buildable,
	)
	maximum_component_parts        = list(
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/manipulator     = 4,
		/obj/item/stock_parts/matter_bin      = 4,
		/obj/item/stock_parts                 = 16,
	)
	stock_part_presets             = list(
		/decl/stock_part_preset/radio/receiver/recycler,
	)

	var/tmp/icon_prefix           = "grinder-o"                         ///Prefix of the icon state for the grinder
	var/tmp/sound_idle            = 'sound/machines/creaky_loop.ogg'    ///Looped sound of the machine idling
	var/tmp/sound_processing      = 'sound/machines/machine_wirr.ogg'   ///Sound played when something is being grinded by the machine
	var/tmp/sound_outputs         = 'sound/machines/hiss.ogg'           ///Sound played when materials are released from the machine

	var/tmp/datum/sound_token/sound_looping    ///Sound token to the looping grinder sound
	var/tmp/atom/movable/grinding              ///What we're currently grinding down.
	var/tmp/emergency_stopped     = FALSE      ///Temporality stops the machine if it detects a mob
	var/emergency_stop_time       = 5 SECONDS  ///Amount of time the recycler will pause when it encounters an object triggering its emergency stop mode.
	var/overheating               = FALSE      ///If set to true the machine will overheat each times it eats something and spit sparks
	var/shorted                   = FALSE      ///If set to true the machine will electrocute people like grilles
	var/ignore_safety             = FALSE      ///If set to true will process anything without checking, unless its indestructible or in the black list
	var/power_cut                 = FALSE      ///If set to true will be in a forced powered down state until toggled back on
	var/efficiency                = 0.2        ///Percentage of materials recovered from the recycled item. Starting value is the maximum it'll go
	var/tmp/time_last_output      = 0          ///Time we last outputed material dust
	var/tmp/time_last_crush       = 0          ///Time we last crushed something

	/**list of all the solid material we've accumulated so far. Handled this way to prevent random bullshit reactions and allow planned bullshit reactions. */
	var/list/solid_matter

	var/static/recycler_max_efficiency = 0.9
	///Types that should never be allowed in the recycler
	var/static/list/recycler_blacklist = list(
		/obj/item/disk/nuclear,
		/obj/machinery/nuclearbomb,
		/obj/item/integrated_circuit/manipulation/wormhole,
		/obj/item/integrated_circuit/input/teleporter_locator,
		/obj/item/card/id/captains_spare,
		/obj/item/aicard,
		/obj/item/mmi,
		/obj/item/paicard,
		/obj/item/pinpointer,
		/mob/living/silicon/pai,
		/obj/item/organ/internal/stack,    //Avoid eating stacks for gameplay reasons
	)
	///Types of objects which are ignored only when the safeties are on
	var/static/list/recycler_safety_blacklist = list(
		/mob/living/carbon/human,
		/mob/living/silicon/robot,
		/mob/living/simple_animal/cat,
		/mob/living/simple_animal/corgi,
		/mob/living/simple_animal/opossum,
		/mob/living/simple_animal/chick,
		/mob/living/simple_animal/chicken,
		/mob/living/simple_animal/cow,
		/obj/structure/closet,
	)

/obj/machinery/recycler/buildable
	uncreated_component_parts = null

/obj/machinery/recycler/Initialize(mapload, d, populate_parts)
	. = ..()
	initialize_reagents()
	update_icon()

/obj/machinery/recycler/Destroy()
	QDEL_NULL(sound_looping)
	grinding = null
	return ..()

/obj/machinery/recycler/power_change()
	. = ..()
	update_icon()
	update_sound()

/obj/machinery/recycler/RefreshParts()
	. = ..()
	var/scanner_rating     = total_component_rating_of_type(/obj/item/stock_parts/scanning_module) //Max 3
	// var/manipulator_rating = total_component_rating_of_type(/obj/item/stock_parts/manipulator)     //Max 12
	// var/matter_bin_rating  = total_component_rating_of_type(/obj/item/stock_parts/matter_bin)      //

	//Scanner decides of the actual resulting efficiency
	efficiency = round((scanner_rating * recycler_max_efficiency) / 3, 0.1)

/obj/machinery/recycler/Process()
	if(inoperable())
		return PROCESS_KILL
	//Wait until we hanven't processed anything in a while to go to idle
	if(use_power == POWER_USE_ACTIVE)
		if((time_last_crush + 5 SECONDS) >= REALTIMEOFDAY)
			update_use_power(POWER_USE_IDLE)

	//If we have materials to release, do it
	if(LAZYLEN(solid_matter))
		if((time_last_output + RECYCLER_OUTPUT_INTERVAL) > REALTIMEOFDAY)
			try_output()
	else
		return PROCESS_KILL
	return

/obj/machinery/recycler/on_update_icon()
	cut_overlays()
	var/running = is_running()
	//icon_state = "[icon_prefix][running][blood_color? "bld" : ""]"
	icon_state = "[icon_prefix][running]"
	if(blood_color)
		add_overlay(overlay_image(icon, "[icon_prefix][running]-blood-overlay", blood_color))

/obj/machinery/recycler/examine(mob/user)
	. = ..()
	to_chat(user, "The power light is [is_operable()? "on" : "off"].")
	to_chat(user, "The safety-mode light is [!ignore_safety ? "on" : "off"].")
	to_chat(user, "The safety-sensors status light is [emagged ? "off" : "on"].")
	to_chat(user, "The internal tank reads [reagents.total_volume]/[reagents.maximum_volume] units of reagents.")

/obj/machinery/recycler/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	if(emagged)
		return .
	if(remaining_charges < 1)
		to_chat(user, SPAN_WARNING("\The [emag_source] is out of charges!"))
		return .
	emagged = TRUE
	if(!ignore_safety)
		ignore_safety = TRUE
		update_icon()
	playsound(src, "sparks", 75, TRUE, extrarange = -1)
	spark_at(src, 2, TRUE, user)
	to_chat(user, SPAN_NOTICE("You use \the [emag_source] on \the [src]."))
	return 1 //One use

/obj/machinery/recycler/Bump(atom/movable/AM)
	. = ..()
	if(istype(AM))
		Bumped(AM)

/obj/machinery/recycler/Crossed(atom/movable/AM)
	. = ..()
	if(!is_running() || QDELETED(AM))
		return
	if(shorted)
		try_shock_thing(AM)

/obj/machinery/recycler/attackby(obj/item/I, mob/user)
	if(is_running() && shorted && I.obj_flags & OBJ_FLAG_CONDUCTIBLE)
		try_shock_thing(user)
	. = ..()

/obj/machinery/recycler/attack_generic(mob/user)
	if(is_running() && shorted)
		try_shock_thing(user)
	. = ..()

/obj/machinery/recycler/physical_attack_hand(mob/user)
	if(is_running() && shorted)
		try_shock_thing(user)
	. = ..()

/obj/machinery/recycler/Bumped(atom/movable/AM)
	if(QDELETED(AM) || AM.anchored || !AM.simulated || !is_running())
		return
	if(shorted)
		try_shock_thing(AM) //Handle touching from any sides
	if((get_dir(loc, AM.loc) != dir) || grinding)
		return
	if(!can_crush(AM))
		emergency_stop()
		AM.forceMove(loc)
		return
	grinding = AM
	AM.forceMove(loc)
	crush(AM)
	grinding = null

/obj/machinery/recycler/initialize_reagents(populate)
	if(!reagents)
		create_reagents(RECYCLER_INTERNAL_VOLUME)
	else
		reagents.maximum_volume = RECYCLER_INTERNAL_VOLUME
		reagents.update_total()
	. = ..()

/obj/machinery/recycler/proc/is_running()
	return operable() && use_power && !emergency_stopped

/obj/machinery/recycler/proc/can_crush(var/atom/movable/AM)
	. = !is_type_in_list(AM, ignore_safety? recycler_blacklist : (recycler_blacklist | recycler_safety_blacklist))

/obj/machinery/recycler/proc/crush(var/atom/movable/AM, var/crushsound = TRUE, var/recursive_depth = 1)
	if(!can_crush(AM))
		AM.forceMove(loc)
		return //Need to check again because we don't wanna stop the machine over contained stuff
	if(use_power != POWER_USE_ACTIVE)
		update_use_power(POWER_USE_ACTIVE)
	time_last_crush = REALTIMEOFDAY
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF) //Make sure to reduce power usage once we're done crushing a big batch

	if(isliving(AM))
		crush_mob(AM, crushsound, recursive_depth)
	else
		crush_thing(AM, crushsound, recursive_depth)

/obj/machinery/recycler/proc/crush_thing(var/obj/O, var/crushsound = TRUE, var/recursive_depth = 1)
	//Extract Matter
	if(LAZYLEN(O.matter))
		for(var/matpath in O.matter)
			if(O.matter[matpath] <= 0)
				continue
			store_solid(matpath, O.matter[matpath])
	//Extract Reagents
	if(O.reagents?.total_volume >= 1)
		var/overflow = max(0, (O.reagents.total_volume + reagents.total_volume) - reagents.maximum_volume)
		O.reagents.trans_to_obj(src, efficiency * min(O.reagents.total_volume, reagents.maximum_volume))
		if(overflow && loc)
			O.reagents.trans_to(loc, overflow)

	//Handle contents
	for(var/atom/movable/AM in O.get_contained_external_atoms())
		crush(AM, FALSE, recursive_depth + 1)

	//Cleanup and effects
	O.physically_destroyed()
	if(crushsound)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, src, sound_processing, 50, TRUE, 8, 3), 5)
		playsound(O, 'sound/items/Welder.ogg', 50, TRUE)

/obj/machinery/recycler/proc/crush_mob(var/mob/living/L, var/crushsound = TRUE, var/recursive_depth = 1)
	if(!ignore_safety && ishuman(L))
		emergency_stop()
		return
	if(L.key)
		log_and_message_staff("\The [L] played by key:[L.ckey], was crushed by \the [src] ([x],[y],[z]).", L, loc)

	add_blood(L)
	L.apply_damage(rand(48, 72), BRUTE, null, DAM_DISPERSED | DAM_EDGE, "[src]", 50, TRUE)
	L.apply_effect(2,  WEAKEN)
	L.apply_effect(5,  STUN)
	if(crushsound)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, src, sound_processing, 50, TRUE, 8, 3), 5)

	if(isrobot(L))
		playsound(L, 'sound/items/Welder.ogg', 50, TRUE)
	else
		playsound(L, 'sound/effects/splat.ogg', 50, TRUE)

	if(!L.is_dead())
		for(var/obj/item/I in L.get_equipped_items())
			if(prob(90))
				continue //90% chances to keep your items if alive
			if(L.unEquip(I))
				crush(I, FALSE, recursive_depth + 1)
	else
		L.gib()
	update_icon()

///Stop grinding things for a few seconds
/obj/machinery/recycler/proc/emergency_stop()
	if(!is_running())
		return
	playsound(src, 'sound/machines/buzz-sigh.ogg', 40, vary = FALSE, extrarange = 8, falloff = 3)
	emergency_stopped = TRUE
	addtimer(CALLBACK(src, .proc/clear_emergency_stop), emergency_stop_time)
	update_icon()
	update_sound()

///Restart the machine after an emergency stop
/obj/machinery/recycler/proc/clear_emergency_stop()
	emergency_stopped = FALSE
	update_icon()
	update_sound()
	ping()

/obj/machinery/recycler/proc/set_overheating(var/state)
	overheating = state
/obj/machinery/recycler/proc/set_shorted(var/state)
	shorted = state

///Attempts expelling the results of the grinding
/obj/machinery/recycler/proc/try_output()
	. = 0
	//If we got some solid materials output them
	for(var/matpath in solid_matter)
		var/decl/material/M = GET_DECL(matpath)
		var/nb_create = solid_matter[matpath] / 100
		if(nb_create > 0)
			solid_matter[matpath] = solid_matter[matpath] % 100
			M.create_object(loc, nb_create, /obj/item/stack/material/dust)
			. += nb_create
		if(solid_matter[matpath] <= 0)
			LAZYREMOVE(solid_matter, matpath)
		if(. > 0)
			break //Only output a single type of material per call!

	if(. > 0)
		playsound(src, sound_outputs, 30, vary = TRUE, extrarange = 8, falloff = 3)

/obj/machinery/recycler/proc/store_solid(var/matpath, var/amount)
	var/newamount = LAZYACCESS(solid_matter, matpath) + amount
	LAZYSET(solid_matter, matpath, newamount)
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

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

/obj/machinery/recycler/proc/update_sound()
	if(is_running())
		if(!sound_looping)
			sound_looping = play_looping_sound(src, "recycler", sound_idle, volume = 25, range = 5, falloff = 2, prefer_mute = TRUE)
		else
			sound_looping.Unpause()
	else if(sound_looping)
		sound_looping.Pause()


#undef RECYCLER_INTERNAL_VOLUME
#undef RECYCLER_OUTPUT_INTERVAL
#undef RECYCLER_MAX_SANE_CONTAINER_DEPTH