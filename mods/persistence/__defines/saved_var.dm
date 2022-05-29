/**
 * Define a var from a class as saved. 
 * Also test the CLASSPATH class to see if the var exist at compilation. 
 */
#define SAVED_VAR(CLASSPATH, VARNAME) CLASSPATH/proc/zz_compilerVarExistsTest_##VARNAME(){.=src.##VARNAME;}; /decl/saved_variables##CLASSPATH/make_saved_variables(list/saved){LAZYDISTINCTADD(saved, #VARNAME); return ..(saved);}

/**
 * Clears all saved variables for this particular type and its children.
 * Useful when you don't care about saving the state of some things, and just want them to be instantiated from scratch on load.
 */
#define SAVED_INSTANCIATE_ONLY(CLASSPATH) /decl/saved_variables##CLASSPATH/make_saved_variables(list/saved){if(length(cached)){cached.Cut();}}

/**
 * Save only the incon_state for this object, and ignore any other variable set by ancestors.
 */
#define SAVED_ICON_STATE_ONLY(CLASSPATH) /decl/saved_variables##CLASSPATH/make_saved_variables(list/saved){if(length(cached)){cached.Cut();}cached=list("icon_state", "icon", "opacity", "color");}

/**
 * Mark the type as being turned into a single json array when saved.
 */
#define SAVED_FLATTEN(CLASSPATH) /decl/saved_variables##CLASSPATH/should_flatten = TRUE;
