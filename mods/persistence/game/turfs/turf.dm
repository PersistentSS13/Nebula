/turf
	var/list/applied_decals //Stores the type, and arguments of floor decals applied on this turf

SAVED_VAR(/turf, turf_flags)
SAVED_VAR(/turf, blood_DNA)
SAVED_VAR(/turf, applied_decals)

/turf/after_deserialize()
	..()
	initial_gas = null
	if(lighting_overlay)
		lighting_clear_overlay()
		log_warning("[src]([x],[y],[z]) has a lighting overlay after load!!")

/turf/Initialize(mapload, ...)
	//Restore saved decals
	if(persistent_id && LAZYLEN(applied_decals))
		//Get rid of any extra trash
		remove_decals()

		//Clear the applied decals list so we don't duplicate entries
		var/list/tmp_decal_info = applied_decals
		applied_decals = null

		//Recreate the decals
		for(var/info in tmp_decal_info)
			var/list/entry = json_decode(info)
			var/dec_type = entry["type"]
			var/obj/effect/floor_decal/dec = new dec_type(src) //<- CONSTRUCTOR EATS THE ARGS!!!!
			//Technically risky because floor_decal delete on init, but it works, so not gonna complain too much for now. Mainly since the constructor args don't pass on correctly.
			dec.set_dir(entry["dir"])
			dec.set_color(entry["color"])
		LAZYCLEARLIST(tmp_decal_info)
	. = ..()

/obj/effect/floor_decal/LateInitialize(mapload, newdir, newcolour, newappearance)
	var/turf/T = get_turf(src)
	. = ..()
	if(T)
		//Save the decal data in the turf as a json object, so we can actually reproduce them on load properly
		LAZYADD(T.applied_decals, @'{"type":"[type]", "dir":[dir], "color":"[color]"}')

/obj/effect/floor_decal/reset/LateInitialize(mapload, newdir, newcolour, newappearance)
	var/turf/T = get_turf(src)
	. = ..()
	if(T)
		LAZYCLEARLIST(T.applied_decals) //If we apply a reset, just purge the decal info to avoid accumulating garbage

///Edge blocker turf
/turf/unsimulated/dark_border
	name             = "darkness"
	icon             = 'icons/turf/space.dmi'
	icon_state       = "black"
	density          = TRUE
	opacity          = TRUE
	permit_ao        = FALSE
	dynamic_lighting = FALSE