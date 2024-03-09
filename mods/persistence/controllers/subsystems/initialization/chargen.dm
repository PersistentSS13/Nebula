var/global/list/chargen_areas = list() //List of pod areas, and a number of times assigned was called on a given area for debugging purpose
var/global/list/chargen_landmarks = list() //List of all the chargen landmarks available for spawn.
#define MAX_NB_CHAR_GEN_PODS 20

/queue
	var/list/elements = list()

/queue/proc/get_length()
	return length(elements)

/queue/proc/push(element)
	elements.Insert(1, element)

/queue/proc/pop()
	var/queue_len = length(elements)
	if(!queue_len)
		return
	. = elements[queue_len]
	elements.len--

/queue/proc/peek()
	var/queue_len = length(elements)
	if(queue_len)
		return elements[queue_len]

/**
	System for managing the character generator for new players.
	* Handles assigning chargen rooms.
	* Handles moving players after completing chargen into the world.
 */
SUBSYSTEM_DEF(chargen)
	name = "Chargen"
	init_order = SS_INIT_MAPPING

	///The level id of the level data being used as chargen level
	var/chargen_level_id
	///A queue of players currently awaiting spawning in the world after concluding chargen.
	var/queue/world_spawn_queue = new()

/datum/controller/subsystem/chargen/fire(resumed)
	//Checks our list of players awaiting a chargen room if any.
	var/datum/queued_chargen_world_spawn/queued
	while((queued = world_spawn_queue.peek()))
		queued.spawn_attempts++
		//Grab the player awaiting spawn
		var/mob/living/player = queued.player.resolve()
		if(!player || try_spawn_player_in_world(player, queued.spawn_provider))
			qdel(world_spawn_queue.pop())
		else
			//Put the player at the end of the queue for now
			world_spawn_queue.push(world_spawn_queue.pop())
			//Tell the staff if a player has been stuck in the queue for a really long time.
			if(queued.spawn_attempts == 300)
				var/msg = "SSChargen: Player [player] ([player.ckey]) couldn't find a spawn point after [queued.spawn_attempts] attempts, and being queued for [(world.time - queued.time_queued) / (1 SECOND)] seconds!"
				log_warning(msg)
				message_staff(msg)
				to_chat(player, SPAN_WARNING("Finding a spawn point is taking unusually long. Please contact the staff."))
		CHECK_TICK

/**
	Returns a turf to spawn limbo observers on.
	#TODO: Move this somewhere that makes sense?
 */
/datum/controller/subsystem/chargen/proc/get_limbo_turf()
	var/datum/level_data/LD = SSmapping.levels_by_id[chargen_level_id]
	if(LD)
		return WORLD_CENTER_TURF(LD.level_z)

/**
	Sets the level_data id for the chargen level. This allows us to lookup the chargen level in the mapping ss without worrying about z indices.
 */
/datum/controller/subsystem/chargen/proc/set_chargen_level_id(level_id)
	chargen_level_id = level_id

/**
	Marks a chargen room as being occupied by the given player. Prevents assigning a room to multiple players at once.
 */
/datum/controller/subsystem/chargen/proc/assign_spawn_pod(area/chargen/pod, mob/living/player)
	if(is_chargen_room_busy(pod))
		log_warning("Chargen pod '[pod]' had more than one player assigned to it!")
	chargen_areas[pod] += 1
	//Let the area register some callbacks to track the player
	pod.set_assigned_player(player)
	log_debug("SSChargen: Assigned area '[pod]' with '[chargen_areas[pod]]' assigned users currently to '[player]'([player.ckey])!")

/**
	Marks a chargen room as being free for re-use by another player.
 */
/datum/controller/subsystem/chargen/proc/release_spawn_pod(var/area/chargen/pod)
	chargen_areas[pod] -= 1
	//Let the area remove it's callbacks and run cleanup
	pod.clear_assigned_player()
	//Clean the place up from any trash someone might have left in there
	pod.remove_trash()
	log_debug("SSChargen: Unassaigned area '[pod]' with '[chargen_areas[pod]]' assigned users currently!")

/**
	Returns true if the chargen room is already occupied by a player currently.
 */
/datum/controller/subsystem/chargen/proc/is_chargen_room_busy(area/chargen/room)
	return room && (chargen_areas[room] >= 1)

/**
	Ran after completing chargen. To finish equipping a player
 */
/datum/controller/subsystem/chargen/proc/finish_equiping_player(mob/living/player_mob)
	var/datum/mind/player_mind = player_mob.mind
	player_mind.finalize_chargen_setup()

	if(player_mind.should_spawn_with_stack())
		var/obj/item/organ/internal/stack/new_stack = new()
		player_mob.add_organ(new_stack, player_mob.get_organ(new_stack.parent_organ))
		to_chat(player_mob, SPAN_NOTICE("You have been provided with a Cortical Stack to act as an emergency revival tool."))

	var/obj/starter_book = player_mind.get_starter_book_type()
	if(starter_book)
		to_chat(player_mob, SPAN_NOTICE("You have brought with you a textbook related to your specialty. It can increase your skills temporarily by reading it, or permanently through dedicated study. It's highly valuable, so don't lose it!"))
		player_mob.equip_to_slot_or_store_or_drop(new starter_book(player_mob), slot_in_backpack_str)

/**
	Gives us a player to spawn in the world after completing chargen.
 */
/datum/controller/subsystem/chargen/proc/queue_player_world_spawn(mob/living/player_mob, decl/spawnpoint/provider)
	log_debug("SSChargen: Player [player_mob] has been queued for world spawn.")
	world_spawn_queue.push(new /datum/queued_chargen_world_spawn(player_mob, provider))

/**
	Try to have the spawnpoint spawn a player in the world.
 */
/datum/controller/subsystem/chargen/proc/try_spawn_player_in_world(mob/living/player_mob, decl/spawnpoint/provider)
	return provider.try_spawn(player_mob)
	// //Check if we have an available spawn turf
	// var/atom/spawnloc = provider.pick_spawn_turf(player_mob)
	// if(!spawnloc)
	// 	return FALSE //No turfs available
	// //If we got a turf, move us there. The callbacks set on the player should handle properly reseting the chargen room.
	// player_mob.forceMove(spawnloc)
	// //Run the spawn point post-spawn stuff
	// provider.after_join(player_mob)
	//return TRUE

// Chargen Accessors

/datum/controller/subsystem/chargen/proc/set_player_chargen_origin(mob/living/player, origin_id)
	player.mind.set_chargen_origin(origin_id)

/datum/controller/subsystem/chargen/proc/set_player_chargen_role(mob/living/player, role_id)
	player.mind.set_chargen_role(role_id)

/datum/controller/subsystem/chargen/proc/set_player_chargen_state(mob/living/player, chargen_state)
	player.mind.set_player_chargen_state(chargen_state)

/datum/controller/subsystem/chargen/proc/validate_chargen_form_submission(mob/living/player)
	if(isnull(player.mind.origin))
		to_chat(player, SPAN_NOTICE("Application incomplete. Please enter an origin to proceed."))
		return
	if(isnull(player.mind.role))
		to_chat(player, SPAN_NOTICE("Application incomplete. Please enter a role to proceed."))
		return
	return TRUE

///////////////////////////////////////////////////////////////////////////
// Queued Spawn Entry
///////////////////////////////////////////////////////////////////////////

///Data on a player awauting spawning in the world
/datum/queued_chargen_world_spawn
	var/weakref/player
	var/decl/spawnpoint/spawn_provider
	var/spawn_attempts = 0
	var/time_queued

/datum/queued_chargen_world_spawn/New(mob/living/_player_mob, decl/spawnpoint/_provider)
	player         = weakref(_player_mob)
	spawn_provider = _provider
	time_queued    = world.time

/datum/queued_chargen_world_spawn/Destroy(force)
	player = null
	spawn_provider = null
	. = ..()

