/////////////////////////////////////////////////////////////
//Indestructible walls
/////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////
// Wall types
/////////////////////////////////////////////////////////////
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
