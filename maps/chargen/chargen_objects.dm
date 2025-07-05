/obj/chargen
	anchored = TRUE

/////////////////////////////////////////////////////////////////////
// Fake Atmos
/////////////////////////////////////////////////////////////////////

/obj/chargen/supply_pipe
	name = "Air supply pipe"
	desc = "A length of pipe."
	color = PIPE_COLOR_BLUE
	icon = 'icons/atmos/pipes.dmi'
	icon_state = "11-supply"
	layer = PIPE_LAYER
	level = 1

/obj/chargen/scrubber_pipe
	name = "scrubbers pipe"
	desc = "A one meter section of scrubbers pipe."
	color = PIPE_COLOR_RED
	icon = 'icons/atmos/pipes.dmi'
	icon_state = "11-scrubbers"
	layer = PIPE_LAYER
	level = 1

/obj/chargen/air_tank
	name = "Pressure Tank (Air)"
	desc = "A large vessel containing pressurized gas."
	icon = 'icons/atmos/tank.dmi'
	icon_state = "air"
	density = TRUE
	layer = STRUCTURE_LAYER

/obj/chargen/pump
	name = "Colony Pod Vent Pump #1"
	desc = "Has a valve and pump attached to it."
	icon = 'icons/atmos/vent_pump.dmi'
	icon_state = "out"
	layer = ABOVE_TILE_LAYER

/obj/chargen/scrubber
	name = "Colony Pod Air Scrubber #1"
	desc = "Has a valve and pump attached to it."
	icon = 'icons/atmos/vent_scrubber.dmi'
	icon_state = "on"
	layer = ABOVE_TILE_LAYER

/////////////////////////////////////////////////////////////////////
// Fake Deco
/////////////////////////////////////////////////////////////////////

/obj/chargen/airlock
	name = "Secure Airlock"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/secure/door.dmi'
	icon_state = "closed"
	opacity = TRUE
	density = TRUE

/obj/chargen/airlock/Initialize(mapload)
	. = ..()
	if(!(/obj/chargen/airlock in global.wall_blend_objects))
		global.wall_blend_objects += /obj/chargen/airlock

/obj/chargen/light
	name = "light fixture"
	desc = "A lighting fixture"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube_map"

/obj/chargen/light/Initialize(mapload)
	. = ..()
	set_light(5, 0.9, LIGHT_COLOR_TUNGSTEN)

/obj/chargen/thruster
	name = "rocket nozzle"
	desc = "Simple rocket nozzle, expelling gas at hypersonic velocities to propell the ship."
	icon = 'icons/obj/ship_engine.dmi'
	icon_state = "nozzle"
	opacity = TRUE
	density = TRUE
