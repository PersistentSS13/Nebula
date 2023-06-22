/obj/effect/overmap/visitable/sector/smashed_nexus
	name = "\proper Smashed Nexus"
	desc = "The scattered ruins of a once great space station."
	start_x = 18
	start_y = 46
	color = "#0d017a"
	icon = 'icons/misc/overmap_icons.dmi'
	icon_state = "nexus_derelict"

/obj/effect/overmap/visitable/sector/free_space
	name = "\proper Free Space"
	desc = "This space is provided by corporate interests for the free use of Frontier Colonists."
	start_x = 21
	start_y = 19
	color = "#ff0000"
	icon = 'icons/misc/overmap_icons.dmi'
	icon_state = "vig_derelict"

/obj/effect/overmap/visitable/sector/smuggler_haven
	name = "\proper Smuggler Haven"
	desc = "This gravity well has been used by criminal interests in the past."
	start_x = 20
	start_y = 9
	color = "#050101"
	icon = 'icons/misc/overmap_icons.dmi'
	icon_state = "vig_derelict"

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar
	name = "\proper Xanadu"
	desc = "The first stop for most colonists coming into the Frontier."
	daycycle = 25 MINUTES
	daycycle_column_delay = 10 SECONDS
	night = FALSE

	start_x = 16
	start_y = 33

	color = "#edf102"
	grass_color = "#80940c"
	planetary_area = /area/exoplanet/kleibkhar
	rock_colors = list(COLOR_ASTEROID_ROCK, COLOR_GRAY80, COLOR_BROWN)
	plant_colors = list("#07ac59","#195a47","#5a7467","#9eab88","#6e7248", "RANDOM")
	surface_color = COLOR_DARK_GREEN_GRAY
	water_color = COLOR_BLUE_GRAY
	crust_strata = /decl/strata/base_planet

	ruin_tags_whitelist = RUIN_NATURAL | RUIN_WATER
	features_budget = 0

	has_trees = FALSE

	flora_diversity = 6
	fauna_types = list(/mob/living/simple_animal/yithian, /mob/living/simple_animal/tindalos, /mob/living/simple_animal/hostile/retaliate/jelly)
	megafauna_types = list(/mob/living/simple_animal/hostile/retaliate/parrot/space/megafauna, /mob/living/simple_animal/hostile/retaliate/goose/dire)
	possible_themes = null

	preset_map_z = list(3)

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/Initialize(mapload, z_level)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/LateInitialize()
	. = ..()
	build_level()
	name = initial(name)

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/select_strata()
	return

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/generate_landing()
	return

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/generate_features()
	return

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/generate_habitability()
	habitability_class = HABITABILITY_IDEAL

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/get_atmosphere_color()
	return COLOR_OFF_WHITE

/obj/effect/overmap/visitable/sector/exoplanet/kleibkhar/get_target_temperature()
	return T20C + 8 //Warm-ish