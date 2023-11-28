// Wrapper for objects that need to be created post-atoms Init.
// This doesn't actually support replacing references to whatever was wrapped, so the
// wrapped object will need to do this manually in some way, if necessary.

/datum/wrapper/late

/datum/wrapper/late/on_deserialize(var/serializer/curr_serializer)
	SSpersistence.late_wrappers |= src
	return null

/datum/wrapper/late/proc/on_late_load()
