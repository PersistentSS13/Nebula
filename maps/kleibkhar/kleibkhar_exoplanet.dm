#define KLEIBKHAR_GRASS_EDGE_LAYER    (53 * 0.001)
/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar
	name = "\proper Kleibkhar"
	desc = "A habitable border-world, home to a recent dime-a-dozen corporate colony."
	planetary_area = /area/exoplanet/kleibkhar
	lightlevel = 0.6
	daycycle = 25 MINUTES
	daycycle_column_delay = 10 SECONDS
	night = TRUE
	daycolumn = 1

	start_x = 27
	start_y = 23

	color = "#407c40"
	planetary_area = /area/exoplanet/grass
	rock_colors = list(COLOR_ASTEROID_ROCK, COLOR_GRAY80, COLOR_BROWN)
	plant_colors = list("#215a00","#195a47","#5a7467","#9eab88","#6e7248", "RANDOM")
	surface_color = COLOR_DARK_GREEN_GRAY
	water_color = COLOR_BLUE_GRAY
	crust_strata = /decl/strata/base_planet

	ruin_tags_whitelist = RUIN_NATURAL | RUIN_WATER
	features_budget = 0

	has_trees = FALSE

	flora_diversity = 6
	fauna_types = list(/mob/living/simple_animal/yithian, /mob/living/simple_animal/tindalos, /mob/living/simple_animal/hostile/retaliate/jelly)
	megafauna_types = list(/mob/living/simple_animal/hostile/retaliate/parrot/space/megafauna, /mob/living/simple_animal/hostile/retaliate/goose/dire)

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/Initialize(var/mapload, var/z_level)
	. = ..(mapload, global.using_map.station_levels[4])
	docking_codes = "[global.using_map.dock_name]"

	// Build Level workaround
	maxx = world.maxx
	maxy = world.maxy
	x_origin = TRANSITIONEDGE + 1
	y_origin = TRANSITIONEDGE + 1
	x_size = maxx - 2 * (TRANSITIONEDGE + 1)
	y_size = maxy - 2 * (TRANSITIONEDGE + 1)
	landing_points_to_place = min(round(0.1 * (x_size * y_size) / (shuttle_size * shuttle_size)), 3)
	planetary_area = ispath(planetary_area) ? new planetary_area : planetary_area

	generate_habitability()
	generate_atmosphere()
	generate_flora()
	generate_map()
	generate_planet_image()
	START_PROCESSING(SSobj, src)

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/update_daynight()
	var/light = 0.05
	if(!night)
		light = 0.5
	for(var/turf/exterior/T in block(locate(daycolumn, TRANSITIONEDGE, max(map_z)), locate(daycolumn,maxy - TRANSITIONEDGE, max(map_z))))
		T.set_light(light, 0.1, 2)
	daycolumn++
	if(daycolumn > maxx)
		daycolumn = 0

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/generate_planet_image()
	skybox_image = image('icons/skybox/planet.dmi', "")

	skybox_image.overlays += get_base_image()
	
	if(water_color)
		var/image/water = image('icons/skybox/planet.dmi', "water")
		water.color = water_color
		water.appearance_flags = PIXEL_SCALE
		water.transform = water.transform.Turn(45)
		skybox_image.overlays += water
	
	if(atmosphere && atmosphere.return_pressure() > SOUND_MINIMUM_PRESSURE)

		var/atmo_color = get_atmosphere_color()
		if(!atmo_color)
			atmo_color = COLOR_WHITE

		var/image/clouds = image('icons/skybox/planet.dmi', "weak_clouds")

		if(water_color)
			clouds.overlays += image('icons/skybox/planet.dmi', "clouds")

		clouds.color = atmo_color
		skybox_image.overlays += clouds

		var/image/atmo = image('icons/skybox/planet.dmi', "atmoring")
		skybox_image.underlays += atmo
		
	var/image/shadow = image('icons/skybox/planet.dmi', "shadow")
	shadow.blend_mode = BLEND_MULTIPLY
	skybox_image.overlays += shadow

	var/image/light = image('icons/skybox/planet.dmi', "lightrim")
	skybox_image.overlays += light

	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = RESET_COLOR

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/generate_map()
	for(var/zlevel in map_z)
		var/list/edges
		edges += block(locate(1, 1, zlevel), locate(TRANSITIONEDGE, maxy, zlevel))
		edges |= block(locate(maxx-TRANSITIONEDGE, 1, zlevel),locate(maxx, maxy, zlevel))
		edges |= block(locate(1, 1, zlevel), locate(maxx, TRANSITIONEDGE, zlevel))
		edges |= block(locate(1, maxy-TRANSITIONEDGE, zlevel),locate(maxx, maxy, zlevel))
		for(var/turf/T in edges)
			T.ChangeTurf(/turf/exterior/planet_edge)

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/generate_habitability()
	habitability_class = HABITABILITY_IDEAL

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/get_atmosphere_color()
	return COLOR_OFF_WHITE

/turf/exterior/kleibkhar_grass
	name = "wild grass"
	icon = 'icons/turf/exterior/wildgrass.dmi'
	icon_edge_layer = KLEIBKHAR_GRASS_EDGE_LAYER
	icon_has_corners = TRUE
	color = "#799c4b"
	footstep_type = /decl/footsteps/grass

/turf/exterior/kleibkhar_grass/Initialize()
	. = ..()
	if(global.using_map.use_overmap)
		var/obj/effect/overmap/visitable/sector/exoplanet/E = map_sectors["[z]"]
		if(istype(E) && E.grass_color)
			color = E.grass_color

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