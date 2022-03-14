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
	output += "<div align='center'>"
	if(GAME_STATE < RUNLEVEL_GAME)
		output += "<span class='average'><b>The Game Is Loading!</b></span><br><br>"
	output += "<i>[global.using_map.get_map_info()]</i>"
	output +="<hr>"
	if(GAME_STATE < RUNLEVEL_GAME)
		//Do not let clients design characters before load. It causes issues, and we don't use rounds anyways.
		output += "<div>Loading...</div>"
	else
		output += "<a href='byond://?src=\ref[src];setupCharacter=1'>Set up character</a> "
		output += "<a href='byond://?src=\ref[src];joinGame=1'>Join game</a>"

	output += "<br><br>"
	if(check_rights(R_DEBUG, 0, client))
		output += "<a href='byond://?src=\ref[src];observeGame=1'>Observe</a><br><br>"
	output += "<a href='byond://?src=\ref[src];refreshPanel=1'>Refresh</a><br><br>"
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
			if(!target_mind.current || istype(target_mind.current, /mob/new_player))
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

	switch(alert("Are you sure you want to join the game with the character you've created? This cannot be undone!", "Character Confirmation", "Yes", "No"))
		if("No")
			return

	create_character()	// Creating a new character based off the player's preferences.
	qdel(src)

/mob/new_player/create_character()
	spawning = TRUE
	transition_to_game()
	var/turf/spawn_turf

	var/used_chargen = FALSE
	if(chargen_spawns && length(chargen_spawns))
		spawn_turf = SSchargen.get_spawn_turf()
		used_chargen = TRUE
	else
		for(var/turf/T in global.latejoin_cryo_locations)
			if(locate(/mob) in T)
				continue
			spawn_turf = T

	var/mob/living/carbon/human/new_character
	var/decl/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]

	if(chosen_species)
		if(!check_species_allowed(chosen_species))
			spawning = FALSE //abort
			return null
		new_character = new(spawn_turf, chosen_species.name)
		if(chosen_species.has_organ[BP_POSIBRAIN] && client && client.prefs.is_shackled)
			var/obj/item/organ/internal/posibrain/B = new_character.internal_organs_by_name[BP_POSIBRAIN]
			if(B)	B.shackle(client.prefs.get_lawset())

	if(!new_character)
		new_character = new(spawn_turf)
		if(used_chargen)
			SSchargen.assign_spawn_pod(new_character, spawn_turf)

	new_character.lastarea = get_area(spawn_turf)
	client.prefs.copy_to(new_character)

	if(mind)
		mind.active = 0 //we wish to transfer the key manually
		mind.original = new_character
		var/memory = client.prefs.records[PREF_MEM_RECORD]
		mind.StoreMemory(memory)
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	var/datum/job/job = SSjobs.get_by_path(/datum/job/colonist) // Hacky way to get players equipped with a basic uniform and their accounts set up.
	job.setup_account(new_character)
	job.equip(new_character)

	var/datum/skillset/SS = new_character.skillset 	// Populate the skill_list of the player's skillset so that they can be properly adjusted during gameplay.
	SS.set_skillset_min()
	
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()
	
	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_eyes()
	new_character.refresh_visible_overlays()

	new_character.key = key		//Manually transfer the key to log them in

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
