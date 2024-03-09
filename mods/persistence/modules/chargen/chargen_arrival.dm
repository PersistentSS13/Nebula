
////////////////////////////////////////////////////////////////////////
// New Player Teleporter
////////////////////////////////////////////////////////////////////////

/**
	Temporary object meant to simulate a cryopod dumping new players out before being deleted.
 */
/obj/effect/dummy_pod
	name          = "cryopod"
	icon          = 'icons/obj/Cryogenic2.dmi'
	icon_state    = "body_scanner_0"
	density       = TRUE
	anchored      = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	layer         = ABOVE_HUMAN_LAYER
	var/icon_state_open = "body_scanner_1"
	var/is_open         = FALSE
	var/mob/living/occupant

/obj/effect/dummy_pod/Initialize(mapload)
	. = ..()
	global.set_floating_anim(src)

/obj/effect/dummy_pod/Destroy()
	global.unset_floating_anim(src)
	//Make sure nothing stays stuck in
	if(occupant)
		dump_occupant(FALSE)
	else
		dump_contents()
	return ..()

/obj/effect/dummy_pod/proc/set_occupant(mob/living/L)
	if(occupant)
		dump_occupant()
	occupant = L
	L.forceMove(src)
	if(occupant.client)
		occupant.client.perspective = EYE_PERSPECTIVE
		occupant.client.eye = src

/obj/effect/dummy_pod/proc/dump_occupant(throwout = TRUE)
	if(!occupant)
		return
	occupant.dropInto(get_turf(src))
	if(occupant.client)
		occupant.client.eye = src.occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE

	//open and close the thing for a second
	open_canopy()
	addtimer(CALLBACK(src, /obj/effect/dummy_pod/proc/close_canopy), 2 SECONDS)

	//Send them flying a tiny bit
	if(throwout)
		occupant.throw_at(global.get_edge_target_turf(src, dir), rand(1,3), 1, src, TRUE)
		for(var/obj/O in get_contained_external_atoms())
			if(O.simulated)
				O.throw_at(global.get_edge_target_turf(src, dir), rand(1,4), 3, src, TRUE)
	else
		dump_contents()
	occupant = null

/obj/effect/dummy_pod/proc/open_canopy()
	is_open    = TRUE
	icon_state = icon_state_open
	playsound(src, 'sound/machines/podopen.ogg', 40)


/obj/effect/dummy_pod/proc/close_canopy()
	is_open    = FALSE
	icon_state = initial(icon_state)
	playsound(src, 'sound/machines/podclose.ogg', 40)

/**
	This is a single use machine that simulates teleporting the cryopod from the chargen pod and opening it.

 */
/obj/machinery/arrival_spawner
	name = "deep sleep extraction device"
	desc = "This machine is meant to extract sleepy space traveller from their long cryosleep with minimal side effects, and without needing any cumbersome docking infrastructure."
	icon = 'mods/persistence/icons/obj/machines/player_spawner.dmi'
	icon_state = "tele0"
	stat_immune = NOSCREEN | NOINPUT | EMPED | MAINT | BROKEN | NOPOWER
	uncreated_component_parts = null
	maximum_component_parts = null
	interact_offline = TRUE
	base_type = /obj/machinery/arrival_spawner

	///The player mob currently being spawned if any
	var/tmp/mob/living/spawning_player
	///The dummy pod for the player currently being spawned.
	var/tmp/obj/effect/dummy_pod/spawning_pod

	var/teleport_in_icon   = "tele1"
	var/teleport_busy_icon = "tele2"
	var/teleport_out_icon  = "tele3"

	///Whether the machine should show the busy sprite or not
	var/tmp/show_busy_icon = FALSE

/obj/machinery/arrival_spawner/Initialize(mapload, d, populate_parts)
	global.get_or_create_extension(src, /datum/extension/spawn_position/chargen_arrival)
	. = ..()

/obj/machinery/arrival_spawner/proc/is_ready_for_player()
	return !spawning_player && !spawning_pod

/obj/machinery/arrival_spawner/proc/spawn_player(mob/living/newbie)
	set waitfor = FALSE //For animations

	//Mark ourselves are currently spawning a player
	spawning_player = newbie

	//Make a little animation to simulate the player pod moving onto the pad
	animate_spawn_dummy_pod()

	//Have the pod open up and dump the player out
	animate_dump_player()

	//Wait a second and have the pod violently disintegrated
	animate_disintegrate_pod()

	//Set us as ready for another player to spawn.
	. = spawning_player
	spawning_player = null

///Creates a dummy pod the players will "come out" of.
/obj/machinery/arrival_spawner/proc/animate_spawn_dummy_pod()
	spawning_pod = new(get_turf(src))
	spawning_pod.set_occupant(spawning_player)
	spawning_pod.forceMove(get_turf(src))
	spawning_pod.set_dir(dir)
	//Make sure the busy state is set
	show_busy_icon = TRUE
	update_icon()
	//Do sparkless and stufff
	flick(teleport_in_icon, src)
	sleep(1 SECONDS) //lasts 17 deciseconds

/obj/machinery/arrival_spawner/proc/animate_dump_player()
	spawning_pod.dump_occupant(TRUE)
	sleep(2 SECONDS)

/obj/machinery/arrival_spawner/proc/animate_disintegrate_pod()
	QDEL_NULL(spawning_pod)
	//Make sure the busy state is cleared
	show_busy_icon = FALSE
	update_icon()
	//sparklessss!
	flick(teleport_out_icon, src)
	sleep(3 SECONDS) //lasts 32 deciseconds

/obj/machinery/arrival_spawner/on_update_icon()
	. = ..()
	if(show_busy_icon)
		icon_state = teleport_busy_icon
	else
		icon_state = initial(icon_state)

/////////////////////////////////////////////////////////////////
// Spawn Position
/////////////////////////////////////////////////////////////////

/**
	Spawn position for players arriving through chargen completion.
 */
/datum/extension/spawn_position/chargen_arrival
	name          = "arrival"
	provider      = /decl/spawnpoint/arrival_chargen
	expected_type = /obj/machinery/arrival_spawner

/datum/extension/spawn_position/chargen_arrival/is_busy()
	var/obj/machinery/arrival_spawner/M = holder
	if(!holder)
		CRASH("Bad holder type")
	return !M.is_ready_for_player()

/datum/extension/spawn_position/chargen_arrival/place(mob/living/to_spawn)
	var/obj/machinery/arrival_spawner/M = holder
	if(!holder)
		CRASH("Bad holder type")


	// Store any held or equipped items.
	var/obj/item/storage/backpack/pack = to_spawn.get_equipped_item(slot_back_str)
	if(istype(pack))
		for(var/atom/movable/thing in to_spawn.get_held_items())
			to_spawn.drop_from_inventory(thing)
			pack.handle_item_insertion(thing)

	//Put them in the machine
	M.spawn_player(to_spawn)

/////////////////////////////////////////////////////////////////
// Spawn Point Provider
/////////////////////////////////////////////////////////////////

/**
	Secondary spawn point for characters that completed chargen
 */
/decl/spawnpoint/arrival_chargen
	uid          = "spawn_chargen_arrival"
	name         = "outreach bound pod"
	spawn_flags  = SPAWN_FLAG_JOBS_CAN_SPAWN
	restrict_job = /datum/job/colonist

/decl/spawnpoint/arrival_chargen/after_join(mob/living/carbon/human/victim)
	SET_STATUS_MAX(victim, STAT_ASLEEP, rand(1,2))
	to_chat(victim, SPAN_NOTICE("You've waken up from the cryostasis."))
	return TRUE
