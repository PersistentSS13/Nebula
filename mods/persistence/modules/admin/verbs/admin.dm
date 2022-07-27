/**Admin verbs that will be added to the main admin verb list. */
var/global/list/persistence_admin_verbs = list(
	/client/proc/save_server,
	/client/proc/regenerate_mine,
	/client/proc/database_status,
	/client/proc/database_reconect,
	/client/proc/remove_character,
	/client/proc/lock_server_and_kick_players,
)

/client/proc/save_server()
	set category = "Server"
	set desc="Forces a save of the server."
	set name="Save Server"

	if(!check_rights(R_ADMIN))
		return
	SSautosave.Save()

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
			SSpersistence.RemoveFromLimbo(M.unique_id, LIMBO_MIND)
			qdel(M)

/client/proc/database_status()
	set category = "Server"
	set desc = "Gives a rundown of the database status"
	set name = "Database Status"

	if(!check_rights(R_ADMIN))
		return
	SSpersistence.print_db_status()

/client/proc/database_reconect()
	set category = "Server"
	set desc = "Force reconnect to the SQL save DB."
	set name = "Database Force Reconnect"

	if(!check_rights(R_ADMIN))
		return
	SQLS_Force_Reconnect()
	
//////////////////////////////////////////////////////////////////////
// Limbo Character Verbs
//////////////////////////////////////////////////////////////////////
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

	if(global.config.rejoin_allowed)
		holder.togglerejoin()
	else
		to_chat(usr, SPAN_NOTICE("Re-joining is already disabled."))

	var/nb_kicked = 0
	for(var/datum/mind/M in global.player_minds)
		if(check_rights(R_ADMIN, TRUE, M.get_client()))
			continue
		//Kick them to lobby, unless they already are, or are observing
		if(M.current && istype(M.current, /mob/living))
			var/mob/mindmob = M.current
			var/mob/new_player/P = new
			P.key = mindmob.key
			mindmob.key = null
			nb_kicked++
	message_staff("[key] kicked [nb_kicked] player(s) to the lobby.")
