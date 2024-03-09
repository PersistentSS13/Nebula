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
	name = "\improper Colony Pod"
	icon_state = "crew_quarters"
	requires_power = FALSE
	sound_env = SMALL_ENCLOSED
	///Static area instance counter for the amount of chargen areas instantiated currently
	var/static/chargen_area_counter = 0
	///The spawn landmark for the current chargen area.
	var/tmp/obj/abstract/landmark/chargen_spawn/chargen_landmark
	///The current chargen completion state.
	var/tmp/current_chargen_state = CHARGEN_STATE_FORM_INCOMPLETE
	///Reference to the console that updates the chargen state.
	var/tmp/obj/structure/fake_computer/chargen/chargen_console
	///A weak reference to the player mob assigned to this area.
	var/tmp/weakref/current_player

/area/chargen/Initialize()
	. = ..()
	name = "[name] #[chargen_area_counter]"
	chargen_area_counter++

/area/chargen/Destroy()
	chargen_landmark = null
	. = ..()

///Clear an entire chargen pod from any random trash left
/area/chargen/proc/remove_trash()
	var/junkcounter = 0
	for(var/obj/item/junk in src)
		junkcounter++
		if(!QDELETED(junk))
			qdel(junk)
	log_debug("area/chargen/run_chargen_cleanup(): Cleared [junkcounter] junk item(s) from [src]!")

/area/chargen/proc/register_chargen_console(obj/structure/fake_computer/chargen/C)
	chargen_console = C
	events_repository.register(/decl/observ/chargen_state_changed, C, src, /area/chargen/proc/set_chargen_state)

/area/chargen/proc/unregister_chargen_console(obj/structure/fake_computer/chargen/C)
	events_repository.unregister(/decl/observ/chargen_state_changed, C, src)
	chargen_console = null

/// Sets the player mob currently using this chargen area
/area/chargen/proc/set_assigned_player(mob/living/player)
	if(current_player)
		var/mob/P = current_player.resolve()
		clear_assigned_player(P)
	if(player)
		//Slap a bunch of events on the player to track if they leave the pod or end up being destroyed before finishing chargen.
		register_player_mob(player)
		//Make the chargen form for the assigned player
		chargen_console.set_form(new /datum/nano_module/chargen(chargen_console, null, player, src))

/area/chargen/proc/clear_assigned_player()
	var/mob/P = current_player?.resolve()
	if(P)
		unregister_player_mob(P)
	chargen_console.set_form(null)
	//!!- After unregistering events on the player it's safe to reset the state -!!
	set_chargen_state(CHARGEN_STATE_FORM_INCOMPLETE)

/area/chargen/proc/register_player_mob(mob/living/player)
	current_player = weakref(player)
	events_repository.register(/decl/observ/exited,                player, src,         /area/chargen/proc/on_player_left_chargen)
	events_repository.register(/decl/observ/destroyed,             player, src,         /area/chargen/proc/on_player_left_chargen)
	events_repository.register(/decl/observ/chargen_state_changed, src,    player.mind, /datum/mind/proc/set_player_chargen_state)

/area/chargen/proc/unregister_player_mob(mob/living/player)
	events_repository.unregister(/decl/observ/exited,                player, src)
	events_repository.unregister(/decl/observ/destroyed,             player, src)
	events_repository.unregister(/decl/observ/chargen_state_changed, src,    player.mind)
	current_player = null

/area/chargen/proc/register_chargen_state_change_listener(datum/listener, proc_call)
	events_repository.register(/decl/observ/chargen_state_changed, src, listener, proc_call)

/area/chargen/proc/unregister_chargen_state_change_listener(datum/listener, proc_call)
	events_repository.unregister(/decl/observ/chargen_state_changed, src, listener, proc_call)

/area/chargen/proc/get_chargen_state()
	return current_chargen_state

/area/chargen/proc/set_chargen_state(new_state)
	var/old_state = current_chargen_state
	if(new_state == old_state)
		return
	current_chargen_state = new_state
	RAISE_EVENT(/decl/observ/chargen_state_changed, src, new_state, old_state)

///Callback from player when leaving the chargen pod
/area/chargen/proc/on_player_left_chargen(mob/living/player, atom/new_loc)
	if(get_area(new_loc) == src)
		return
	SSchargen.release_spawn_pod(src)
