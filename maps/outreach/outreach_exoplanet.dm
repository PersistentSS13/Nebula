/obj/effect/overmap/visitable/sector/exoplanet/outreach
	name = "\improper Outreach"
	desc = "A mining border-world, home to those lost in space."
	planetary_area = /area/exoplanet/outreach
	daycycle = 25 MINUTES
	daycycle_column_delay = 10 SECONDS
	night = TRUE

	rock_colors = list(COLOR_GRAY80, COLOR_PALE_GREEN_GRAY, COLOR_PALE_BTL_GREEN)
	plant_colors = list(COLOR_PALE_PINK, COLOR_PALE_GREEN_GRAY, COLOR_CIVIE_GREEN)
	surface_color = COLOR_PALE_GREEN_GRAY
	water_color = COLOR_BOTTLE_GREEN
	crust_strata = /decl/strata/sedimentary

	features_budget = 0
	has_trees = FALSE
	flora_diversity = 5

	fauna_types = list(/mob/living/simple_animal/thinbug, /mob/living/simple_animal/hostile/retaliate/beast/samak/alt, /mob/living/simple_animal/yithian, /mob/living/simple_animal/tindalos, /mob/living/simple_animal/hostile/retaliate/jelly)
	megafauna_types = list(/mob/living/simple_animal/hostile/retaliate/jelly/mega)


/obj/effect/overmap/visitable/sector/exoplanet/outreach/Initialize(mapload, z_level)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/overmap/visitable/sector/exoplanet/outreach/LateInitialize()
	. = ..()
	build_level()
	name = initial(name)

/obj/effect/overmap/visitable/sector/exoplanet/outreach/select_strata()
	return

/obj/effect/overmap/visitable/sector/exoplanet/outreach/generate_landing()
	return

/obj/effect/overmap/visitable/sector/exoplanet/outreach/generate_features()
	return

/obj/effect/overmap/visitable/sector/exoplanet/outreach/get_target_temperature()
	return T0C

/obj/effect/overmap/visitable/sector/exoplanet/outreach/generate_habitability()
	habitability_class = HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/outreach/get_atmosphere_color()
	return COLOR_GREEN_GRAY
