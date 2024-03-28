/datum/extension
	should_save = FALSE

/datum/extension/New(datum/holder)
	. = ..()
	if(should_save)
		events_repository.register(/decl/observ/world_saving_start_event, SSpersistence, src, PROC_REF(on_save))

/datum/extension/Destroy()
	if(should_save)
		events_repository.unregister(/decl/observ/world_saving_start_event, SSpersistence, src)
	. = ..()

/datum/extension/proc/on_save()
	SSpersistence.saved_extensions += src

/datum/extension/should_save(object_parent, one_off = FALSE)
	if(object_parent) // Extensions are saved manually, either by self-reporting or by the one off serializer checking. Don't permit saving from object vars.
		return FALSE

	// If the holder is a movable and wouldn't be saved, don't save this either.
	if(!one_off && istype(holder, /atom/movable))
		var/atom/movable/H = holder
		if(!H.in_saved_location())
			return FALSE

	return ..()