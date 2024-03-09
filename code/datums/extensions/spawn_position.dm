
/**
	Helper to signal we're an atom that offers a spawn point.
	By default, spawns onto the turf our holder is on.
 */
/datum/extension/spawn_position
	base_type = /datum/extension/spawn_position
	var/name = "spawn position"
	///The type of the spawnpoint provider for this spawn position. Is a type path on definition, and gets turned into a decl instance later.
	var/decl/spawnpoint/provider

/datum/extension/spawn_position/New(datum/holder, spawn_provider_path)
	. = ..()
	if(ispath(spawn_provider_path))
		provider = spawn_provider_path
	if(ispath(provider))
		provider = GET_DECL(provider)
		provider?.register_spawn_position(src)

/datum/extension/spawn_position/Destroy()
	if(istype(provider))
		provider.unregister_spawn_position(src)
	. = ..()

/**
	Returns if the spawn position is available to the given mob when not busy.
 */
/datum/extension/spawn_position/proc/is_available(mob/living/to_spawn)
	return TRUE

/**
	Returns if the spawn point is temporarily busy, and cannot be used to spawn something temporarily.
 */
/datum/extension/spawn_position/proc/is_busy()
	return FALSE

/**
	Handling for placing the spawned mob. Meant to abstrat what is being spawned into. So it can be a turf, or something else.
 */
/datum/extension/spawn_position/proc/place(mob/living/to_spawn)
	. = get_turf(holder)
	to_spawn.forceMove(.)
	provider.after_join(to_spawn)
