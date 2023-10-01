///Add something to the off-world save.
/datum/controller/subsystem/persistence/proc/AddToLimbo(var/list/things, var/key, var/limbo_type, var/metadata, var/metadata2, var/modify = TRUE, var/initiator)
	//Make sure we log who started the save.
	if(!initiator && ismob(usr))
		initiator = usr.ckey

	//#TODO: Move db handling to serializer stuff.
	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection during Limbo Addition!")
		new_db_connection = TRUE

	//Log transaction
	var/limbo_log_id = one_off.PreStorageSave(initiator)
	//#TODO: Use a single serializer for both limbo and world save
	. = one_off.AddToLimbo(things, key, limbo_type, metadata, metadata2, modify)
	if(.) // Clear it from the queued removals.
		for(var/list/queued in limbo_removals)
			if(queued[1] == sanitize_sql(key) && queued[2] == limbo_type)
				limbo_removals -= list(queued)

	one_off.PostStorageSave(limbo_log_id, 0, length(things), "Addition [limbo_type] [key]")
	if(new_db_connection)
		close_save_db_connection() //#TODO: Move db handling to serializer stuff.

///Remove something from the off-world save.
/datum/controller/subsystem/persistence/proc/RemoveFromLimbo(var/limbo_key, var/limbo_type, var/initiator)
	//#TODO: Move db handling to serializer stuff.
	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection during Limbo Removal!")

	//Log transaction
	var/limbo_log_id = one_off.PreStorageSave(initiator)
	//#TODO: Use a single serializer for both limbo and world save
	. = one_off.RemoveFromLimbo(limbo_key, limbo_type)
	one_off.PostStorageSave(limbo_log_id, 0, ., "Removal [limbo_type]")

	//#TODO: Move db handling to serializer stuff.
	if(new_db_connection)
		close_save_db_connection()

///Load something from the off-world save.
/datum/controller/subsystem/persistence/proc/LoadFromLimbo(var/limbo_key, var/limbo_type, var/remove_after = TRUE)
	//#TODO: Move db handling to serializer stuff.
	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection during Limbo Deserialization!")
		new_db_connection = TRUE

	//#TODO: Use a single serializer for both limbo and world save
	. = one_off.LoadFromLimbo(limbo_key, limbo_type, remove_after)
	if(remove_after)
		limbo_removals += list(list(sanitize_sql(limbo_key), limbo_type))

	//#TODO: Move db handling to serializer stuff.
	if(new_db_connection)
		close_save_db_connection()
