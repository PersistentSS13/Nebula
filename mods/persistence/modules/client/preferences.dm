/datum/preferences

	var/datum/browser/charpanel
	var/list/skipped_menus = list(/datum/category_group/player_setup_category/record_preferences, /datum/category_group/player_setup_category/occupation_preferences, /datum/category_group/player_setup_category/appearance_preferences, /datum/category_group/player_setup_category/law_pref)

/datum/preferences/get_content(mob/user)

	if(!user || !user.client)
		return

	if(!get_mob_by_key(client_ckey))
		to_chat(user, "<span class='danger'>No mob exists for the given client!</span>")
		close_load_dialog(user)
		return

	if(!char_render_holders)
		update_preview_icon()
	show_character_previews()

	var/dat = list("<center>")
	if(is_guest)
		dat += SPAN_WARNING("Please create an account to save your preferences. If you have an account and are seeing this, please adminhelp for assistance.")
	else if(load_failed)
		dat += SPAN_DANGER("Loading your savefile failed: [load_failed]<br>Please adminhelp for assistance.")
	else
		dat += "<c><a href='?src=\ref[src];finish=1'>Finalize Character</a></c><br>"
		dat += "<b>Preview</b> - "
		dat += "<a href='?src=\ref[src];cycle_bg=1'>Cycle background</a> - "
		dat += "<a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_LOADOUT]'>[equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Hide loadout" : "Show loadout"]</a> - "
		dat += "<a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_JOB]'>[equip_preview_mob & EQUIP_PREVIEW_JOB ? "Hide job gear" : "Show job gear"]</a>"

	dat += "<br>"
	dat += player_setup.header()
	dat += "<br><HR></center>"
	dat += player_setup.content(user)
	return JOINTEXT(dat)

/datum/preferences/open_setup_window(mob/user)

	if(!SScharacter_setup.initialized)
		return

	winshow(user, "preferences_window", TRUE)
	var/datum/browser/popup = new(user, "preferences_browser", "Character Setup", 800, 800)
	var/content = {"
	<script type='text/javascript'>
		function update_content(data){
			document.getElementById('content').innerHTML = data
		}
	</script>
	<html><body>
		<div id='content'>[get_content(user)]</div>
	</body></html>
	"}
	popup.set_content(content)
	popup.open(FALSE) // Skip registring onclose on the browser panel
	charpanel = popup
	onclose(user, "preferences_window", src) // We want to register on the window itself

/datum/preferences/Topic(href, list/href_list)
	if(..())
		return TRUE
	if(href_list["finish"])
		if(!real_name)
			to_chat(usr, "<span class='danger'>The must set a unique character name to continue.</span>")
			return
		save_preferences()
		save_character()
		switch(alert("Are you sure you want to finalize your character and join the game with the character you've created?", "Character Confirmation", "Yes", "No"))
			if("No")
				return
		if(isnewplayer(client.mob))
			var/mob/new_player/M = client.mob
			M.AttemptLateSpawn(SSjobs.get_by_path(global.using_map.default_job_type))
			close_char_dialog(usr)

	if(href_list["save"])
		save_preferences()
		save_character()
	else if(href_list["reload"])
		load_preferences()
		load_character()
		sanitize_preferences()
	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			open_load_dialog(usr)
			return TRUE
	else if(href_list["changeslot"])
		load_character(text2num(href_list["changeslot"]))
		sanitize_preferences()
		close_load_dialog(usr)

		if(isnewplayer(client.mob))
			var/mob/new_player/M = client.mob
			M.show_lobby_menu()

	else if(href_list["resetslot"])
		if(real_name != input("This will reset the current slot. Enter the character's full name to confirm."))
			return FALSE
		load_character(SAVE_RESET)
		sanitize_preferences()
	else if(href_list["close"])
		// User closed preferences window, cleanup anything we need to.
		clear_character_previews()
		return TRUE
	else if(href_list["toggle_preview_value"])
		equip_preview_mob ^= text2num(href_list["toggle_preview_value"])
	else if(href_list["cycle_bg"])
		bgstate = next_in_list(bgstate, bgstate_options)
	else
		return FALSE

	update_preview_icon()
	update_setup_window(usr)
	return 1


/datum/preferences/proc/close_char_dialog(mob/user)
	if(panel)
		panel.close()
		panel = null
	if(charpanel)
		charpanel.close()
		charpanel = null
	close_browser(user, "window=preferences_window")