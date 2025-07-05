/datum/wrapper/weakref
	wrapper_for = /weakref

/datum/wrapper/weakref/on_serialize(var/weakref/W, var/serializer/curr_serializer)
	var/datum/thing = W.resolve()
	if(thing)
		key = thing

/datum/wrapper/weakref/on_deserialize(var/serializer/curr_serializer)
	if(key)
		return weakref(key)
	return null
