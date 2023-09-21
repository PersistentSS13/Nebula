// Get an object from its p_id via ref tracking. This will not always work if an object is asynchronously deserialized from others.
// This is also quite slow - if you're trying to locate many objects at once, it's best to use a single query for multiple objects.
/datum/controller/subsystem/persistence/proc/get_object_from_p_id(var/target_p_id)
//#TODO: This could be sped up by changing the db structure to use indexes and using stored procedures.

	// Check to see if the object has been deserialized from limbo and not yet added to the normal tables.
	if(target_p_id in limbo_refs)
		var/datum/existing = locate(limbo_refs[target_p_id])
		if(existing && !QDELETED(existing) && existing.persistent_id == target_p_id)
			return existing
		limbo_refs -= target_p_id

	// If it was in limbo_refs we shouldn't find it in the normal tables, but we'll check anyway.
	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection during Object Lookup!")
		new_db_connection = TRUE
	var/DBQuery/world_query = dbcon_save.NewQuery("SELECT `p_id`, `ref` FROM `[SQLS_TABLE_DATUM]` WHERE `p_id` = \"[target_p_id]\";")
	SQLS_EXECUTE_AND_REPORT_ERROR(world_query, "OBTAINING OBJECT FROM P_ID FAILED:")

	while(world_query.NextRow())
		var/list/items = world_query.GetRowData()
		var/datum/existing = locate(items["ref"])
		if(existing && !QDELETED(existing) && existing.persistent_id == items["p_id"])
			. = existing
		break

	if(new_db_connection)
		close_save_db_connection()

/datum/controller/subsystem/persistence/proc/clear_late_wrapper_queue()
	if(!length(late_wrappers))
		return
	//#TODO: Move db handling to serializer stuff.
	var/new_db_connection = FALSE
	if(!check_save_db_connection())
		if(!establish_save_db_connection())
			CRASH("SSPersistence: Couldn't establish DB connection while clearing wrapper queue!")
		new_db_connection = TRUE
	for(var/datum/wrapper/late/L as anything in late_wrappers)
		L.on_late_load()

	late_wrappers.Cut()
	if(new_db_connection)
		close_save_db_connection() //#TODO: Move db handling to serializer stuff.
