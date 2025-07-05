//Force skipping area unit tests over the chargen areas since they're not legal areas.
/datum/map/New()
	. = ..()
	//Don't test these areas, since they have special behaviors
	LAZYDISTINCTADD(area_purity_test_exempt_areas,  /area/chargen)
	LAZYDISTINCTADD(area_usage_test_exempted_areas, /area/chargen)

/**
	An area specialized for initializing a single character.
	Act as an helper to bring all chargen components together in a more concise and simple way.
 */
/area/chargen
	name           = "\improper Colony Pod"
	icon_state     = "crew_quarters"
	requires_power = FALSE
	sound_env      = SMALL_ENCLOSED
	///Static area instance counter for the amount of chargen areas instantiated currently
	var/static/chargen_area_counter = 0
	///A weak reference to the player mob assigned to this area.
	var/tmp/weakref/current_player

/area/chargen/Initialize()
	. = ..()
	name = "[name] #[chargen_area_counter]"
	chargen_area_counter++

///Clear an entire chargen pod from any random trash left by players. (Discarded starter items)
/area/chargen/proc/remove_trash()
	var/junkcounter = 0
	for(var/obj/item/junk in src)
		junkcounter++
		if(!QDELETED(junk))
			qdel(junk)
	log_debug("area/chargen/run_chargen_cleanup(): Cleared [junkcounter] junk item(s) from [src]!")

/// Sets the player mob currently using this chargen area
/area/chargen/proc/set_assigned_player(mob/living/player)
	if(current_player)
		clear_assigned_player()
	if(player)
		//Slap a bunch of events on the player to track if they leave the pod or end up being destroyed before finishing chargen.
		register_player_mob(player)

/// De-assign the currently assigned player to this area.
/area/chargen/proc/clear_assigned_player()
	var/mob/P = current_player?.resolve()
	var/old_state
	if(P)
		old_state = P.mind?.chargen_state //It's fine if the mind is null here. We just need something for the state change.
		unregister_player_mob(P)
	//Force a reset of things listening to us for chargen state changes. (Reset decoration and etc..)
	on_chargen_state_changed(old_state, CHARGEN_STATE_FORM_INCOMPLETE)

///Adds a few events listener to the player, and assign the player to this area.
/area/chargen/proc/register_player_mob(mob/living/player)
	//First, ensure the player is assigned the correct initial chargen state.
	SSchargen.set_player_chargen_state(player, CHARGEN_STATE_FORM_INCOMPLETE)

	//Then set our listeners and etc..
	current_player = weakref(player)
	events_repository.register(/decl/observ/exited,                player, src,         /area/chargen/proc/on_player_left_chargen)
	events_repository.register(/decl/observ/destroyed,             player, src,         /area/chargen/proc/on_player_left_chargen)
	events_repository.register(/decl/observ/logged_out,            player, src,         /area/chargen/proc/on_player_logout)
	events_repository.register(/decl/observ/chargen/state_changed, player.mind, src,    /area/chargen/proc/on_chargen_state_changed)

	RAISE_EVENT(/decl/observ/chargen/player_registered, src, player)

///Removes the events listeners from the player, and clears our currently assigned player.
/area/chargen/proc/unregister_player_mob(mob/living/player)
	events_repository.unregister(/decl/observ/exited,                player, src)
	events_repository.unregister(/decl/observ/destroyed,             player, src)
	events_repository.unregister(/decl/observ/logged_out,            player, src)
	events_repository.unregister(/decl/observ/chargen/state_changed, player.mind, src)

	RAISE_EVENT(/decl/observ/chargen/player_unregistered, src, player)
	current_player = null

///Adds an event listener onto the given `listener`, calling the `proc_call` when the chargen state has changed.
/area/chargen/proc/register_chargen_state_change_listener(datum/listener, proc_call)
	events_repository.register(/decl/observ/chargen/state_changed, src, listener, proc_call)

///Removes an event listener onto the given `listener`, calling the `proc_call` when the chargen state has changed.
/area/chargen/proc/unregister_chargen_state_change_listener(datum/listener, proc_call)
	events_repository.unregister(/decl/observ/chargen/state_changed, src, listener, proc_call)

///Returns the chargen state for the player assigned to the area.
/area/chargen/proc/get_chargen_state()
	var/mob/P = current_player?.resolve()
	return (P?.mind)? P.mind.chargen_state : CHARGEN_STATE_FORM_INCOMPLETE

//
// Events Handlers
//

/**
	Receives callback from the player's mind when the chargen state is changed.
	Essentially a passthrough to all the things listening to us us for changen state changes. (pod, deco, etc..)
 */
/area/chargen/proc/on_chargen_state_changed(datum/mind/M, new_state, old_state)
	if(new_state == old_state)
		return
	//Propagate over to the things in the pod
	RAISE_EVENT(/decl/observ/chargen/state_changed, src, new_state, old_state)

///Callback from player when leaving the chargen pod. Make sure everything is ready for a new player.
/area/chargen/proc/on_player_left_chargen(mob/living/player, atom/new_loc)
	if(get_area(new_loc) == src)
		return
	SSchargen.release_spawn_pod(src)

///Delete the mob if the player logs out inside the chargen area.
/area/chargen/proc/on_player_logout(mob/leaver, client/client)
	//#TODO: This could probably be turned into a proc on the mob.
	leaver.key = null
	leaver.last_ckey = initial(leaver.last_ckey)
	if(!QDELETED(leaver))
		qdel(leaver)
