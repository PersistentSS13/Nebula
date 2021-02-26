/obj/effect/overmap/visitable/sector/exoplanet/outreach
	name = "\improper Outreach"
	desc = "A mining border-world, home to those lost in space."
	planetary_area = /area/exoplanet/outreach
	daycycle = 25 MINUTES
	daycycle_column_delay = 10 SECONDS
	night = TRUE
	daycolumn = 1

	rock_colors = list(COLOR_GRAY80, COLOR_PALE_GREEN_GRAY, COLOR_PALE_BTL_GREEN)
	plant_colors = list(COLOR_PALE_PINK, COLOR_PALE_GREEN_GRAY, COLOR_CIVIE_GREEN)
	surface_color = COLOR_PALE_GREEN_GRAY
	water_color = COLOR_BOTTLE_GREEN

	ruin_tags_whitelist = RUIN_NATURAL | RUIN_WATER
	features_budget = 0

	has_trees = FALSE
	flora_diversity = 5

	fauna_types = list(/mob/living/simple_animal/thinbug, /mob/living/simple_animal/hostile/retaliate/beast/samak/alt, /mob/living/simple_animal/yithian, /mob/living/simple_animal/tindalos, /mob/living/simple_animal/hostile/retaliate/jelly)
	megafauna_types = list(/mob/living/simple_animal/hostile/retaliate/jelly/mega)


/obj/effect/overmap/visitable/sector/exoplanet/outreach/Initialize(var/mapload, var/z_level)
	. = ..(mapload, GLOB.using_map.station_levels[4])
	docking_codes = "[GLOB.using_map.dock_name]"

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
	generate_planet_image()
	START_PROCESSING(SSobj, src)

/obj/effect/overmap/visitable/sector/exoplanet/outreach/update_daynight()
	var/light = 0.05
	if(!night)
		light = 0.5
	for(var/turf/exterior/T in block(locate(daycolumn, TRANSITIONEDGE, max(map_z)), locate(daycolumn,maxy - TRANSITIONEDGE, max(map_z))))
		T.set_light(light, 0.1, 2)
	daycolumn++
	if(daycolumn > maxx)
		daycolumn = 0
	

/obj/effect/overmap/visitable/sector/exoplanet/outreach/generate_habitability()
	habitability_class = HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/outreach/get_atmosphere_color()
	return COLOR_GREEN_GRAY

/obj/effect/overmap/visitable/sector/exoplanet/outreach/generate_atmosphere()
	atmosphere = new
	atmosphere.adjust_gas(/decl/material/gas/chlorine, MOLES_CELLSTANDARD * 0.17)
	atmosphere.adjust_gas(/decl/material/gas/carbon_dioxide, MOLES_CELLSTANDARD * 0.11)
	atmosphere.adjust_gas(/decl/material/gas/nitrogen, MOLES_CELLSTANDARD * 0.63)
	atmosphere.temperature = T0C + 7
	atmosphere.update_values()