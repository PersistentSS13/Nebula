/datum/wrapper/weakref
	wrapper_for = /weakref

/datum/wrapper/weakref/on_serialize(var/weakref/W)
	var/serializer/S = SSpersistence.serializer
	key = S.SerializeDatum(W.resolve()) // Returns the thing ID if the referenced object is serialized, or serializes it if not.

/datum/wrapper/weakref/on_deserialize()
	var/serializer/S = SSpersistence.serializer
	var/datum/thing = S.QueryAndDeserializeDatum(key)
	var/weakref/ref = weakref(thing)
	return ref
