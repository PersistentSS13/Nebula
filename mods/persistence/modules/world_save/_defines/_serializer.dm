/*
	Serialized type names
*/ 
#define SERIALIZER_TYPE_NULL		"NULL"
#define SERIALIZER_TYPE_VAR 		"VAR"
#define SERIALIZER_TYPE_TEXT		"TEXT"
#define SERIALIZER_TYPE_NUM 		"NUM"
#define SERIALIZER_TYPE_PATH		"PATH"
#define SERIALIZER_TYPE_FILE		"FILE"
#define SERIALIZER_TYPE_WRAPPER 	"WRAP"
#define SERIALIZER_TYPE_LIST		"LIST"
#define SERIALIZER_TYPE_LIST_EMPTY	"EMPTY"
#define SERIALIZER_TYPE_DATUM		"OBJ"
#define SERIALIZER_TYPE_DATUM_FLAT	"FLAT_OBJ"

/*
	SQL table names
*/
#define SQLS_TABLE_DATUM 				"thing"
#define SQLS_TABLE_DATUM_VARS 			"thing_var"
#define SQLS_TABLE_LIST_ELEM 			"list_element"
#define SQLS_TABLE_Z_LEVELS 			"z_level"
#define SQLS_TABLE_LIMBO 				"limbo"
#define SQLS_TABLE_LIMBO_DATUM			"limbo_thing"
#define SQLS_TABLE_LIMBO_DATUM_VARS 	"limbo_thing_var"
#define SQLS_TABLE_LIMBO_LIST_ELEM		"limbo_list_element"

var/global/_sqls_cached_error
#define SQLS_EXECUTE_ROWCHANGE_AND_REPORT_ERROR(QUERY, ERRORMSG)\
	QUERY.Execute();\
	_sqls_cached_error = QUERY.ErrorMsg();\
	if(!QUERY.RowsAffected() || _sqls_cached_error){\
		to_world_log(ERRORMSG + " '[_sqls_cached_error]'");\
	}

#define SQLS_EXECUTE_AND_REPORT_ERROR(QUERY, ERRORMSG)\
	QUERY.Execute();\
	_sqls_cached_error = QUERY.ErrorMsg();\
	if(_sqls_cached_error){\
		to_world_log(ERRORMSG + " '[_sqls_cached_error]'");\
	}