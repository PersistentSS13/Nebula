////////////////////////////////////////////
// Custom saved data helpers
////////////////////////////////////////////
//Helper macros to set and retrieve custom saved vars from the 
// custom_saved vars list.

#define CUSTOM_SV(VARNAME, DATA)\
LAZYSET(src.custom_saved, VARNAME, DATA);

#define CUSTOM_SV_LIST(VARNAMES...)\
if(!src.custom_saved){src.custom_saved = list(VARNAMES);}\
else{src.custom_saved |= list(VARNAMES);}

//Load saved var data
#define LOAD_CUSTOM_SV(VARNAME) src.custom_saved?[VARNAME]

//Deletes temporary saved vars data (Has to be in one line or spacemandm gets mad)
#define CLEAR_ALL_SV for(var/k in src.custom_saved){ if(!istype(src.custom_saved[k], /datum)){continue;}if(islist(src.custom_saved[k])){var/list/todel = src.custom_saved[k]; QDEL_NULL_LIST(todel);}else{QDEL_NULL(src.custom_saved[k]);}}; src.custom_saved = null;

//Removes the entry from the saved var table. 
// !!- Make sure to qdel the data if applicable! -!!
#define CLEAR_SV(VARNAME) LAZYREMOVE(src.custom_saved, VARNAME)

//Helper to place at the end of Initialize of saved objects to make sure they lateinit only if they don't get deleted during init and if they were saved!
#define LATE_INIT_IF_SAVED \
if(. != INITIALIZE_HINT_QDEL && src.persistent_id){return INITIALIZE_HINT_LATELOAD;}

////////////////////////////////////////////
// Persistence Error Tolerance
////////////////////////////////////////////
///Do not tolerate any errors during save/load.
#define PERSISTENCE_ERROR_TOLERANCE_NONE 0
///Tolerate only recoverable errors during save/load.
#define PERSISTENCE_ERROR_TOLERANCE_RECOVERABLE 1
///Tolerate ANY errors during save/load. This is likely to cause a corrupted save.
#define PERSISTENCE_ERROR_TOLERANCE_ANY 2