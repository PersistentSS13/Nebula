/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar
	name = "\proper Kleibkhar"
	desc = "A habitable border-world, home to a recent dime-a-dozen corporate colony."
	daycycle = 25 MINUTES
	daycycle_column_delay = 10 SECONDS
	night = FALSE
	daycolumn = 1

	start_x = 27
	start_y = 23

	color = "#407c40"
	grass_color = "#407c40"
	planetary_area = /area/exoplanet/kleibkhar
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
	. = ..()
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

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/get_target_temperature()
	return T20C + 8 //Warm-ish