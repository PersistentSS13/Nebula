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

/client/proc/database_status()
	set category = "Server"
	set desc = "Gives a rundown of the database status"
	set name = "Database Status"

	if(!check_rights(R_ADMIN))
		return

	var/DBQuery/query = dbcon.NewQuery("SELECT `id`, `z`, `z_connect` FROM `z_level`")
	query.Execute()

	if(query.ErrorMsg())
		to_chat(usr, "[query.ErrorMsg()]")
		return

	while(query.NextRow())
		to_chat(usr, "Z data: (ID: [query.item[1]], Z: [query.item[2]], Connections: [query.item[3]])")

	query = dbcon.NewQuery("SELECT `TABLE_NAME`, `TABLE_ROWS` FROM information_schema.tables WHERE `TABLE_NAME` IN ('list', 'list_element', 'thing', 'thing_var')")
	query.Execute()

	if(query.ErrorMsg())
		to_chat(usr, "[query.ErrorMsg()]")
		return

	while(query.NextRow())
		to_chat(usr, "Table `[query.item[1]]` Rows: [query.item[2]]")