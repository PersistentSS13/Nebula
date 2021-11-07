/datum/wrapper/late/extension/labels
	wrapper_for = /datum/extension/labels

/datum/wrapper/late/extension/labels/on_late_load()
	. = ..()
	var/datum/extension/labels/target = .
	if(!istype(target))
		return
	if(length(target.labels))
		var/atom/holder = target.holder
		for(var/label in target.labels)
			holder.name = "[holder.name] ([label])"
		holder.verbs += /atom/proc/RemoveLabel
