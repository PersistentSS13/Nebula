///////////////////////////////////////////////////////////////////////////////////
// Simulated Volcanic
///////////////////////////////////////////////////////////////////////////////////
/turf/simulated/floor/volcanic
	name             = "volcanic floor"
	base_name        = "rock"
	base_desc        = "Solidified magma."
	icon             = 'icons/turf/exterior/volcanic.dmi'
	icon_state       = "0"
	base_icon_state  = "0"
	footstep_type    = /decl/footsteps/asteroid
	initial_flooring = null
	initial_gas      = null
	temperature      = TCMB
	turf_flags       = TURF_ACID_IMMUNE | TURF_FLAG_BACKGROUND

/turf/simulated/floor/volcanic/can_engrave()
	return

/turf/simulated/floor/volcanic/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return

/turf/simulated/floor/volcanic/attackby(obj/item/C, mob/user)
	if(IS_WELDER(C) || istype(C, /obj/item/gun/energy/plasmacutter))
		return //Prevents removing the floor with a welder..
	. = ..()
