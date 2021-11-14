/datum/wrapper/late/extension // Default behavior. No var overriding outside of setting itself on a holder.
	wrapper_for = /datum/extension
	var/holder_p_id
	var/list/extension_saved_vars = list()

/datum/wrapper/late/extension/on_serialize(datum/extension/object)
	. = ..()
	if(!object.holder)
		return
	key = "[object.type]"
	if(!object.holder.persistent_id)
		object.holder.persistent_id = PERSISTENT_ID
	holder_p_id = object.holder.persistent_id

	// Here we load all the saved vars into a list to be manually inserted into the extension later.
	// This list is itself serialized, so we don't need to check for var types etc. but we repeat some optimizations that wouldn't overwise be done
	// since the vars are in a list and not on the parent object.
	for(var/V in object.get_saved_vars())
		if(!issaved(object.vars[V]))
			continue
		var/VV = object.vars[V]
		if(VV == initial(object.vars[V]))
			continue
		extension_saved_vars[V] = VV

/datum/wrapper/late/extension/on_late_load()
	var/datum/holder = SSpersistence.get_object_from_p_id(holder_p_id)
	if(!ispath(text2path(key), /datum/extension))
		qdel(src)
		return
	if(!istype(holder))
		qdel(src)
		return
	var/datum/extension/target = get_or_create_extension(holder, text2path(key))

	if(target)
		for(var/V in extension_saved_vars)
			var/VV = extension_saved_vars[V]
			target.vars[V] = VV
	. = target
	qdel(src)