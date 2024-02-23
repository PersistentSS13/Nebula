///A macro for getting the current save DB name
#define SQLS_SAVE_DATABASE global.sqldb

/////////////////////////////////////////////////////////
// Serialized type names
/////////////////////////////////////////////////////////

#define SERIALIZER_TYPE_NULL        "NULL"
#define SERIALIZER_TYPE_VAR         "VAR"
#define SERIALIZER_TYPE_TEXT        "TEXT"
#define SERIALIZER_TYPE_NUM         "NUM"
#define SERIALIZER_TYPE_PATH        "PATH"
#define SERIALIZER_TYPE_FILE        "FILE"
#define SERIALIZER_TYPE_WRAPPER     "WRAP"
#define SERIALIZER_TYPE_LIST        "LIST"
#define SERIALIZER_TYPE_LIST_EMPTY  "EMPTY"
#define SERIALIZER_TYPE_DATUM       "OBJ"
#define SERIALIZER_TYPE_DATUM_FLAT  "FLAT_OBJ"
#define SERIALIZER_TYPE_FLAT_REF    "FLAT_REF"
#define SERIALIZER_TYPE_DECL        "DECL"

/////////////////////////////////////////////////////////
// SQL table names
/////////////////////////////////////////////////////////

#define SQLS_TABLE_DATUM            "thing"
#define SQLS_TABLE_DATUM_VARS       "thing_var"
#define SQLS_TABLE_LIST_ELEM        "list_element"
#define SQLS_TABLE_Z_LEVELS         "z_level"
#define SQLS_TABLE_AREAS            "areas"
#define SQLS_TABLE_INSTANCES        "instances"
#define SQLS_TABLE_WORLDS           "worldsaves"
#define SQLS_TABLE_CHARACTERSAVES   "charactersaves"
#define SQLS_TABLE_CHARACTERS       "characters"


/////////////////////////////////////////////////////////
// SQL Stored Functions Names
/////////////////////////////////////////////////////////

///Name of the stored function that returns the time we last made a world save from the db.
#define SQLS_FUNC_GET_LAST_SAVE_TIME     "GetLastWorldSaveTime"
///Log to the table when a world save begins, returns the current save log id.
#define SQLS_FUNC_LOG_SAVE_WORLD_START   "LogSaveWorldStart"
///Log to the table when a limbo/storage save begins, returns the current save log id.
#define SQLS_FUNC_LOG_SAVE_STORAGE_START "LogSaveStorageStart"
///Log to the table when any save ends, returns the current save log id.
#define SQLS_FUNC_LOG_SAVE_END           "LogSaveEnd"

/////////////////////////////////////////////////////////
// SQL Stored Procedures Names
/////////////////////////////////////////////////////////

///Delete the current world save from the db, so we can write a newer one. Procedures are executed with CALL, and don't return anything.
#define SQLS_PROC_CLEAR_WORLD_SAVE       "ClearWorldSave"

/////////////////////////////////////////////////////////
// Character Status ENUM
/////////////////////////////////////////////////////////
#define SQLS_CHAR_STATUS_CRYO  1
#define SQLS_CHAR_STATUS_WORLD  2
#define SQLS_CHAR_STATUS_FIRST  3
#define SQLS_CHAR_STATUS_DELETED  4
/////////////////////////////////////////////////////////
// SQL Helpers
/////////////////////////////////////////////////////////

///A helper for executing a sql query and throwing the proper exception with a standardized error message. QUERY must be a variable.
#define SQLS_EXECUTE_AND_REPORT_ERROR(QUERY, ERRORMSG)\
	if(!QUERY.Execute()){\
		var/errormsg = ERRORMSG + " '[QUERY.ErrorMsg()]'" + "\n'[QUERY.sql]'"; \
		to_world_log(errormsg);\
		throw new /exception/sql_connection(errormsg, __FILE__, __LINE__); \
	}
