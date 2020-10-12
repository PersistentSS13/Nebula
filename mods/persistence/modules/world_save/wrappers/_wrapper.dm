/datum/wrapper
	var/key
	var/wrapper_for

// called after object is deserialized while in the serializer. Return a reference to the game data key is pointing to.
/datum/wrapper/proc/on_deserialize()

// called during serialization for custom behaviour. Assign var/key with something that can be used to restore the game data on_deserialize(). Return nothing.
/datum/wrapper/proc/on_serialize(var/datum/object)