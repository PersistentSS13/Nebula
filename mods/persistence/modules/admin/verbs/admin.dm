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

	var/DBQuery/query = dbcon.NewQuery("SELECT `id`, `z`, `dynamic`, `default_turf` FROM `z_level`")
	query.Execute()

	if(query.ErrorMsg())
		to_chat(usr, "Error: [query.ErrorMsg()]")

	if(!query.RowCount())
		to_chat(usr, "No Z data...")

	while(query.NextRow())
		to_chat(usr, "Z data: (ID: [query.item[1]], Z: [query.item[2]], Dynamic: [query.item[3]], Default Turf: [query.item[4]])")

	query = dbcon.NewQuery("ANALYZE TABLE `list`, `list_element`, `thing`, `thing_var`;")
	query.Execute()
	
	if(query.ErrorMsg())
		to_chat(usr, "Error: [query.ErrorMsg()]")

	query = dbcon.NewQuery("SELECT `TABLE_NAME`, `TABLE_ROWS` FROM information_schema.tables WHERE `TABLE_NAME` IN ('list_element', 'thing', 'thing_var')")
	query.Execute()

	if(query.ErrorMsg())
		to_chat(usr, "Error: [query.ErrorMsg()]")
		return

	while(query.NextRow())
		to_chat(usr, "Table `[query.item[1]]` Rows: [query.item[2]]")