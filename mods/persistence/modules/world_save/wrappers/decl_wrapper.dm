/datum/wrapper/decl
	wrapper_for = /decl

/datum/wrapper/decl/on_serialize(var/decl/D)
	key = "[D.type]"

/datum/wrapper/decl/on_deserialize()
	return GET_DECL(text2path(key))