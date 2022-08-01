#define KLEIBKHAR_GRASS_EDGE_LAYER  0.053
#define KLEIBKHAR_VEGETATION_CHANCE 10 //1 in 10 chance of spawning vegetation/props

/turf/exterior/kleibkhar_grass
	name = "wild grass"
	icon = 'icons/turf/exterior/wildgrass.dmi'
	icon_edge_layer = KLEIBKHAR_GRASS_EDGE_LAYER
	icon_has_corners = TRUE
	color = "#799c4b"
	footstep_type = /decl/footsteps/grass

/turf/exterior/kleibkhar_grass/Initialize()
	. = ..()
	var/obj/effect/overmap/visitable/sector/exoplanet/E = global.overmap_sectors["[z]"]
	if(istype(E) && E.grass_color)
		color = E.grass_color
	
	// Turfs don't retain persistent IDs across load currently, so we just check if we're in a loaded world instead.
	if(!SSpersistence.in_loaded_world)
		generate_tile_prop()

/turf/exterior/kleibkhar_grass/proc/generate_tile_prop()
	if(rand(0, KLEIBKHAR_VEGETATION_CHANCE) != KLEIBKHAR_VEGETATION_CHANCE)
		return //No vegetation/prop for this tile
	
	var/list/rnd = list(\
		"plant"  = rand(0,  80),\
		"rock"   = rand(0,  25),\
		"dirt"   = rand(0,  50),\
		"lichen" = rand(0,  80),\
	)
	sortTim(rnd, .proc/cmp_numeric_dsc, TRUE)

	var/obj/prop
	switch(rnd[1])
		if("plant")
			prop = new /obj/structure/flora/grass/green(src)
		if("rock")
			prop = new /obj/structure/boulder(src)
		if("dirt")
			prop = new /obj/effect/decal/cleanable/dirt(src)
		if("lichen")
			prop = new /obj/effect/decal/cleanable/lichen(src)
	
	prop.pixel_x += rand(-8, 8)
	prop.pixel_y += rand(-8, 8)


/turf/exterior/kleibkhar_grass/attackby(obj/item/W, mob/user, click_params)
	. = ..()
	if(istype(W, /obj/item/minihoe))
		if(!user.skill_check(SKILL_BOTANY, SKILL_ADEPT))
			to_chat(user, SPAN_WARNING("You can't tell the grass from any useful plants!"))
			return TRUE
		to_chat(user, SPAN_NOTICE("You begin cutting through \the [src] in search of seeds."))
		if(do_after(user,40, src))
			if(prob(80))
				to_chat(user, SPAN_NOTICE("You weren't able to find any seeds!"))
				return TRUE
			var/rand_path = pick(subtypesof(/obj/item/seeds))
			var/rand_seeds = new rand_path(src)
			user.put_in_hands(rand_seeds)
			to_chat(user, SPAN_NOTICE("You manage to locate and package some seeds!"))
		return TRUE

/turf/exterior/kleibkhar_grass/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if((temperature > T0C + 200 && prob(5)) || temperature > T0C + 1000)
		melt()

/turf/exterior/kleibkhar_grass/melt()
	if(icon_state != "scorched")
		SetName("scorched ground")
		icon_state = "scorched"
		icon_edge_layer = -1
		footstep_type = /decl/footsteps/asteroid
		color = null

#undef KLEIBKHAR_GRASS_EDGE_LAYER
#undef KLEIBKHAR_VEGETATION_CHANCE