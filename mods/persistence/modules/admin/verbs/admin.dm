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