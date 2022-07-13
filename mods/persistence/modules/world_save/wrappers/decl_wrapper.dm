/datum/wrapper/decl
	wrapper_for = /decl

/datum/wrapper/decl/on_serialize(var/decl/D, var/serializer/curr_serializer)
	key = "[D.type]"

/datum/wrapper/decl/on_deserialize(var/serializer/curr_serializer)
	return GET_DECL(text2path(key))