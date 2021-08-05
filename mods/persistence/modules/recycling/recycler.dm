#define RECYCLER_REAGENTS_VOLUME 			2000
#define RECYCLER_ICON_STATE_BASE_NAME 		"grinder-o"
#define RECYCLER_MAX_SANE_CONTAINER_DEPTH 	50 //Used to prevent ending up with an infinite recursion when adding up contained items
#define RECYCLER_SAFETY_COOLDOWN 			10 SECONDS
#define RECYCLER_OUTPUT_DELAY 				5 SECONDS //intervals between material being outputed by the machine
#define RECYCLER_IDLE_SOUND_VOLUME 			25
#define RECYCLER_ACTIVE_SOUND_VOLUME 		40
#define RECYCLER_FEEDBACK_SOUND_VOLUME 		50
#define RECYCLER_MEAT_EFFICIENCY 			0.5
#define RECYCLER_BLOOD_EFFICIENCY 			0.25

///////////////////////
// Blacklist
///////////////////////
var/global/list/recycler_item_blacklist = list(
		/obj/item/projectile, //not meant to be a portable shield
	)

///////////////////////
// Circuit Board
///////////////////////
/obj/item/stock_parts/circuitboard/recycler
	name = "circuitboard (recycler)"
	build_path = /obj/machinery/recycler
	board_type = "machine"
	origin_tech = "{'materials':2}"
	req_components = list(
		/obj/item/stock_parts/manipulator = 4,
		/obj/item/stock_parts/matter_bin = 4,
		/obj/item/stock_parts/scanning_module = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/radio/transmitter/basic/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
	)

///////////////////////
// Recycler
///////////////////////
/obj/machinery/recycler
	name = "recycler"
	desc = "Process trash into raw materials."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "grinder-o0"
	layer = ABOVE_HUMAN_LAYER
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 1 KILOWATTS		//This is vastly lower than it should for gameplay reasons. A 200hp engine running at 25% power would need 37 kW
	active_power_usage = 40 KILOWATTS	//This is vastly lower than it should for gameplay reasons. 200 HP electric motor at 100% efficiency would need 149 kW
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES

	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc/buildable,
		/obj/item/stock_parts/radio/transmitter/basic/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/radio/basic_transmitter/recycler = 1, 
		/decl/stock_part_preset/radio/receiver/recycler = 1,
	)
	public_variables = list(
		/decl/public_access/public_variable/identifier,
		/decl/public_access/public_variable/use_power,
		/decl/public_access/public_variable/reagents,
		/decl/public_access/public_variable/reagents/volumes,
		/decl/public_access/public_variable/reagents/free_space,
		/decl/public_access/public_variable/reagents/total_volume,
		/decl/public_access/public_variable/reagents/maximum_volume,
	)
	public_methods = list(
		/decl/public_access/public_method/toggle_power,
	)

	var/bloodied 				= FALSE		//Whether we show the sprite with blood or not
	var/tmp/grinding			= FALSE 	//Whether we're currently busy grinding something down
	var/tmp/safety_mode 		= 0 		// Temporality stops the machine if it detects a mob
	var/tmp/efficiency 			= 0.5		//Percentage of materials recovered from the recycled item
	var/tmp/timelastoutput 		= 0			//Time when the last sheet was outputed from the machine
	var/const/sound_idle 		= 'sound/machines/creaky_loop.ogg'
	var/const/sound_processing 	= 'sound/machines/machine_wirr.ogg'
	var/const/sound_outputs 	= 'sound/machines/hiss.ogg'
	var/const/sound_reject 		= 'sound/machines/buzz-sigh.ogg'
	var/tmp/soundid 			= "Recyclers"
	var/tmp/datum/sound_token/sound_looping
	var/eat_dir = WEST						//Fixed directio from where the machine will accept trash
	var/list/stored_material = list()		//List of /decl/materials paths and matter unit value to keep track of all the matter that was processed. (upgrade when material states are less fucky)


/obj/machinery/recycler/Initialize()
	. = ..()
	if(!reagents)
		create_reagents(RECYCLER_REAGENTS_VOLUME)

/obj/machinery/recycler/Destroy()
	QDEL_NULL(sound_looping)
	return ..()

/obj/machinery/recycler/examine(mob/user)
	. = ..()
	to_chat(user, "The power light is [(operable() && use_power) ? "on" : "off"].")
	to_chat(user, "The safety-mode light is [safety_mode ? "on" : "off"].")
	to_chat(user, "The safety-sensors status light is [emagged ? "off" : "on"].")

/obj/machinery/recycler/power_change()
	. = ..()
	if(.)
		update_sound()

/obj/machinery/recycler/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	if(!emagged)
		emagged = TRUE
		if(safety_mode)
			safety_mode = FALSE
			update_icon()
		playsound(loc, "sparks", 75, 1, -1)
		to_chat(user, SPAN_NOTICE("You use \the[emag_source] on \the [name]."))

/obj/machinery/recycler/Process()
	if(operable())
		output_materials()

/obj/machinery/recycler/dismantle()
	. = ..()
	output_materials(TRUE)
	reagents.splash(loc, reagents.total_volume)

/obj/machinery/recycler/physically_destroyed(skip_qdel)
	. = ..()
	output_materials(TRUE)
	reagents.splash(loc, reagents.total_volume)

/obj/machinery/recycler/on_update_icon()
	var/active = !(use_power & POWER_USE_OFF) && operable() && !safety_mode
	icon_state = "[RECYCLER_ICON_STATE_BASE_NAME][active][bloodied? "bld" : ""]"

// This is purely for admin possession !FUN!.
/obj/machinery/recycler/Bump(var/atom/movable/AM)
	..()
	if(AM)
		Bumped(AM)

//Handle new throwing system
/obj/machinery/recycler/hitby(atom/movable/AM, datum/thrownthing/TT)
	if(QDELETED(AM))
		return
	if(!can_process_input(AM))
		return ..()
	process_input(AM)

/obj/machinery/recycler/Bumped(atom/movable/AM)
	if(QDELETED(AM))
		return
	if(!can_process_input(AM))
		return ..()
	process_input(AM)

/obj/machinery/recycler/proc/update_sound()
	if(use_power && operable() && !safety_mode)
		if(!sound_looping)
			sound_looping = play_looping_sound(src, soundid, sound_idle, RECYCLER_IDLE_SOUND_VOLUME, 5, 2)
		else
			sound_looping.Unpause()
	else if(sound_looping)
		sound_looping.Pause()

/obj/machinery/recycler/proc/can_process_input(var/atom/movable/AM)
	return get_dir(loc, AM.loc) == eat_dir && use_power && operable() && !safety_mode

/obj/machinery/recycler/proc/can_crush(var/mob/living/L)
	return isliving(L) && L.mob_size <= MOB_SIZE_MEDIUM && (L.is_dead() || emagged) && !is_type_in_list(L, recycler_item_blacklist)

/obj/machinery/recycler/proc/can_recycle(var/atom/movable/AM)
	return isobj(AM) && !AM.anchored && (!is_type_in_list(AM, recycler_item_blacklist))

/obj/machinery/recycler/proc/can_gib(var/mob/living/L)
	return isliving(L) && (L.is_dead() || (emagged && !L.is_dead()))

/obj/machinery/recycler/proc/process_input(atom/movable/AM)
	var/is_atom_living = isliving(AM)
	if(is_atom_living && can_crush(AM))
		recycle_mob(AM)
	else if(!is_atom_living && can_recycle(AM))
		recycle(AM)
	else
		reject_item(AM, is_atom_living)

/obj/machinery/recycler/proc/reject_item(var/atom/movable/AM, var/activate_safety = FALSE)
	playsound(src.loc, 'sound/machines/buzz-sigh.ogg', RECYCLER_FEEDBACK_SOUND_VOLUME, vary=FALSE, extrarange=8, falloff=3)
	AM.forceMove(src.loc)

	if(activate_safety)
		safety_mode = TRUE
		update_icon()
		update_sound()
		addtimer(CALLBACK(src, /obj/machinery/recycler/proc/clear_safety_mode), RECYCLER_SAFETY_COOLDOWN)

/obj/machinery/recycler/proc/clear_safety_mode()
	if(QDELETED(src))
		return
	safety_mode = FALSE
	ping()
	update_icon()
	update_sound()

/obj/machinery/recycler/proc/recycle(var/obj/I, var/sound = TRUE)
	I.forceMove(src.loc)

	//First check for brainmob containers
	if(istype(I, /obj/item/organ/internal/stack)) 
		var/obj/item/organ/internal/stack/ST = I
		if(ST.stackmob)
			return reject_item(ST) //Don't recycle stacks that are inhabited
	if(istype(I, /obj/item/mmi)) 
		var/obj/item/mmi/MMI = I
		if(MMI.brainmob)
			return reject_item(MMI) //Don't recycle mmi that are inhabited
	if(istype(I, /obj/item/organ/internal/posibrain)) 
		var/obj/item/organ/internal/posibrain/posi = I
		if(posi.brainmob)
			return reject_item(posi) //Don't recycle mmi that are inhabited

	//Next handle materials
	if(istype(I, /obj/structure/closet))
		var/obj/structure/closet/thatcloset = I
		if(thatcloset.opened)
			extract_materials(I)  //Opened closets/crates only so we don't need to check for access and stuff
		else 
			reject_item(I)
			return
	else if(istype(I))
		extract_materials(I)

	use_power_oneoff(active_power_usage, power_channel)
	qdel(I)
	if(sound)
		playsound(src.loc, sound_processing, RECYCLER_ACTIVE_SOUND_VOLUME, vary=TRUE, extrarange=8, falloff=3)

/obj/machinery/recycler/proc/extract_reagents(var/obj/thing)
	if(!thing || (thing && !thing.reagents))
		return

	if(thing.reagents.total_volume < 1)
		return //Don't bother if its a tiny quantity
	var/overflow = max(0, (thing.reagents.total_volume + reagents.total_volume) - reagents.maximum_volume)
	thing.reagents.trans_to_obj(src, efficiency * min(thing.reagents.total_volume, reagents.maximum_volume))
	if(overflow && src.loc)
		thing.reagents.splash(src.loc, overflow) //splash around the thing

/obj/machinery/recycler/proc/extract_materials(var/obj/thing, var/depth = 0)
	if(!thing || (thing && !thing.matter) || depth > RECYCLER_MAX_SANE_CONTAINER_DEPTH)
		return

	//First deal with the content recursively
	for(var/subthing in thing.contents)
		extract_materials(subthing, ++depth)
		extract_reagents(subthing)

	//Then recycle the thing itself
	for(var/mat in thing.matter)
		var/decl/material/M = GET_DECL(mat)
		if(!istype(M))
			continue
		stored_material[mat] += efficiency * thing.matter[mat]
	extract_reagents(thing)

/obj/machinery/recycler/proc/recycle_mob(var/mob/living/L)
	use_power_oneoff(active_power_usage, power_channel)
	playsound(src.loc, sound_processing, RECYCLER_ACTIVE_SOUND_VOLUME, vary=TRUE, extrarange=8, falloff=3)
	L.forceMove(src.loc)
	L.adjustBruteLoss(200)

	if(!issilicon(L))
		add_blood(L)
		if(L.can_feel_pain())
			L.apply_effect(WEAKEN, 5)
			L.apply_effect(PAIN,   5)
			L.emote("scream")
		if(!bloodied)
			bloodied = TRUE
			update_icon()
		playsound(src.loc, 'sound/effects/splat.ogg', RECYCLER_FEEDBACK_SOUND_VOLUME, 1)
	else
		playsound(src.loc, 'sound/items/Welder.ogg', RECYCLER_FEEDBACK_SOUND_VOLUME, 1)

	// Recycle some of the worn equipment if alive, and all of it if dead
	var/is_mob_dead = L.is_dead()
	for(var/obj/item/I in L.get_equipped_items())
		if((is_mob_dead || prob(30)) && L.unEquip(I)) 
			recycle(I, FALSE)
	
	//Then handle the gibbing if needed
	if(can_gib(L))
		extract_some_meat(L)
		L.gib()

/obj/machinery/recycler/proc/extract_some_meat(var/mob/living/L)
	if(L.isSynthetic() || !ispath(L.meat_type))
		return
	var/list/meats = atom_info_repository.get_matter_for(L.meat_type)
	if(!meats)
		return
	for(var/path in meats)
		stored_material[path] += round((efficiency * meats[path]) * RECYCLER_MEAT_EFFICIENCY) //Half the yield, since we're not meant to be a butchery machine...
	
	//Might as well pull some fluids out
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/to_extract = round(H.vessel?.total_volume * RECYCLER_BLOOD_EFFICIENCY)
		if(H.vessel && to_extract)
			H.vessel.trans_to_holder(src.reagents, to_extract)
		
		var/datum/reagents/ingested = H.get_ingested_reagents()
		to_extract = round(ingested?.total_volume * RECYCLER_BLOOD_EFFICIENCY)
		if(ingested && to_extract)
			ingested.trans_to_holder(src.reagents, to_extract)
		
		var/datum/reagents/injected = H.get_injected_reagents()
		to_extract = round(injected?.total_volume * RECYCLER_BLOOD_EFFICIENCY)		
		if(injected && to_extract)
			injected.trans_to_holder(src.reagents, to_extract)

/obj/machinery/recycler/proc/output_materials(var/force = FALSE)
	if(!force && (timelastoutput + RECYCLER_OUTPUT_DELAY) > REALTIMEOFDAY) //Wait a bit first
		return
	
	var/list/toremove
	for(var/material_key in stored_material)
		var/decl/material/M = GET_DECL(material_key)
		var/nbstored = stored_material[material_key]

		if(!M || !nbstored)
			LAZYDISTINCTADD(toremove, material_key)
			continue
		
		if(nbstored >= SHEET_MATERIAL_AMOUNT)
			var/nbheets = round(nbstored / SHEET_MATERIAL_AMOUNT)
			stored_material[material_key] -= nbheets * SHEET_MATERIAL_AMOUNT
			M.create_object(get_turf(src), nbheets, /obj/item/stack/material/dust)
			use_power_oneoff(500) //Use some more power to output the stuff
			playsound(src, sound_outputs, RECYCLER_IDLE_SOUND_VOLUME, vary=TRUE, extrarange=8, falloff=3)
			break //Only output one kind of material per call
	
	//Remove empty/invalid entries
	for(var/k in toremove)
		stored_material -= k

	timelastoutput = REALTIMEOFDAY

///////////////////////
// Presets
///////////////////////
/decl/stock_part_preset/radio/basic_transmitter/recycler
	frequency = MACHINE_FREQ
	transmit_on_tick = list(
		"identifier" = /decl/public_access/public_variable/identifier,
		"use_power" = /decl/public_access/public_variable/use_power,
		"reagents" = /decl/public_access/public_variable/reagents,
		"reagents_volumes" = /decl/public_access/public_variable/reagents/volumes,
		"reagents_free_space" = /decl/public_access/public_variable/reagents/free_space,
		"reagents_total_volume" = /decl/public_access/public_variable/reagents/total_volume,
		"reagents_maximum_volume" = /decl/public_access/public_variable/reagents/maximum_volume,
		)

/decl/stock_part_preset/radio/receiver/recycler
	frequency = MACHINE_FREQ
	receive_and_call = list(
		"toggle_power" = /decl/public_access/public_method/toggle_power,
		)

#undef RECYCLER_REAGENTS_VOLUME
#undef RECYCLER_ICON_STATE_BASE_NAME
#undef RECYCLER_MAX_SANE_CONTAINER_DEPTH 
#undef RECYCLER_SAFETY_COOLDOWN
#undef RECYCLER_OUTPUT_DELAY
#undef RECYCLER_IDLE_SOUND_VOLUME
#undef RECYCLER_ACTIVE_SOUND_VOLUME
#undef RECYCLER_FEEDBACK_SOUND_VOLUME
#undef RECYCLER_MEAT_EFFICIENCY 
#undef RECYCLER_BLOOD_EFFICIENCY