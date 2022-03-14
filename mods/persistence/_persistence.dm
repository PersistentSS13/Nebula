/decl/modpack/persistence
	name = "Persistence Gamemode Content"

/decl/modpack/persistence/initialize()
	. = ..()
	admin_verbs_admin.Add(/client/proc/save_server)
	admin_verbs_admin.Add(/client/proc/regenerate_mine)
	admin_verbs_admin.Add(/client/proc/database_status)
	admin_verbs_admin.Add(/client/proc/database_reconect)
	admin_verbs_admin.Add(/client/proc/remove_character)
	
	admin_verbs_admin.Remove(/client/proc/admin_call_shuttle)
	admin_verbs_admin.Remove(/client/proc/admin_cancel_shuttle)
	admin_verbs_admin.Remove(/client/proc/check_ai_laws)
	admin_verbs_admin.Remove(/client/proc/rename_silicon)
	admin_verbs_admin.Remove(/client/proc/manage_silicon_laws)
	for(var/client/C in global.admins)
		C.remove_admin_verbs()
		C.add_admin_verbs()