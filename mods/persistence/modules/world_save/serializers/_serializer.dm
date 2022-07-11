#define IS_PROC(X) (findtext("\ref[X]", "0x26"))

/serializer
	var/datum/persistence/load_cache/resolver/resolver = new()

	var/list/thing_map = list()
	var/list/reverse_map = list()
	var/list/list_map = list()
	var/list/reverse_list_map = list()

	var/list/z_map = list() // This map lists key (game's z_index) to the zindex used by the database (value).
	var/z_index = -1
	var/nongreedy_serialize = TRUE // Only serialize objects whitelist by z_map.

	var/list/wrappers // Wrappers used for encapsulating more complex serialized objects.

/serializer/New()
	discover_wrappers()

/serializer/proc/discover_wrappers()
	wrappers = list()
	for(var/W in subtypesof(/datum/wrapper))
		var/datum/wrapper/Wd = W
		if(!initial(Wd.wrapper_for))
			continue
		wrappers[initial(Wd.wrapper_for)] = W

/serializer/proc/get_wrapper(var/D)
	for(var/wrapper_type in wrappers)	
		if(istype(D, wrapper_type))
			return wrappers[wrapper_type]

// Serializes an object. Returns the appropriate serialized form of the object. What's outputted depends on the serializer.
// object: A thing to serialize.
// object_parent: That object's parent. Could be a container or other. Optional.
// z: The z_level of this object. Also optional. Used for reordering z_levels in the world save
/serializer/proc/Serialize(var/object, var/object_parent, var/z)
	if(islist(object))
		return SerializeList(object, object_parent)
	return SerializeDatum(object, object_parent)

// Serialize an object datum. Returns the appropriate serialized form of the object. What's outputted depends on the serializer.
/serializer/proc/SerializeDatum(var/datum/object, var/object_parent)

// Serialize a list. Returns the appropriate serialized form of the list. What's outputted depends on the serializer.
/serializer/proc/SerializeList(var/list/list, var/list_parent)

/serializer/proc/DeserializeDatum(var/datum/persistence/load_cache/thing/object)

/serializer/proc/DeserializeList(var/raw_list)

/serializer/proc/QueryAndDeserializeDatum(var/object_id, var/reference_only = FALSE)
	var/datum/existing = reverse_map["[object_id]"] 
	if(!isnull(existing))
		return existing
	// We check to see if this is a reference only var so that if things are missing from the resolver, this doesn't fail silently.
	if(reference_only && !resolver.things["[object_id]"])
		return null
	if(!istype(resolver.things["[object_id]"], /datum/persistence/load_cache/thing))
		to_world_log("serializer/QueryAndDeserializeDatum(): Got a reference to a thing with a bad type. ([object_id])")
		return null
	return DeserializeDatum(resolver.things["[object_id]"])

/serializer/proc/QueryAndDeserializeList(var/list_id)
	var/list/existing = reverse_list_map["[list_id]"]
	if(!isnull(existing))
		return existing
	var/list/result = DeserializeList(resolver.lists["[list_id]"])
	reverse_list_map["[list_id]"] = result
	return result

/serializer/proc/should_flatten(var/datum/object)
	if(isnull(object))
		return FALSE
	var/decl/saved_variables/SV = get_saved_decl(object.type)
	return (SV?.should_flatten)

/serializer/proc/Clear()
	z_index = -1
	thing_map.Cut(1)
	reverse_map.Cut(1)
	list_map.Cut(1)
	reverse_list_map.Cut(1)

/serializer/proc/save_exists()
	return FALSE

/serializer/proc/save_z_level_remaps()
	return FALSE

/serializer/proc/save_area_chunks()
	return FALSE

/serializer/proc/_before_serialize()
	return
/serializer/proc/_before_deserialize()
	return

/serializer/proc/_after_serialize()
	return
/serializer/proc/_after_deserialize()
	return

/serializer/proc/count_saved_datums()
	return 