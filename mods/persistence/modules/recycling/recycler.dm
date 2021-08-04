#define RECYCLER_REAGENTS_VOLUME 2000
#define RECYCLER_ICON_STATE_BASE_NAME "grinder-o"
// #define RECYCLER_INPUT_DIR dir
// #define RECYCLER_OUTPUT_DIR turn(dir, 180)
#define RECYCLER_MAX_SANE_CONTAINER_DEPTH 50 //Used to prevent ending up with an infinite recursion when adding up contained items
#define RECYCLER_SAFETY_COOLDOWN 10 SECONDS
#define RECYCLER_OUTPUT_DELAY 5 SECONDS //intervals between material being outputed by the machine

var/global/list/recycler_item_blacklist = list(
		/obj/item/projectile, //not meant to be a portable shield
		/obj/effect,
	)

/obj/item/stock_parts/circuitboard/gibber
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

/obj/machinery/recycler
	name = "recycler"
	desc = "Process trash into raw materials."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "grinder-o0"
	layer = ABOVE_HUMAN_LAYER
	density = TRUE
	anchored = TRUE

	use_power = POWER_USE_IDLE
	idle_power_usage = 10 KILOWATTS		//This is vastly lower than it should for gameplay reasons. A 200hp engine running at 25% power would need 37 kW
	active_power_usage = 40 KILOWATTS	//This is vastly lower than it should for gameplay reasons. 200 HP electric motor at 100% efficiency would need 149 kW
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES

	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc/buildable,
		/obj/item/stock_parts/radio/transmitter/basic/buildable,
		/obj/item/stock_parts/radio/receiver/buildable,
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/basic_transmitter/recycler = 1)
	public_variables = list(
		/decl/public_access/public_variable/identifier,
		/decl/public_access/public_variable/use_power,
		/decl/public_access/public_variable/reagents,
		/decl/public_access/public_variable/reagents/volumes,
		/decl/public_access/public_variable/reagents/free_space,
		/decl/public_access/public_variable/reagents/total_volume,
		/decl/public_access/public_variable/reagents/maximum_volume,
	)
	public_methods = list(/decl/public_access/public_method/toggle_power)

	var/bloodied 				= FALSE		//Whether we show the sprite with blood or not
	var/tmp/grinding			= FALSE 	//Whether we're currently busy grinding something down
	var/tmp/safety_mode 		= 0 		// Temporality stops the machine if it detects a mob
	var/tmp/efficiency 			= 0.5		//Percentage of materials recovered from the recycled item
	var/tmp/timelastoutput 		= 0
	var/const/sound_idle 		= 'sound/machines/creaky_loop.ogg'
	var/const/sound_processing 	= 'sound/machines/machine_wirr.ogg'
	var/const/sound_outputs 	= 'sound/machines/hiss.ogg'
	var/const/sound_reject 		= 'sound/machines/buzz-sigh.ogg'
	var/const/soundid 			= "Recyclers"
	var/tmp/datum/sound_token/sound_looping
	var/list/stored_material = list()
	var/eat_dir = WEST


/obj/machinery/recycler/Initialize()
	. = ..()
	if(!reagents)
		create_reagents(RECYCLER_REAGENTS_VOLUME)

/obj/machinery/recycler/Destroy()
	dump_materials()
	QDEL_NULL(sound_looping)
	return ..()

/obj/machinery/recycler/examine(mob/user)
	. = ..()
	to_chat(user, "The power light is [(stat & NOPOWER) ? "off" : "on"].")
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

// This is purely for admin possession !FUN!.
/obj/machinery/recycler/Bump(var/atom/movable/AM)
	..()
	if(AM)
		Bumped(AM)

/obj/machinery/recycler/Bumped(var/atom/movable/AM)
	if(QDELETED(AM))
		return
	if(get_dir(loc, AM.loc) != eat_dir || use_power & POWER_USE_OFF || \
		inoperable() || safety_mode || !istype(AM))
		return ..()

	use_power_oneoff(active_power_usage, power_channel)
	if(isliving(AM))
		if(can_crush(AM))
			eat(AM)
		else
			stop(AM)
	else 
		if(can_recycle(AM))
			recycle(AM)
		else
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			AM.dropInto(src.loc)


/obj/machinery/recycler/on_update_icon()
	var/active = !(use_power & POWER_USE_OFF) && operable() && !safety_mode
	icon_state = "[RECYCLER_ICON_STATE_BASE_NAME][active][bloodied? "bld" : ""]"

//
/obj/machinery/recycler/proc/update_sound()
	if(use_power && operable() && !safety_mode)
		if(!sound_looping)
			sound_looping = play_looping_sound(src, soundid, sound_idle, 25, 5, 2)
		else
			sound_looping.Unpause()
	else if(sound_looping)
		sound_looping.Pause()

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

/obj/machinery/recycler/proc/can_crush(var/mob/living/L)
	return isliving(L) && L.mob_size <= MOB_SIZE_MEDIUM && (L.is_dead() || emagged) && !is_type_in_list(L, recycler_item_blacklist)

/obj/machinery/recycler/proc/can_recycle(var/atom/movable/AM)
	return istype(AM) && !AM.anchored && (!is_type_in_list(AM, recycler_item_blacklist))

/obj/machinery/recycler/proc/can_gib(var/atom/movable/AM)
	return isanimal(AM) || issilicon(AM) ||\
		istype(AM, /mob/living/bot) ||\
		istype(AM, /mob/living/carbon/human/monkey)

/obj/machinery/recycler/proc/recycle(var/obj/I, var/sound = 1)
	I.loc = src.loc
	if(istype(I, /obj/item/organ/internal/stack)) //Don't eat laces
		return

	if(istype(I, /obj/item))
		extract_materials(I)
	else if(istype(I, /obj/structure/closet) && !I.anchored) //Opened closets/crates
		var/obj/structure/closet/thatcloset = I
		if(thatcloset.opened)
			extract_materials(I)
	else if(istype(I, /obj/structure) && !I.anchored) //loose structures, etc..
		extract_materials(I)
	else if(istype(I, /obj/machinery) && !I.anchored) //loose machines
		extract_materials(I)
	else if(istype(I,/obj/effect/decal) && !I.anchored) //Wreckages/junk
		extract_materials(I)
	else
		return //Nothing for us

	qdel(I)
	if(sound)
		playsound(src.loc, sound_processing, 30, vary=TRUE, extrarange=8, falloff=3)
	output_materials()

/obj/machinery/recycler/proc/stop(var/mob/living/L)
	playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 40, vary=FALSE, extrarange=8, falloff=3)
	safety_mode = 1
	update_icon()
	L.loc = src.loc

	spawn(RECYCLER_SAFETY_COOLDOWN)
		ping()
		//playsound(src.loc, 'sound/machines/ping.ogg', 30, vary=FALSE, extrarange=8, falloff=3)
		safety_mode = 0
		update_icon()
		update_sound()

/obj/machinery/recycler/proc/eat(var/mob/living/L)
	L.loc = src.loc
	var/gib = can_gib(L)

	if(!issilicon(L))
		add_blood(L)
		L.emote("scream")
		if(!bloodied)
			bloodied = TRUE
			update_icon()
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
	else
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
	playsound(src.loc, sound_processing, 30, vary=TRUE, extrarange=8, falloff=3)

	L.apply_effect(WEAKEN, 5)
	L.adjustBruteLoss(200)

	// Remove and recycle the equipped items.
	for(var/obj/item/I in L.get_equipped_items())
		if(L.unEquip(I))
			recycle(I, 0)
	if(gib)
		L.gib()
		if(!issilicon(L))
			stored_material[/decl/material/solid/meat] += L.getMaxHealth() * 2 //Generate a bit of goop from the health of the mob
	output_materials()

/obj/machinery/recycler/proc/output_materials()
	if((timelastoutput + RECYCLER_OUTPUT_DELAY) > world.time) //Wait a bit first
		return
	for(var/material_key in stored_material)
		var/decl/material/M = GET_DECL(material_key)
		var/nbstored = stored_material[material_key]
		if(!M || !nbstored)
			continue
		if(nbstored >= SHEET_MATERIAL_AMOUNT)
			var/nbheets = round(nbstored / SHEET_MATERIAL_AMOUNT)
			stored_material[material_key] -= nbheets * SHEET_MATERIAL_AMOUNT
			M.create_object(get_turf(src), nbheets, /obj/item/stack/material/dust)
			use_power_oneoff(500) //Use some more power to output the stuff
			playsound(src, sound_outputs, 30, vary=TRUE, extrarange=8, falloff=3)
			break //Only output one kind of material per call

	timelastoutput = world.time

//Dump out all contained materials and reagents
/obj/machinery/recycler/proc/dump_materials()
	for(var/material_key in stored_material)
		var/decl/material/M = GET_DECL(material_key)
		var/nbstored = stored_material[material_key]
		if(!M || !nbstored)
			continue
		//OUTPUT TO DUST


//Preset 
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
// #undef RECYCLER_INPUT_DIR
// #undef RECYCLER_OUTPUT_DIR
#undef RECYCLER_MAX_SANE_CONTAINER_DEPTH
#undef RECYCLER_SAFETY_COOLDOWN
#undef RECYCLER_OUTPUT_DELAY