/datum/wrapper/decl
	wrapper_for = /decl

/datum/wrapper/decl/on_serialize(var/decl/D)
	key = "[D.type]"

/datum/wrapper/decl/on_deserialize()
	return decls_repository.get_decl(text2path(key))