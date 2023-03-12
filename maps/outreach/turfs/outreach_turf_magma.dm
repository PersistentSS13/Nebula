///////////////////////////////////////////////////////////////////////////////////
// Magma
///////////////////////////////////////////////////////////////////////////////////
/turf/simulated/magma
	name           = "magma"
	icon           = 'icons/turf/flooring/lava.dmi'
	icon_state     = "lava"
	movement_delay = 4
	footstep_type  = /decl/footsteps/lava
	temperature    = T0C + 800 //Temperature of lava
	pathweight     = 200 //Ai doesn't like stepping in lava
	open_turf_type = /turf/simulated/magma //Can't get rid of it that way
	prev_type      = /turf/simulated/magma
	var/list/victims
	///Cached object covering the lava on the last process tick
	var/tmp/weakref/cached_lava_cover
	/**Types that when present on the tile prevent other objects on the tile from getting hit with lava_act */
	var/static/list/lava_cover_types = list(
		/obj/structure/lattice,
		/obj/structure/catwalk,
		/obj/structure/wall_frame,
		/obj/structure/stairs
	)

/turf/simulated/magma/Initialize()
	. = ..()
	set_light(4, l_power = 1.0, l_color = LIGHT_COLOR_LAVA)

/turf/simulated/magma/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/turf/simulated/magma/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/stack/tile))
		return //Don't let people build over this
	. = ..()

/turf/simulated/magma/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return

/turf/simulated/magma/try_build_cable(obj/item/stack/cable_coil/C, mob/user)
	return FALSE

/turf/simulated/magma/is_solid_structure()
	return ..() || (locate(/obj/structure/catwalk) in src)

/turf/simulated/magma/AddTracks(typepath, bloodDNA, comingdir, goingdir, bloodcolor)
	return FALSE //You can't leave tracks in magma

/turf/simulated/magma/add_blood(mob/living/carbon/human/M)
	return FALSE

/turf/simulated/magma/add_blood_floor(mob/living/carbon/M)
	return FALSE

/turf/simulated/magma/Entered(atom/movable/AM)
	..()
	//Check for anything covering the lava
	if(get_covering_object())
		return

	var/mob/living/L = AM
	if (istype(L) && L.can_overcome_gravity())
		return
	if(istype(AM, /obj/machinery/atmospherics/pipe)) //#TODO: Maybe find something better?
		return
	if(AM.is_burnable())
		LAZYADD(victims, weakref(AM))
		START_PROCESSING(SSobj, src)

/turf/simulated/magma/Exited(atom/movable/AM)
	. = ..()
	LAZYREMOVE(victims, weakref(AM))

/turf/simulated/magma/Process()
	//Check if we have a covering object
	if(get_covering_object())
		return

	for(var/weakref/W in victims)
		var/atom/movable/AM = W.resolve()
		if (AM == null || get_turf(AM) != src || AM.is_burnable() == FALSE)
			victims -= W
			continue
		var/datum/gas_mixture/environment = return_air()
		var/pressure = environment.return_pressure()
		var/destroyed = AM.lava_act(environment, environment.temperature, pressure)
		if(destroyed == TRUE)
			victims -= W
	if(!LAZYLEN(victims))
		return PROCESS_KILL

/turf/simulated/magma/proc/get_covering_object()
	var/atom/movable/covering = cached_lava_cover?.resolve()
	if(QDELETED(covering) || covering.loc != src)
		for(var/atom/movable/thing in contents)
			if(!QDELETED(thing) && is_type_in_list(thing, lava_cover_types))
				cached_lava_cover = weakref(thing)
				. = thing
				break
	else
		. = covering
