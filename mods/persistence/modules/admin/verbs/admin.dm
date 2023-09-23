/**Admin verbs that will be added to the main admin verb list. */
var/global/list/persistence_admin_verbs = list(
	/client/proc/save_server,
	/client/proc/regenerate_mine,
	/client/proc/database_status,
	/client/proc/database_reconect,
	/client/proc/remove_character,
	/client/proc/lock_server_and_kick_players,
	/client/proc/clear_named_character_from_limbo,
	/client/proc/change_serialization_error_tolerance,
)

/client/proc/save_server()
	set category = "Server"
	set desc="Forces a save of the server."
	set name="Save Server"

	if(!check_rights(R_ADMIN))
		return
	SSautosave.Save(FALSE)

/client/proc/regenerate_mine()
	set category = "Admin"
	set desc="Forces a regeneration of all mines."
	set name="Regenerate Mine"

	if(!check_rights(R_ADMIN))
		return
	SSmining.Regenerate()

/client/proc/remove_character()
	set category = "Server"
	set desc = "Removes any mind with the given ckey from the world, allowing players to respawn in case of bugs."
	set name = "Remove Character"

	if(!check_rights(R_ADMIN))
		return

	var/target_ckey = input("Enter the ckey of the character whom you are removing.", "Character Removal")
	if(!target_ckey)
		return
	for(var/datum/mind/M in global.player_minds)
		if(M.key == target_ckey)
			SSpersistence.RemoveFromLimbo(M.unique_id, LIMBO_MIND, ckey)
			qdel(M)

/client/proc/database_status()
	set category = "Server"
	set desc = "Gives a rundown of the database status"
	set name = "Database Status"

	if(!check_rights(R_ADMIN))
		return
	SSpersistence.PrintDBStatus()

/client/proc/database_reconect()
	set category = "Server"
	set desc = "Force reconnect to the SQL save DB."
	set name = "Database Force Reconnect"

	if(!check_rights(R_ADMIN))
		return
	SQLS_Force_Reconnect()

/client/proc/lock_server_and_kick_players()
	set category = "Server"
	set desc = "Lock entering the server, kick all non-admin players, and prevent them from re-joining"
	set name = "Lock Server and Kick Players"
	if(!check_rights(R_ADMIN))
		return
	if(alert(usr, "This will immediately kick all players to the lobby. Proceed?", "Kick all players and lock the server", "Yes", "No") != "Yes")
		return

	if(global.config.enter_allowed)
		holder.toggleenter()
	else
		to_chat(usr, SPAN_NOTICE("Entering is already disabled."))

	var/nb_kicked = 0
	for(var/datum/mind/M in global.player_minds)
		if(check_rights(R_ADMIN, FALSE, M.current?.get_client()))
			continue
		//Kick them to lobby, unless they already are, or are observing
		if(M.current && istype(M.current, /mob/living))
			var/mob/mindmob = M.current
			var/mob/new_player/P = new
			P.key = mindmob.key
			mindmob.key = null
			nb_kicked++
	message_staff("[key] kicked [nb_kicked] player(s) to the lobby.")

 //////////////////////////////////////////////////////////////////////
// Limbo Character Verbs
//////////////////////////////////////////////////////////////////////

//#FIXME: Try to get all that SQL out of here and call a proc on the serializer directly instead.
/client/proc/clear_named_character_from_limbo()
	set category = "Server"
	set desc = "Force delete from the database the limbo mob for a given character real_name. Meant to be used to clear character names being in-use even if there isn't an active character tied to it."
	set name = "Delete Limbo Character"
	if(!check_rights(R_ADMIN))
		return

	var/choice = alert(usr,
		"USE WITH CAUTION! Will delete the limbo character entry in the database, so the associated name can be used by a new character. THIS WILL PERMENANTLY DELETE ANY CRYOED CHARACTER WITH THE GIVEN NAME IF THERE WAS ANY. Use only in last resort.",
		"Delete named character",
		"Proceed",
		"Cancel")
	if(choice == "Cancel")
		to_chat(usr, SPAN_INFO("Action Aborted"))
		return

	var/char_name  = sanitize_name(input(usr, "Enter character's name:", "Delete Limbo Character") as null|text, MAX_DESC_LEN, TRUE, FALSE)
	if(!length(char_name))
		to_chat(usr, SPAN_INFO("Action Aborted"))
		return
	var/query_text = "FROM `[SQLS_TABLE_LIMBO]` WHERE `metadata2` = '[char_name]'"

	//Setup connection
	var/should_close_connection = !check_save_db_connection()
	establish_save_db_connection()

	//First check what we'll delete
	var/DBQuery/charcheck = dbcon_save.NewQuery("SELECT * [query_text]")
	SQLS_EXECUTE_AND_REPORT_ERROR(charcheck, "USER LOOKING UP LIMBO CHARACTER FAILED:")
	var/list/entries
	var/list/mind_ids
	while(charcheck.NextRow())
		var/list/row = charcheck.GetRowData()
		if(length(row))
			LAZYADD(entries, "name:'[row["metadata2"]]' ckey:'[row["metadata"]]' pid:'[row["p_ids"]]'")
			LAZYADD(mind_ids, row["key"])

	if(!length(entries))
		to_chat(usr, SPAN_WARNING("No matching characters found in the database. Aborting."))
		if(should_close_connection)
			close_save_db_connection()
		return
	to_chat(usr, SPAN_INFO("The command will delete the following:\n[jointext(entries,"\n")]"))

	//Ask again
	choice = alert(usr,
		"Really delete [length(entries)] character\s from the database?",
		"Delete named character",
		"Cancel",
		"Ok")
	if(choice == "Cancel")
		to_chat(usr, SPAN_INFO("Action Aborted"))
		if(should_close_connection)
			close_save_db_connection()
		return

	//Do the deleting
	for(var/mindid in mind_ids)
		SSpersistence.one_off.RemoveFromLimbo(mindid, LIMBO_MIND)

	if(should_close_connection)
		close_save_db_connection()
	to_chat(usr, SPAN_INFO("Successfully deleted all entries for [char_name]!"))

//////////////////////////////////////////////////////////////////////
// Save Error Handling
//////////////////////////////////////////////////////////////////////
#define TOLERANCE_ALL_ERRORS         "Any Errors"
#define TOLERANCE_RECOVERABLE_ERRORS "Recoverable Errors"
#define TOLERANCE_NONE               "None"

///Allow changing error tolerance by admins in order to salvage a save that wouldn't go through because of some localised error.
/client/proc/change_serialization_error_tolerance()
	set category = "Server"
	set desc     = "Allow more or less error tolerance for serializtion errors. Meant to be used as last resort to force the server to save despite runtimes."
	set name     = "Change Save Error Tolerance"
	if(!check_rights(R_ADMIN) || !check_rights(R_SERVER))
		return

	var/previous_tolerance
	//Get current setting, and turn it to a string
	switch(global.SSpersistence.error_tolerance)
		if(PERSISTENCE_ERROR_TOLERANCE_NONE)
			previous_tolerance = TOLERANCE_NONE
		if(PERSISTENCE_ERROR_TOLERANCE_RECOVERABLE)
			previous_tolerance = TOLERANCE_RECOVERABLE_ERRORS
		if(PERSISTENCE_ERROR_TOLERANCE_ANY)
			previous_tolerance = TOLERANCE_ALL_ERRORS
		else
			CRASH("Had bad current save error tolerance value!")

	///Options for the possible error tolerance
	var/static/tolerance_options = list(
		TOLERANCE_ALL_ERRORS,
		TOLERANCE_RECOVERABLE_ERRORS,
		TOLERANCE_NONE,
		"Cancel"
	)
	///Message displayed to users
	var/static/user_message = {"
!! USE WITH CAUTION !! - Ensure there is a BACKUP of the last save first as this could likely cause DATA LOSS, or SAVE CORRUPTION!!
Select what kind of errors will be TOLERATED (A \"Non-recoverable\" error is usually DB queries failing for instance):
"}
	///Show the dialog
	var/choice = input(
		usr,
		user_message,
		"Change Save Error Tolerance",
		previous_tolerance) as anything in tolerance_options

	var/new_tolerance
	switch(choice)
		if(TOLERANCE_ALL_ERRORS)
			new_tolerance = PERSISTENCE_ERROR_TOLERANCE_ANY
		if(TOLERANCE_RECOVERABLE_ERRORS)
			new_tolerance = PERSISTENCE_ERROR_TOLERANCE_RECOVERABLE
		if(TOLERANCE_NONE)
			new_tolerance = PERSISTENCE_ERROR_TOLERANCE_NONE
		else
			to_chat(usr, SPAN_INFO("Save error tolerance unchanged."))
			return

	SSpersistence.SetErrorTolerance(new_tolerance)
	to_chat(usr, SPAN_INFO("Save error tolerance changed to: '[choice]'!"))

#undef TOLERANCE_ALL_ERRORS
#undef TOLERANCE_RECOVERABLE_ERRORS
#undef TOLERANCE_NONE