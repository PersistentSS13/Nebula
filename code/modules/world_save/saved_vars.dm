/**
 * Turns type path into a path to that type's saved variables singleton datum
 * Not meant to be used elsewhere.
*/
#define GET_SAVED_DECL_FOR(P) (global.cached_text2path_saved_decls[P]? global.cached_text2path_saved_decls[P] : (global.cached_text2path_saved_decls[P] = text2path("[global.SAVED_VARIABLES_TYPE][P]")))

/**Base type of the saved vars datum*/
var/global/SAVED_VARIABLES_TYPE = /decl/saved_variables

/**Caches the last ancestor that has defined saved variables for a given type. So we don't spend too much time during lookups */
var/global/list/cached_sv_child_to_last_ancestor = list()

/**
 * Caches the /decl/saved_variables type matching a given /datum type path.
 * Key is /datum typepath, value is the type of the matching /decl/saved_variables.
*/
var/global/list/cached_text2path_saved_decls = list()

/////////////////////////////////////////
// Helper Procs
/////////////////////////////////////////
/**
 * Helper proc to return the saved_variables datum for a given type path.
*/
/proc/get_saved_decl(var/path)
	var/decl/saved_variables/SV
	if(cached_sv_child_to_last_ancestor[path])  //Check the ancestor cache first
		SV = GET_DECL(GET_SAVED_DECL_FOR(cached_sv_child_to_last_ancestor[path]))
	else
		SV = GET_DECL(GET_SAVED_DECL_FOR(path))

	if(SV)
		return SV

	//!! If we end up here, we couldn't find saved vars for our specific type, and we haven't cached an ancestor type to use the saved vars of instead. !!
	var/list/lookup_path = splittext("[path]", "/")
	for(var/i = length(lookup_path), i > 1 , i--)
		var/cur_path = "[jointext(lookup_path, "/", 1, i)]" //Go down the type path to find the first parent type that has saved vars defined
		SV = GET_DECL(GET_SAVED_DECL_FOR(cur_path))
		if(istype(SV))
			cached_sv_child_to_last_ancestor[path] = cur_path
			return SV

	log_warning("proc/get_saved_decl('[path]'): Couldn't find the last ancestor with saved variables for type '[path]'!")
	return

/**
 * Helper proc to return a list of saved vars names for a given type of datum/atom.
*/
var/global/get_saved_variables_lookup_time_total = 0
/proc/get_saved_variables_for(var/path)
	var/time_bef = REALTIMEOFDAY
	var/decl/saved_variables/SV = get_saved_decl(path)
	. = SV?.get_saved_variables()
	get_saved_variables_lookup_time_total += (REALTIMEOFDAY - time_bef)

/////////////////////////////////////////
// Saved Variables decl
/////////////////////////////////////////

/**
 * Singleton datum for holding saved variables info for a given type.
 * Don't define one of those manually, and instead use the macros.
 * Objects of this type expect the path of the entity they contain info on to have their full path in the datum subtype's path. (Ex: /mob/living -> /decl/saved_variables/mob/living )
 */
/decl/saved_variables
	///The type path of the object this saved_vars decl is for
	var/type_path
	///Used for types that inherit from another, even though the path doesn't represents that
	///(AKA /obj inheriting from /atom/movable, and /atom/movable inheriting from /datum)
	var/base_type = /datum
	///Whether the type should be saved entirely as a json array.
	var/should_flatten = FALSE
	///Saved vars cached after being generated from the macros, since that involves a lot of proc calls
	var/list/cached

/decl/saved_variables/Initialize()
	. = ..()
	//Since the whole path to the object we represent is stored in our type, we just take it from there
	if(!type_path)
		type_path = text2path(copytext("[type]", length("[SAVED_VARIABLES_TYPE]")))

/**
 * This is called by the macro to override the proc and set the name of the newly added saved var.
 * This shouldn't be called before all decl of this type are instantiated!!!
*/
/decl/saved_variables/proc/make_saved_variables(var/list/saved = list())
	cached = saved
	if(ispath(base_type))
		var/list/base_saved = get_saved_variables_for(base_type)
		if(!base_saved)
			log_warning("[src.type]/make_saved_variables(): Got null saved var for non-null base_type '[base_type]'!")
		else
			cached |= base_saved
	return cached

/**This is what should be used to retrieve the saved var list. It lazy init the cached list and returns it. */
/decl/saved_variables/proc/get_saved_variables()
	if(!cached)
		make_saved_variables() //Generate cache if needed
	return cached

/**Will test the instance of the given object if its the object we're holding the saved vars for. Will returns FALSE if something is wrong with the variables.*/
/decl/saved_variables/proc/test_variables(var/datum/instance)
	if(!ispath(instance.type, type_path))
		return FALSE
	for(var/v in get_saved_variables())
		if(!issaved(instance.vars[v]))
			log_warning("BAD SAVED VARIABLE: [type_path]'s [v] variable is marked as saved even though its either marked const or tmp, or otherwise forbidden to save!")
			return FALSE
	return TRUE

/////////////////////////////////////////
// Defined Base Types
/////////////////////////////////////////
//Since byond obscure some of the type paths, we have to specify that those inherit from other types

/decl/saved_variables/datum
	type_path = /datum
	base_type = null //Datum is the base type of everything, so nothing here.

//Atoms
/decl/saved_variables/atom
	type_path = /atom

/decl/saved_variables/turf
	type_path = /turf
	base_type = /atom

/decl/saved_variables/area
	type_path = /area
	base_type = /atom

//Movables
/decl/saved_variables/atom/movable
	type_path = /atom/movable

/decl/saved_variables/obj
	type_path = /obj
	base_type = /atom/movable

/decl/saved_variables/mob
	type_path = /mob
	base_type = /atom/movable

#undef GET_SAVED_DECL_FOR