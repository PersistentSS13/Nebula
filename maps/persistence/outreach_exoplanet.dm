/obj/effect/overmap/visitable/sector/exoplanet/outreach
	name = "\improper Outreach"
	desc = "A mining border-world, home to those lost in space."
	planetary_area = /area/exoplanet/outreach
	map_generators = list(/datum/random_map/noise/outreach)

	possible_themes = list()
	ruin_tags_blacklist = RUIN_HABITAT | RUIN_HUMAN | RUIN_ALIEN | RUIN_WRECK | RUIN_NATURAL | RUIN_WATER
	surface_color = COLOR_DARK_GREEN_GRAY

	flora_diversity = 0

/obj/effect/overmap/visitable/sector/exoplanet/outreach/Initialize(mapload, z_level)
	. = ..()
	build_level()
	name = initial(name)

/obj/effect/overmap/visitable/sector/exoplanet/outreach/find_z_levels()
	map_z = GLOB.using_map.station_levels

/obj/effect/overmap/visitable/sector/exoplanet/outreach/generate_habitability()
	habitability_class = HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/outreach/generate_atmosphere()
	atmosphere = new
	atmosphere.adjust_gas(MAT_CHLORINE, MOLES_CELLSTANDARD * 0.15)
	atmosphere.temperature = (T0C - 20)
	atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/outreach/handle_atmosphere()
	map_z = difflist(GLOB.using_map.station_levels, GLOB.using_map.mining_areas)
	. = ..()
	map_z = GLOB.using_map.station_levels
	
/datum/random_map/noise/outreach
	descriptor = "outreach exoplanet"
	smoothing_iterations = 1
	target_turf_type = /turf/unsimulated/mask

/datum/random_map/noise/outreach/proc/is_edge_turf(turf/T)
	return T.x <= TRANSITIONEDGE || T.x >= (limit_x - TRANSITIONEDGE + 1) || T.y <= TRANSITIONEDGE || T.y >= (limit_y - TRANSITIONEDGE + 1)

/datum/random_map/noise/outreach/get_additional_spawns(value, turf/T)
	if(is_edge_turf(T))
		return
	if(T.contains_dense_objects())
		T.ChangeTurf(/turf/simulated/floor/exoplanet/outreach)
		return
	// Value is 0 .. 255, parsed is 0 .. 9
	var/parsed_value = min(9,max(0,round((value/cell_range)*10)))
	switch(parsed_value)
		if(0 to 2)
			T.ChangeTurf(/turf/simulated/wall/natural/volcanic/outreach)
		if(3 to 9)
			T.ChangeTurf(/turf/simulated/floor/exoplanet/outreach)

/area/exoplanet/outreach
	name = "\improper Outreach Planetary surface"
	ambience = list('sound/ambience/spookyspace2.ogg', 'sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg')
	base_turf = /turf/simulated/floor/exoplanet

/turf/simulated/floor/exoplanet/outreach
	name = "cracked ground"
	icon = 'icons/turf/floors.dmi'
	icon_state = "outreach"

/turf/simulated/wall/natural/volcanic/outreach
	floor_type = /turf/simulated/floor/exoplanet/outreach

/turf/simulated/floor/exoplanet/outreach/Initialize()
	. = ..()
	update_icon()

/turf/simulated/floor/exoplanet/outreach/on_update_icon()
	overlays.Cut()
	if(prob(20))
		overlays += image('icons/turf/flooring/decals.dmi', "asteroid[rand(0,9)]")
