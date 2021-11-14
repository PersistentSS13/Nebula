/datum/extension
	should_save = FALSE

/datum/extension/New(datum/holder)
	. = ..()
	if(should_save)
		events_repository.register(/decl/observ/world_saving_start_event, SSpersistence, src, .proc/on_save)

/datum/extension/Destroy()
	if(should_save)
		events_repository.unregister(/decl/observ/world_saving_start_event, SSpersistence, src)
	. = ..()

/datum/extension/proc/on_save()
	SSpersistence.saved_extensions += src

/datum/extension/should_save(object_parent)
	if(object_parent) // Extensions are saved manually, either by self-reporting or by the one off serializer checking. Don't permit saving from object vars.
		return FALSE
	return should_save