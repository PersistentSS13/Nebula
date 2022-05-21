/**
 * Define a var from a class as saved. 
 * Also test the CLASSPATH class to see if the var exist at compilation. 
 */
#define SAVED_VAR(CLASSPATH, VARNAME) CLASSPATH/proc/zz_compilerVarExistsTest_##VARNAME(){.=src.##VARNAME;}; /decl/saved_variables##CLASSPATH/make_saved_variables(list/saved){LAZYDISTINCTADD(saved, #VARNAME); return ..(saved);}
///decl/saved_variables##CLASSPATH/type_path = CLASSPATH;

/**
 * Mark the type as being turned into a single json array when saved.
 */
#define SAVED_FLATTEN(CLASSPATH) /decl/saved_variables##CLASSPATH/should_flatten = TRUE;
