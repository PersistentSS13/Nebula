/obj/chargen
	anchored = TRUE

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

/obj/chargen/airlock
	name = "Secure Airlock"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/secure/door.dmi'
	icon_state = "closed"
	opacity = TRUE
	density = TRUE
/obj/chargen/airlock/Initialize()
	. = ..()
	if(!(/obj/chargen/airlock in global.wall_blend_objects))
		global.wall_blend_objects += /obj/chargen/airlock

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

/obj/chargen/light
	name = "light fixture"
	desc = "A lighting fixture"
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube_map"

/obj/chargen/light/Initialize()
	. = ..()
	set_light(5, 0.9, LIGHT_COLOR_TUNGSTEN)

/obj/chargen/thruster
	name = "rocket nozzle"
	desc = "Simple rocket nozzle, expelling gas at hypersonic velocities to propell the ship."
	icon = 'icons/obj/ship_engine.dmi'
	icon_state = "nozzle"
	opacity = TRUE
	density = TRUE

/obj/chargen/screen
	name = "status display"
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
/obj/chargen/screen/Initialize()
	.=..()
	set_light(2, 0.5, COLOR_WHITE)
	update_icon()
/obj/chargen/screen/on_update_icon()
	cut_overlays()
	add_overlay(image('icons/obj/status_display.dmi', icon_state="ai_shipscan"))

//
/obj/chargen/status_light
	name = "launch clearance indicator"
	desc = "Will light up green when you're cleared for launch."
	icon = 'icons/obj/machines/door_timer.dmi'
	icon_state = "doortimer1"
	var/completed_chargen = FALSE

/obj/chargen/status_light/Initialize()
	. = ..()
	update_icon()

/obj/chargen/status_light/on_update_icon()
	icon_state = "doortimer[completed_chargen? "2" : "1"]"
	if(completed_chargen)
		set_light(2, 0.5, COLOR_GREEN)
	else
		set_light(1, 0.3, COLOR_RED)

//Indestructible walls
/turf/simulated/wall/chargen
	name = "sturdy wall"
	atom_flags = 0

/turf/simulated/wall/chargen/take_damage()
	return
/turf/simulated/wall/chargen/update_damage()
	return
/turf/simulated/wall/chargen/melt()
	return
/turf/simulated/wall/chargen/dismantle_wall()
	return
/turf/simulated/wall/chargen/explosion_act()
	return
/turf/simulated/wall/chargen/rot()
	return
/turf/simulated/wall/chargen/can_melt()
	return FALSE
/turf/simulated/wall/chargen/burn(temperature)
	return
/turf/simulated/wall/chargen/can_engrave()
	return FALSE
/turf/simulated/wall/chargen/success_smash(mob/user)
	return
/turf/simulated/wall/chargen/try_graffiti()
	return
/turf/simulated/wall/chargen/attackby(obj/item/W, mob/user, click_params)
	// Attack the wall with items
	if(!W.force)
		return TRUE
	if(isliving(user))
		var/mob/living/L = user
		if(L.a_intent == I_HELP)
			return

	user.do_attack_animation(src)
	visible_message(SPAN_DANGER("\The [user] [pick(W.attack_verb)] \the [src] with \the [W], but it had no effect!"))
	playsound(src, hitsound, 25, 1)
	return TRUE
/turf/simulated/wall/chargen/paint_wall(new_paint_color)
	return
/turf/simulated/wall/chargen/stripe_wall(new_paint_color)
	return

//
//Wall types
//
/turf/simulated/wall/chargen/prepainted
	paint_color = COLOR_WALL_GUNMETAL
	stripe_color = COLOR_GUNMETAL

/turf/simulated/wall/chargen/r_wall
	icon_state = "reinforced_solid"
	material = /decl/material/solid/metal/plasteel
	reinf_material = /decl/material/solid/metal/plasteel

/turf/simulated/wall/chargen/r_wall/prepainted
	paint_color = COLOR_WALL_GUNMETAL
	stripe_color = COLOR_GUNMETAL

/turf/simulated/wall/chargen/r_wall/hull
	name = "hull"
	paint_color = COLOR_HULL
	stripe_color = COLOR_HULL

/turf/simulated/wall/chargen/titanium
	color = COLOR_SILVER
	material = /decl/material/solid/metal/titanium

/turf/simulated/wall/chargen/r_titanium
	icon_state = "reinforced_solid"
	material = /decl/material/solid/metal/titanium
	reinf_material = /decl/material/solid/metal/titanium

/turf/simulated/wall/chargen/ocp_wall
	color = COLOR_GUNMETAL
	material = /decl/material/solid/metal/plasteel/ocp
	reinf_material = /decl/material/solid/metal/plasteel/ocp
