/mob/new_player
	universal_speak = TRUE

	invisibility = 101

	density = 0
	stat = DEAD

	movement_handlers = list()
	anchored = 1	//  don't get pushed around

	virtual_mob = null // Hear no evil, speak no evil

/mob/new_player/show_lobby_menu(force = FALSE)
	if(!SScharacter_setup.initialized && !force)
		return // Not ready yet.
	var/output = list()
	output += "<div style='text-align:center;'>"
	output += "<i>[global.using_map.get_map_info()]</i>"
	output +="<hr>"
	if(GAME_STATE < RUNLEVEL_GAME)
		//Do not let clients design characters before load. It causes issues, and we don't use rounds anyways.
		output += "<p>Loading...</p>"
	else
		output += "<div style='text-align:center;'>"
		output += "<a href='byond://?src=\ref[src];setupCharacter=1'>Create a new Character</a> "
		output += "<a href='byond://?src=\ref[src];joinGame=1'>Join game</a>"
		output += "</div>"

	output += "<br>"
	output += "<div style='text-align:center;'>"
	if(check_rights(R_DEBUG, 0, client))
		output += "<a href='byond://?src=\ref[src];observeGame=1'>Observe</a>"
	output += "<a href='byond://?src=\ref[src];refreshPanel=1'>Refresh</a>"
	output += "</div>"
	output += "</div>"

	panel = new(src, "Welcome","Welcome to [global.using_map.full_name]", 560, 280, src)
	panel.set_window_options("can_close=0")
	panel.set_content(JOINTEXT(output))
	panel.open()

/mob/new_player/Stat()
	. = ..()

	if(statpanel("Lobby"))
		stat("Players : [global.player_list.len]")

/mob/new_player/Topic(href, href_list) // This is a full override; does not call parent.
	if(usr != src)
		return TOPIC_NOACTION
	if(!client)
		return TOPIC_NOACTION

	if(href_list["setupCharacter"])
		newCharacterPanel()
		return 0

	if(href_list["joinGame"])
		joinGame()
		return 0

	if(href_list["observeGame"])
		transition_to_game()
		var/mob/observer/ghost/observer = new()
		observer.started_as_observer = 1
		var/turf/spawn_turf
		for(var/obj/machinery/cryopod/C in SSmachines.machinery)
			spawn_turf = locate(C.x, C.y, C.z)
		if(!spawn_turf)
			spawn_turf = locate(100,100,1)
		observer.forceMove(spawn_turf)
		observer.ckey = ckey
		qdel(src)
		return

	if(href_list["refreshPanel"])
		panel.close()
		show_lobby_menu()

/mob/new_player/proc/newCharacterPanel()
	for(var/mob/M in SSmobs.mob_list)
		if(M.loc && !istype(M, /mob/new_player) && (M.saved_ckey == ckey || M.saved_ckey == "@[ckey]"))
			to_chat(src, SPAN_NOTICE("You already have a character in game!"))
			return
	if(!check_rights(R_DEBUG))
		client.prefs.real_name = null	// This will force players to set a new character name every time they open character creator
										// Meaning they cant just click finalize as soon as they open the character creator. They are forced to engage.
	client.prefs.open_setup_window(src)
	return

/mob/new_player/proc/joinGame()
	if(GAME_STATE < RUNLEVEL_GAME)
		to_chat(src, SPAN_NOTICE("Wait until the round starts to join."))
		return
	if(!config.enter_allowed)
		to_chat(src, SPAN_NOTICE("There is an administrative lock on entering the game!"))
		return

	if(spawning)
		return
	for(var/datum/mind/target_mind in global.player_minds)   // A mob with a matching saved_ckey is already in the game, put the player back where they were.
		if(cmptext(target_mind.key, key))
			if(!target_mind.current || istype(target_mind.current, /mob/new_player) || QDELETED(target_mind.current))
				continue
			transition_to_game()
			to_chat(src, SPAN_NOTICE("A character is already in game."))
			spawning = TRUE
			target_mind.current.key = key
			qdel(src)
			return
	// Query for the character associated with this ckey
	spawning = TRUE
	var/DBQuery/char_query = dbcon.NewQuery("SELECT `key` FROM `limbo` WHERE `type` = '[LIMBO_MIND]' AND `metadata` = '[ckey]'")
	if(!char_query.Execute())
		to_world_log("CHARACTER DESERIALIZATION FAILED: [char_query.ErrorMsg()].")
	if(char_query.NextRow())
		var/list/char_items = char_query.GetRowData()
		var/list/deserialized = SSpersistence.DeserializeOneOff(char_items["key"], LIMBO_MIND)
		var/datum/mind/target_mind
		for(var/thing in deserialized)
			if(istype(thing, /datum/mind))
				var/datum/mind/check_mind = thing
				if(cmptext(check_mind.key, key))
					target_mind = check_mind
				break
		if(!target_mind)
			to_world_log("CHARACTER DESERIALIZATION FAILED: Could not locate key [char_items["key"]] from limbo list.")
			to_chat(src, SPAN_WARNING("Something has gone wrong while returning you to your body. Contact an admin."))
			spawning = FALSE
			return
		var/mob/person = target_mind.current
		transition_to_game()
		to_chat(src, SPAN_NOTICE("A character is already in game."))
		person.key = key
		qdel(src)
		return
	to_chat(src, SPAN_NOTICE("You have no saved characters. Create a new Character to begin."))
	return

/mob/new_player/Move()
	return 0

/mob/new_player/is_ready()
	return ready && ..()

/mob/new_player/proc/transition_to_game()
	close_spawn_windows()
	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = sound_channels.lobby_channel)) // stops lobby music

/mob/new_player/close_spawn_windows()
	close_browser(src, "window=latechoices") //closes late choices window
	panel.close()
/mob/new_player/proc/AttemptLateSpawnOutreach(var/datum/job/job, var/spawning_at)
	if(src != usr)
		return 0

	if(GAME_STATE != RUNLEVEL_GAME)
		to_chat(usr, "<span class='warning'>The round is either not ready, or has already finished...</span>")
		return 0

	if(!config.enter_allowed)
		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
		return 0

	if(!job || !job.is_available(client))
		alert("[job.title] is not available. Please try another.")
		return 0
	if(job.is_restricted(client.prefs, src))
		return

	var/decl/spawnpoint/spawnpoint = job.get_spawnpoint(client)
	if(!spawnpoint)
		to_chat(src, alert("That spawnpoint is unavailable. Please try another."))
		return 0

	var/turf/spawn_turf = pick(spawnpoint.turfs)
	if(job.latejoin_at_spawnpoints)
		var/obj/S = job.get_roundstart_spawnpoint()
		spawn_turf = get_turf(S)

	if(!SSjobs.check_unsafe_spawn(src, spawn_turf))
		return

	// Just in case someone stole our position while we were waiting for input from alert() proc
	if(!job || !job.is_available(client))
		to_chat(src, alert("[job.title] is not available. Please try another."))
		return 0

	SSjobs.assign_role(src, job.title, 1)

	var/mob/living/character = create_character(spawn_turf)	//creates the human and transfers vars and mind
	if(!character)
		return 0
	if(character.mind)
		SSpersistence.AddToLimbo(character.mind, character.mind.unique_id, LIMBO_MIND, character.mind.key, TRUE)
	character = SSjobs.equip_rank(character, job.title, 1)					//equips the human
	SScustomitems.equip_custom_items(character)

	if(job.do_spawn_special(character, src, TRUE)) //This replaces the AI spawn logic with a proc stub. Refer to silicon.dm for the spawn logic.
		qdel(src)
		return

	SSticker.mode.handle_latejoin(character)
	global.universe.OnPlayerLatejoin(character)
	spawnpoint.after_join(character)
	if(job.create_record)
		if(!(ASSIGNMENT_ROBOT in job.event_categories))
			CreateModularRecord(character)
			SSticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn
			AnnounceArrival(character, job, spawnpoint.msg)
		else
			AnnounceCyborg(character, job, spawnpoint.msg)
	callHook("player_latejoin", list(job, character))
	log_and_message_admins("has joined the round as [character.mind.assigned_role].", character)

	qdel(src)