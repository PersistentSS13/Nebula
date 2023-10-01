#define CHARSELECTLOAD 1
#define CHARSELECTDELETE 2
/mob/new_player
	universal_speak = TRUE

	invisibility = 101

	density = 0
	stat = DEAD

	movement_handlers = list()
	anchored = 1	//  don't get pushed around

	virtual_mob = null // Hear no evil, speak no evil

	var/datum/browser/charselect

	var/list/characters

/mob/new_player/Destroy()
	characters?.Cut()
	. = ..()

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
		output += "<a href='byond://?src=\ref[src];joinGame=1'>Select a Character</a><br><br>"
		output += "<a href='byond://?src=\ref[src];deleteCharacter=1'>Delete a Character</a>"
		output += "</div>"

	output += "<br>"
	output += "<div style='text-align:center;'>"
	if(check_rights(R_DEBUG, FALSE, client))
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

	if(href_list["deleteCharacter"])
		characterSelect(CHARSELECTDELETE)
		return 0
	if(href_list["joinGame"])
		characterSelect(CHARSELECTLOAD)
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

	if(href_list["Load"])
		var/char_index = text2num(href_list["Load"])
		if(!char_index || char_index > length(characters))
			return
		if(charselect)
			charselect.close()
			charselect = null
		joinGame(characters[char_index])

	if(href_list["Delete"])
		var/char_index = text2num(href_list["Delete"])
		if(!char_index || char_index > length(characters))
			return
		if(charselect)
			charselect.close()
			charselect = null

		var/char_name = characters[char_index]
		if(input("Are you SURE you want to delete [char_name]? THIS IS PERMANENT. Enter the character\'s full name to confirm.", "DELETE A CHARACTER", "") == char_name)

			var/new_db_connection = FALSE
			if(!check_save_db_connection())
				if(!establish_save_db_connection())
					CRASH("new_player: Couldn't establish DB connection while deleting a character!")
				new_db_connection = TRUE

			var/DBQuery/char_query = dbcon_save.NewQuery("SELECT `key` FROM `limbo` WHERE `type` = '[LIMBO_MIND]' AND `metadata` = '[sanitize_sql(key)]' AND `metadata2` = '[sanitize_sql(char_name)]'")
			if(!char_query.Execute())
				to_world_log("CHARACTER DESERIALIZATION FAILED: [char_query.ErrorMsg()].")
			if(char_query.NextRow())
				var/list/char_items = char_query.GetRowData()
				var/char_key = char_items["key"]
				SSpersistence.RemoveFromLimbo(char_key, LIMBO_MIND, ckey)
				to_chat(src, SPAN_NOTICE("Character Delete Completed."))
			else
				to_chat(src, SPAN_NOTICE("Delete Failed! Contact a developer."))

			if(new_db_connection)
				close_save_db_connection()

/mob/new_player/proc/newCharacterPanel()
	for(var/mob/M in SSmobs.mob_list)
		if(M.loc && !istype(M, /mob/new_player) && (M.saved_ckey == ckey || M.saved_ckey == "@[ckey]"))
			to_chat(src, SPAN_NOTICE("You already have a character in game!"))
			return

	if(!check_rights(R_DEBUG, FALSE, src))
		client.prefs.real_name = null	// This will force players to set a new character name every time they open character creator
										// Meaning they cant just click finalize as soon as they open the character creator. They are forced to engage.
	client.prefs.open_setup_window(src)
	return

/mob/new_player/proc/characterSelect(var/func = CHARSELECTLOAD)
	if(!config.enter_allowed && !check_rights(R_ADMIN, FALSE, src))
		to_chat(src, SPAN_WARNING("There is an administrative lock on entering the game!"))
		return
	if(func == CHARSELECTLOAD)
		for(var/datum/mind/target_mind in global.player_minds)   // A mob with a matching saved_ckey is already in the game, put the player back where they were.
			if(cmptext(target_mind.key, key))
				if(!target_mind.current || istype(target_mind.current, /mob/new_player) || QDELETED(target_mind.current))
					continue
				transition_to_game()
				to_chat(src, SPAN_NOTICE("A character is already in game."))
				spawning = TRUE
				target_mind.current.key = key
				target_mind.current.on_persistent_join()
				qdel(src)
				return

	characters = list()

	var/func_text = "Load"
	if(func == CHARSELECTDELETE)
		func_text = "Delete"
	var/slots = 2
	if(check_rights(R_DEBUG, FALSE, src) || check_rights(R_ADMIN, FALSE, src))
		slots+=2
	var/output = list()
	output += "<div style='text-align:center;'>"
	output += "Select a character to [func_text].<br><br>"

	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("new_player: Couldn't establish DB connection while selecting a character!")
		new_db_connection = TRUE

	var/DBQuery/char_query = dbcon_save.NewQuery("SELECT `metadata2` FROM `limbo` WHERE `type` = '[LIMBO_MIND]' AND `metadata` = '[sanitize_sql(key)]'")
	if(!char_query.Execute())
		to_world_log("CHARACTER DESERIALIZATION FAILED: [char_query.ErrorMsg()].")
	for(var/i=1, i<=slots, i++)
		if(char_query.NextRow())
			var/list/char_items = char_query.GetRowData()
			var/char_name = char_items["metadata2"]
			if(char_name)
				characters += char_name
				output += "<a href='byond://?src=\ref[src];[func_text]=[length(characters)]'>[char_name]</a><br>"
		else
			output += "*Open Slot*<br>"
	output += "</div>"
	charselect = new(src, "[func_text]","[func_text] a character.", 280, 300, src)
	charselect.set_content(JOINTEXT(output))
	charselect.open()

	if(new_db_connection)
		close_save_db_connection()

/mob/new_player/proc/joinGame(selected_char_name)
	if(GAME_STATE < RUNLEVEL_GAME)
		to_chat(src, SPAN_NOTICE("Wait until the round starts to join."))
		return
	if(!config.enter_allowed && !check_rights(R_ADMIN, FALSE, src))
		to_chat(src, SPAN_WARNING("There is an administrative lock on entering the game!"))
		return
	if(spawning)
		to_chat(src, SPAN_NOTICE("Already set to spawning."))
		return

	for(var/datum/mind/target_mind in global.player_minds)   // A mob with a matching saved_ckey is already in the game, put the player back where they were.
		if(cmptext(target_mind.key, key))
			if(!target_mind.current || istype(target_mind.current, /mob/new_player) || QDELETED(target_mind.current))
				continue
			transition_to_game()
			to_chat(src, SPAN_NOTICE("A character is already in game."))
			spawning = TRUE
			target_mind.current.key = key
			target_mind.current.on_persistent_join()
			qdel(src)
			return
	// Query for the character associated with this ckey
	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("new_player: Couldn't establish DB connection while joining as character!")
		new_db_connection = TRUE

	spawning = TRUE
	var/DBQuery/char_query = dbcon_save.NewQuery("SELECT `key` FROM `limbo` WHERE `type` = '[LIMBO_MIND]' AND `metadata` = '[sanitize_sql(key)]' AND `metadata2` = '[sanitize_sql(selected_char_name)]'")
	if(!char_query.Execute())
		to_world_log("CHARACTER DESERIALIZATION FAILED: [char_query.ErrorMsg()].")
	if(char_query.NextRow())
		var/list/char_items = char_query.GetRowData()
		var/list/deserialized = SSpersistence.LoadFromLimbo(char_items["key"], LIMBO_MIND)
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

			if(new_db_connection)
				close_save_db_connection()

			return
		var/mob/person = target_mind.current
		transition_to_game()
		person.key = key
		person.on_persistent_join()
		qdel(src)

		if(new_db_connection)
			close_save_db_connection()
		return
	to_chat(src, SPAN_NOTICE("Load Failed! Contact a developer."))
	message_staff("'[key]''s character '[selected_char_name]' failed to load on character select!")
	spawning = FALSE

	if(new_db_connection)
		close_save_db_connection()
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