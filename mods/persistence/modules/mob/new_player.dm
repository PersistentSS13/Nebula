#define CHARSELECTLOAD 1
#define CHARSELECTDELETE 2
/mob/new_player
	universal_speak = TRUE

	invisibility = 101

	density = FALSE
	stat = DEAD

	movement_handlers = list()
	anchored = TRUE	//  don't get pushed around

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
//	output += "<i>[global.using_map.get_map_info()]</i>"

	var/slots = 2
	if(check_rights(R_DEBUG) || check_rights(R_ADMIN))
		slots+=2
	output += "<div style='width:575px;max-width:575px;border-width:2px;border-style:solid;border-color:black;display:flex;text-align:center;'>"
	for(var/i= 1 to slots)
		var/state
		output += "<div style='width:150px;max-width:150px;border-width:2px;border-style:solid;border-color:black;'>"
		if(!establish_save_db_connection())
			CRASH("Couldn't connect realname duplication check")
		var/DBQuery/query = dbcon_save.NewQuery("SELECT `RealName`, `CharacterID`, `status` FROM `[SQLS_TABLE_CHARACTERS]` WHERE `ckey` = '[sanitize_sql(key)]' AND `slot` = [i] ORDER BY `CharacterID` DESC LIMIT 1;")
		SQLS_EXECUTE_AND_REPORT_ERROR(query, "Character Slot load failed")
		var/sub_output = ""
		var/ico = "0"
		send_rsc(src, icon('icons/mob/hologram.dmi', "Question"), "[0].png")
		send_rsc(src, icon('icons/obj/Cryogenic2.dmi', "body_scanner_0"), "[1].png")

		if(query.NextRow())
			var/realname = query.item[1]
			var/characterid = query.item[2]
			state = query.item[3]
			sub_output += "<b>[realname]</b><br><hr>"
			switch(text2num(state))
				if(SQLS_CHAR_STATUS_CRYO) // cryo
					ico =  "1"
					sub_output += "<a href='byond://?src=\ref[src];joinGame=[characterid]'>Select</a>"
					sub_output += "<a href='byond://?src=\ref[src];deleteCharacter=[characterid];realname=[realname]'>Delete</a>"
				if(SQLS_CHAR_STATUS_WORLD) // world
					for(var/datum/mind/target_mind in global.player_minds)   // A mob with a matching saved_ckey is already in the game, put the player back where they were.
						if(target_mind.unique_id == characterid)
							if(!target_mind.current || istype(target_mind.current, /mob/new_player) || QDELETED(target_mind.current))
								continue
							transition_to_game()
							to_chat(src, SPAN_NOTICE("A character is already in game."))
							spawning = TRUE
							target_mind.current.key = key
							target_mind.current.on_persistent_join()
							qdel(src)
							return
					ico =  "1"
					sub_output += "<a href='byond://?src=\ref[src];joinGame=[characterid];status=[state]'>Select</a>"
					sub_output += "<a href='byond://?src=\ref[src];deleteCharacter=[characterid];realname=[realname]'>Delete</a>"
				if(SQLS_CHAR_STATUS_FIRST) // first
					ico =  "1"
					sub_output += "<a href='byond://?src=\ref[src];joinGame=[characterid];status=[state]'>Select</a>"
					sub_output += "<a href='byond://?src=\ref[src];deleteCharacter=[characterid];realname=[realname]'>Delete</a>"
				if(SQLS_CHAR_STATUS_DELETED) // deleted
					ico =  "1"
					sub_output += "<a href='byond://?src=\ref[src];setupCharacter=[i]'>Create</a>"

		else // empty character slot.
			sub_output += "<b>Open Slot #[i]</b><br><hr>"
			sub_output += "<a href='byond://?src=\ref[src];setupCharacter=[i]'>Create</a><br>"
		output += "<img style='width:100px;height:100px;'src=\"[ico].png\"><br>"
		output += sub_output

		output += "</div>"
	output +="</div><hr>"

	if(GAME_STATE < RUNLEVEL_GAME)
		//Do not let clients design characters before load. It causes issues, and we don't use rounds anyways.
		output += "<p>Loading...</p>"
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
		newCharacterPanel(href_list["setupCharacter"])
		return 0

	if(href_list["deleteCharacter"])
		if(input("Are you SURE you want to delete [href_list["realname"]]? THIS IS PERMANENT. Enter the character\'s full name to confirm.", "DELETE A CHARACTER", "") == href_list["realname"])
			SSpersistence.AcceptDeath(href_list["deleteCharacter"], sanitize_sql(key))
			panel.close()
			show_lobby_menu()
		return 0
	if(href_list["joinGame"])
		joinGamePersistent(href_list["joinGame"], href_list["status"])

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
//		joinGame(characters[char_index])

	if(href_list["Delete"])
		var/char_index = text2num(href_list["Delete"])
		if(!char_index || char_index > length(characters))
			return
		if(charselect)
			charselect.close()
			charselect = null

		var/char_name = characters[char_index]
		if(input("Are you SURE you want to delete [char_name]? THIS IS PERMANENT. Enter the character\'s full name to confirm.", "DELETE A CHARACTER", "") == char_name)
			return ":)"

/mob/new_player/proc/newCharacterPanel(var/slot)
	if(!check_rights(R_DEBUG, FALSE, src))
		client.prefs.real_name = null	// This will force players to set a new character name every time they open character creator
										// Meaning they cant just click finalize as soon as they open the character creator. They are forced to engage.
	client.prefs.creation_slot = slot
	client.prefs.open_setup_window(src)
	return

/mob/new_player/proc/joinGamePersistent(var/c_id, var/status)
	if(GAME_STATE < RUNLEVEL_GAME)
		to_chat(src, SPAN_NOTICE("Wait until the round starts to join."))
		return
	if(!config.enter_allowed && !check_rights(R_ADMIN, FALSE, src))
		to_chat(src, SPAN_WARNING("There is an administrative lock on entering the game!"))
		return
	if(spawning)
		to_chat(src, SPAN_NOTICE("Already set to spawning."))
		return

	var/mob/person = SSpersistence.LoadCharacter(c_id)
	switch(text2num(status))
		if(SQLS_CHAR_STATUS_CRYO)
			person.LateInitialize()
		if(SQLS_CHAR_STATUS_FIRST)
			var/datum/job/job = SSjobs.get_by_path(global.using_map.default_job_type)
			var/decl/spawnpoint/spawnpoint = job.get_spawnpoint(client)
			var/turf/spawn_turf
			spawn_turf = SAFEPICK(spawnpoint.get_spawn_turfs(person))
			if(!spawn_turf && istype(person, /mob/living/carbon/human))
				person.LateInitialize()
			else
				person.loc = spawn_turf
				spawnpoint.after_join(person)
				person.LateInitialize()
		if(SQLS_CHAR_STATUS_WORLD)
			person.LateInitialize()
		else
			person.LateInitialize()
	transition_to_game()
	person.key = key
	person.on_persistent_join()

	qdel(src)

	spawning = FALSE
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