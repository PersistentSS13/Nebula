/datum/wrapper/weakref
	wrapper_for = /weakref

/datum/wrapper/weakref/on_serialize(var/weakref/W, var/serializer/curr_serializer)
	key = curr_serializer.SerializeDatum(W.resolve(), src) // Returns the thing ID if the referenced object is serialized, or serializes it if not.

/datum/wrapper/weakref/on_deserialize(var/serializer/curr_serializer)
	var/datum/thing = curr_serializer.QueryAndDeserializeDatum(key)
	var/weakref/ref = weakref(thing)
	return ref
