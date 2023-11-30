/serializer/json
	var/serializer/sql/sql

/serializer/json/New(var/serializer/sql/sql_serializer)
	sql = sql_serializer
	wrappers = sql_serializer.wrappers


// For JSON serialized objects, object_parent is a list containing all objects that have already been serialized for the current branch
// of a flatttened object. This prevents infinite loops.
/serializer/json/Serialize(var/object, var/list/object_parent)
	if(islist(object))
		return SerializeList(object, object_parent)
	return SerializeDatum(object, object_parent)

// Serialize an object datum. Returns the appropriate serialized form of the object.
// JSON flattened objects are *always* serialized, even if they have been serialized elsewhere. However, only one copy is deserialized.
/serializer/json/SerializeDatum(var/datum/object, var/list/object_parent)
	if(!object.should_save())
		return
	var/list/results = list()
	object.before_save()
	if(!object.persistent_id)
		object.persistent_id = PERSISTENT_ID

	// This list collects every datum which has been serialized along one "branch" of the flattened object's variables.
	// Datums should only be serialized once per "branch" to prevent infinite loops.
	if(object_parent && !islist(object_parent))
		object_parent = list(object_parent)
	object_parent = object_parent ? object_parent | list(object) : list(object)
	for(var/V in get_saved_variables_for(object.type))
		if(!issaved(object.vars[V]))
			continue
		var/VV = object.vars[V]
		if(VV == initial(object.vars[V]))
			continue
		if(islist(VV))
			results[V] = SerializeList(VV, object_parent)
		else if(ispath(VV))
			results[V] = "[SERIALIZER_TYPE_PATH]#[VV]"
		else if(istext(VV) || isnum(VV) || isnull(VV))
			results[V] = VV
		else if(istype(VV, /decl))
			var/decl/VD = VV
			results[V] = "[SERIALIZER_TYPE_DECL]#[VD.type]"
		else if(istype(VV, /datum))
			if(should_flatten(VV))
				if(VV in object_parent)
					var/datum/VD = VV
					results[V] = "[SERIALIZER_TYPE_FLAT_REF]#[VD.persistent_id]"
				else
					results[V] = "[SERIALIZER_TYPE_DATUM_FLAT]#[SerializeDatum(VV, object_parent)]"
			else if(get_wrapper(VV))
				var/wrapper_path = get_wrapper(VV)
				var/datum/wrapper/GD = new wrapper_path
				if(!GD)
					// Missing wrapper!
					continue
				GD.on_serialize(VV, src)
				if(!GD.key)
					// Wrapper is null.
					continue
				results[V] = "[SERIALIZER_TYPE_WRAPPER]#[SerializeDatum(GD, object_parent)]"
			else
				var/datum/VD = VV
				if(V in global.reference_only_vars)
					if(VD.persistent_id)
						results[V] = "[SERIALIZER_TYPE_DATUM]#[VD.persistent_id]"
				else
					// We don't pass object_parent here because the SQL serializer has a seperate method to handle objects
					// that have already been serialized.
					results[V] = "[SERIALIZER_TYPE_DATUM]#[sql.SerializeDatum(VV)]"

	object.after_save()

	return "[object.type]|[json_encode(results)]"

// Serialize a list. Returns the appropriate serialized form of the list. What's outputted depends on the serializer.
// list_parent is a list for this serializer, passed from object_parent. See above.
/serializer/json/SerializeList(var/list/_list, var/list/list_parent)
	var/list/final_list = list()
	for(var/K in _list)
		var/F_K // Final key
		var/F_V // Final value

		// Serialize the key.
		if(islist(K))
			F_K = SerializeList(K, list_parent)
		else if(istext(K) || isnum(K) || isnull(K))
			F_K = K
		else if(istype(K, /decl))
			var/decl/KD = K
			F_K = "[SERIALIZER_TYPE_DECL]#[KD.type]"
		else if(ispath(K))
			F_K = "[SERIALIZER_TYPE_PATH]#[K]"
		else if(istype(K, /datum))
			if(should_flatten(K))
				if(K in list_parent)
					var/datum/KD = K
					F_K = "[SERIALIZER_TYPE_FLAT_REF]#[KD.persistent_id]"
				else
					F_K = "[SERIALIZER_TYPE_DATUM_FLAT]#[SerializeDatum(K, list_parent)]"
			else if(get_wrapper(K))
				var/wrapper_path = get_wrapper(K)
				var/datum/wrapper/GD = new wrapper_path
				if(!GD)
					continue
				GD.on_serialize(K, src)
				if(!GD.key)
					continue
				F_K = "[SERIALIZER_TYPE_WRAPPER]#[SerializeDatum(GD, list_parent)]"
			else
				// list_parent is intentionally not passed. See ./SerializeDatum
				F_K = "[SERIALIZER_TYPE_DATUM]#[sql.SerializeDatum(K)]"

		// All byond lists are dicts. Check if this KVP is a dict. or a null type ref.
		try
			var/V = _list[K] // Type value?
			// There was a type value.
			if(islist(V))
				F_V = SerializeList(V)
			else if(ispath(V))
				F_V = "[SERIALIZER_TYPE_PATH]#[V]"
			else if(istext(V) || isnum(V) || isnull(V))
				F_V = V
			else if(istype(V, /decl))
				var/decl/VD = V
				F_V = "[SERIALIZER_TYPE_DECL]#[VD.type]"
			else if(istype(V, /datum))
				if(should_flatten(V))
					if(V in list_parent)
						var/datum/VD = V
						F_V = "[SERIALIZER_TYPE_FLAT_REF]#[VD.persistent_id]"
					else
						F_V = "[SERIALIZER_TYPE_DATUM_FLAT]#[SerializeDatum(V, list_parent)]"
				else if(get_wrapper(V))
					var/wrapper_path = get_wrapper(V)
					var/datum/wrapper/GD = new wrapper_path
					if(!GD)
						continue
					GD.on_serialize(V, src)
					if(!GD.key)
						continue
					F_V = "[SERIALIZER_TYPE_WRAPPER]#[SerializeDatum(GD, list_parent)]"
				else
					// See above.
					F_V = "[SERIALIZER_TYPE_DATUM]#[sql.SerializeDatum(V)]"

			// Add the list value.
			final_list[F_K] = F_V
		catch
			// It's just a list element. No type value.
			final_list.Add(F_K)
	return final_list

/serializer/json/DeserializeDatum(var/datum/persistence/load_cache/thing/object)
	throw EXCEPTION("Do not use DeserializeDatum for the JSON Serializer. Use QueryAndDeserializeDatum.")

/serializer/json/proc/JsonDeserializeDatum(var/datum/thing, var/list/thing_vars)
	for(var/V in thing_vars)
		var/encoded_value = thing_vars[V]
		if(istext(encoded_value))
			if(findtext(encoded_value, "[SERIALIZER_TYPE_DATUM]#", 1, 5))
				// This is an object reference.
				thing.vars[V] = sql.QueryAndDeserializeDatum(copytext(encoded_value, 5))
				continue
			if(findtext(encoded_value, "[SERIALIZER_TYPE_PATH]#", 1, 6))
				thing.vars[V] = text2path(copytext(encoded_value, 6))
				continue
			if(findtext(encoded_value, "[SERIALIZER_TYPE_DECL]#", 1, 6))
				thing.vars[V] = GET_DECL(text2path(copytext(encoded_value, 6)))
				continue
			if(findtext(encoded_value, "[SERIALIZER_TYPE_DATUM_FLAT]#", 1, 10))
				// This is a flattened object.
				thing.vars[V] = QueryAndDeserializeDatum(copytext(encoded_value, 10))
				continue
			if(findtext(encoded_value, "[SERIALIZER_TYPE_FLAT_REF]#", 1, 10))
				// This is a flattened object that has already been serialized somewhere up the JSON branch.
				var/thing_id = copytext(encoded_value, 10)
				if(!(thing_id in reverse_map))
					to_world_log("Failed to deserialize flat ref for ID [thing_id] for object [thing] with ID [thing.persistent_id]!")
					continue
				thing.vars[V] = reverse_map[thing_id]
			if(findtext(encoded_value, "[SERIALIZER_TYPE_WRAPPER]#", 1, 6))
				// This is a wrapped object
				var/datum/wrapper/GD = QueryAndDeserializeDatum(copytext(encoded_value, 6))
				thing.vars[V] = GD.on_deserialize(src)
				continue
		else if(islist(encoded_value))
			thing.vars[V] = DeserializeList(encoded_value)
			continue
		thing.vars[V] = encoded_value
	thing.after_deserialize()
	return thing

/serializer/json/DeserializeList(var/raw_list)
	var/list/final_list = list()
	for(var/K in raw_list)
		var/key = K
		if(istext(K))
			if(findtext(K, "[SERIALIZER_TYPE_DATUM]#", 1, 5))
				key = sql.QueryAndDeserializeDatum(copytext(K, 5))
			else if(findtext(K, "[SERIALIZER_TYPE_PATH]#", 1, 6))
				key = text2path(copytext(K, 6))
			else if(findtext(K, "[SERIALIZER_TYPE_DECL]#", 1, 6))
				key = GET_DECL(text2path(copytext(K, 6)))
			else if(findtext(K, "[SERIALIZER_TYPE_DATUM_FLAT]#", 1, 10))
				key = QueryAndDeserializeDatum(copytext(K, 10))
			else if(findtext(K, "[SERIALIZER_TYPE_FLAT_REF]#", 1, 10))
				// This is a flattened object that has already been serialized somewhere up the JSON branch.
				var/thing_id = copytext(K, 10)
				if(!(thing_id in reverse_map))
					to_world_log("Failed to deserialize flat ref for ID [thing_id] for list!")
					continue
				key = reverse_map[thing_id]
			else if(findtext(K, "[SERIALIZER_TYPE_WRAPPER]#", 1, 6))
				var/datum/wrapper/GD = QueryAndDeserializeDatum(copytext(K, 6))
				key = GD.on_deserialize(src)
		else if(islist(K))
			key = DeserializeList(K)
		try
			var/V = raw_list[K]
			if(istext(V))
				if(findtext(V, "[SERIALIZER_TYPE_DATUM]#", 1, 5))
					V = sql.QueryAndDeserializeDatum(copytext(V, 5))
				else if(findtext(V, "[SERIALIZER_TYPE_PATH]#", 1, 6))
					V = text2path(copytext(V, 6))
				else if(findtext(V, "[SERIALIZER_TYPE_DECL]#", 1, 6))
					V = GET_DECL(text2path(copytext(V, 6)))
				else if(findtext(V, "[SERIALIZER_TYPE_DATUM_FLAT]#", 1, 10))
					V = QueryAndDeserializeDatum(copytext(V, 10))
				else if(findtext(V, "[SERIALIZER_TYPE_FLAT_REF]#", 1, 10))
					var/thing_id = copytext(V, 10)
					if(!(thing_id in reverse_map))
						to_world_log("Failed to deserialize flat ref for ID [thing_id] for list value!")
						continue
					V = reverse_map[thing_id]
				else if(findtext(V, "[SERIALIZER_TYPE_WRAPPER]#", 1, 6))
					var/datum/wrapper/GD = QueryAndDeserializeDatum(copytext(V, 6))
					V = GD.on_deserialize(src)
			else if(islist(V))
				V = DeserializeList(V)
			if(V)
				final_list[key] = V
			else
				final_list.Add(key)
		catch
			final_list.Add(key)
	return final_list

/serializer/json/QueryAndDeserializeDatum(var/thing_json)
	var/list/tokens = splittext(thing_json, "|")
	var/thing_type = text2path(tokens[1])
	if(!thing_type)
		return
	var/list/thing_vars = json_decode(jointext(tokens.Copy(2), "|"))

	// Check to see if we've already deserialized this flattened thing.
	var/thing_ID = thing_vars["persistent_id"]
	if(thing_ID in reverse_map)
		return reverse_map[thing_ID]
	var/datum/existing = new thing_type
	// Assign this early for the sake of easier debugging.
	existing.vars["persistent_id"] = thing_ID
	thing_vars -= "persistent_id"
	reverse_map[thing_ID] = existing
	return JsonDeserializeDatum(existing, thing_vars)
