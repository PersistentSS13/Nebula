/decl/modpack/persistence
	name = "Persistence Gamemode Content"

/decl/modpack/persistence/initialize()
	. = ..()
	admin_verbs_admin.Add(global.persistence_admin_verbs)

	admin_verbs_admin.Remove(/client/proc/admin_call_shuttle)
	admin_verbs_admin.Remove(/client/proc/admin_cancel_shuttle)
	admin_verbs_admin.Remove(/client/proc/check_ai_laws)
	admin_verbs_admin.Remove(/client/proc/rename_silicon)
	admin_verbs_admin.Remove(/client/proc/manage_silicon_laws)
	admin_verbs_admin.Remove(/client/proc/empty_ai_core_toggle_latejoin)

	admin_verbs_fun.Remove(/client/proc/cmd_admin_add_freeform_ai_law)
	admin_verbs_fun.Remove(/client/proc/cmd_admin_add_random_ai_law)
	admin_verbs_fun.Remove(/datum/admins/proc/ai_hologram_set)

	admin_verbs_server.Remove(/datum/admins/proc/toggleAI)
	
	for(var/client/C in global.admins)
		C.remove_admin_verbs()
		C.add_admin_verbs()