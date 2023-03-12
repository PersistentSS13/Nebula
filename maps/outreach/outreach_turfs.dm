///////////////////////////////////////////////////////////////////////////////////
// Airless Floors
///////////////////////////////////////////////////////////////////////////////////
/turf/simulated/floor/tiled/techfloor/grid/airless
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/tiled/techfloor/airless
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/tiled/steel_ridged/airless
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/tiled/dark/monotile/airless
	initial_gas = null
	temperature = TCMB

///////////////////////////////////////////////////////////////////////////////////
// Outreach Atmos Floors
///////////////////////////////////////////////////////////////////////////////////

/turf/simulated/floor/tiled/techfloor/grid/outreach
	initial_gas = OUTREACH_ATMOS
	temperature = OUTREACH_TEMP

/turf/simulated/floor/tiled/techfloor/outreach
	initial_gas = OUTREACH_ATMOS
	temperature = OUTREACH_TEMP

/turf/simulated/floor/tiled/steel_ridged/outreach
	initial_gas = OUTREACH_ATMOS
	temperature = OUTREACH_TEMP

/turf/simulated/floor/tiled/dark/monotile/outreach
	initial_gas = OUTREACH_ATMOS
	temperature = OUTREACH_TEMP

/turf/simulated/floor/plating/outreach
	initial_gas = OUTREACH_ATMOS
	temperature = OUTREACH_TEMP

/turf/simulated/floor/asteroid/outreach
	initial_gas          = OUTREACH_ATMOS
	temperature          = OUTREACH_TEMP
	heat_capacity        = 80000
	thermal_conductivity = 0.005
	open_turf_type       = /turf/simulated/open

///////////////////////////////////////////////////////////////////////////////////
// Painted walls
///////////////////////////////////////////////////////////////////////////////////
/turf/simulated/wall/ocp_wall/prepainted
	paint_color    = COLOR_GUNMETAL
	stripe_color   = COLOR_AMBER
	material       = /decl/material/solid/metal/plasteel/ocp
	reinf_material = /decl/material/solid/metal/plasteel/ocp

/turf/simulated/wall/prepainted/medbay
	color        = COLOR_PALE_BLUE_GRAY
	stripe_color = COLOR_PALE_BLUE_GRAY
	paint_color  = null

/turf/simulated/wall/prepainted/engineering
	color        = COLOR_AMBER
	stripe_color = COLOR_AMBER

/turf/simulated/wall/prepainted/atmos
	color        = COLOR_CYAN
	stripe_color = COLOR_CYAN

/turf/simulated/wall/prepainted/mining
	color        = COLOR_BEASTY_BROWN
	stripe_color = COLOR_BEASTY_BROWN

///////////////////////////////////////////////////////////////////////////////////
// Painted Conrete Walls
///////////////////////////////////////////////////////////////////////////////////
/turf/simulated/wall/concrete/prepainted/medbay
	color        = COLOR_PALE_BLUE_GRAY
	stripe_color = COLOR_PALE_BLUE_GRAY
	paint_color  = null

/turf/simulated/wall/concrete/prepainted/mining
	color        = COLOR_BEASTY_BROWN
	stripe_color = COLOR_BEASTY_BROWN

///////////////////////////////////////////////////////////////////////////////////
// Painted Reinforced Walls
///////////////////////////////////////////////////////////////////////////////////
/turf/simulated/wall/r_wall/prepainted/engineering
	color        = COLOR_AMBER
	stripe_color = COLOR_AMBER

/turf/simulated/wall/r_wall/prepainted/atmos
	color        = COLOR_CYAN
	stripe_color = COLOR_CYAN

/turf/simulated/wall/r_wall/prepainted/security
	color        = COLOR_NT_RED
	stripe_color = COLOR_NT_RED

/turf/simulated/wall/r_wall/prepainted/command
	color        = COLOR_COMMAND_BLUE
	stripe_color = COLOR_COMMAND_BLUE

///////////////////////////////////////////////////////////////////////////////////
// Underground Turfs
///////////////////////////////////////////////////////////////////////////////////

//Underground Outpost Rock Floors
/turf/simulated/floor/volcanic/outreach
	name = "igneous rock floor"
	open_turf_type = /turf/simulated/open

//Outpost Rock Walls
/turf/exterior/wall/outreach/mountain
	name = "weathered sandstone wall"
	strata   = /decl/strata/outreach/mountain
	material = /decl/material/solid/stone/sandstone
	floor_type = /turf/simulated/floor/asteroid/outreach
	open_turf_type = /turf/simulated/open

/turf/exterior/wall/outreach/subterrane
	name = "erroded sandstone wall"
	strata = /decl/strata/outreach/subterrane
	material = /decl/material/solid/stone/sandstone
	floor_type = /turf/simulated/floor/asteroid/outreach
	open_turf_type = /turf/simulated/open

/turf/exterior/wall/outreach/abyss
	name = "compacted slate wall"
	strata   = /decl/strata/outreach/abyssal
	material = /decl/material/solid/stone/slate
	floor_type = /turf/simulated/floor/volcanic/outreach
	open_turf_type = /turf/simulated/magma

///////////////////////////////////////////////////////////////////////////////////
// Mining Turfs
///////////////////////////////////////////////////////////////////////////////////
//Mining Floors
/turf/exterior/barren/mining/outreach/mountain
	color = "#d9c179"
	open_turf_type = /turf/exterior/open

/turf/exterior/barren/mining/outreach/subterrane
	color = "#d9c179"
	open_turf_type = /turf/exterior/open

/turf/exterior/volcanic/mining/outreach/abyss
	open_turf_type = /turf/exterior/open

//Mining Walls
/turf/exterior/wall/random/outreach/mountain
	strata = /decl/strata/outreach/mountain
	material = /decl/material/solid/stone/sandstone
	floor_type = /turf/exterior/barren/mining/outreach/mountain

/turf/exterior/wall/random/outreach/subterrane
	strata = /decl/strata/outreach/subterrane
	material = /decl/material/solid/stone/sandstone
	floor_type = /turf/exterior/barren/mining/outreach/subterrane

/turf/exterior/wall/random/outreach/abyss
	strata   = /decl/strata/outreach/abyssal
	material = /decl/material/solid/stone/slate
	floor_type = /turf/exterior/volcanic/mining/outreach/abyss

///////////////////////////////////////////////////////////////////////////////////
// Surface Turfs
///////////////////////////////////////////////////////////////////////////////////
//Just some pre-reserved types for later modifications
/turf/exterior/barren/outreach
	name = "ground"

/turf/exterior/wall/outreach
	name           = "erroded wall"
	open_turf_type = /turf/exterior/barren/outreach //Don't allow just removing this easily
	floor_type     = /turf/exterior/barren/outreach

/turf/exterior/chlorine_sand/outreach
	name           = "chlorine salts"
	open_turf_type = /turf/exterior/barren/outreach //Don't allow just removing this easily

/turf/exterior/water/outreach
	name           = "muriatic acid swamp"
	reagent_type   = /decl/material/liquid/acid/hydrochloric
	open_turf_type = /turf/exterior/chlorine_sand/outreach //Don't allow just removing this easily

/turf/exterior/barren/subterrane
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

/turf/exterior/barren/subterrane/outreach
	open_turf_type = /turf/exterior/open

/turf/exterior/volcanic/outreach/abyss
	open_turf_type = /turf/simulated/magma

///////////////////////////////////////////////////////////////////////////////////
// Turf Initializers
///////////////////////////////////////////////////////////////////////////////////

//This is run during setup to place random props on some of the outreach turfs
/decl/turf_initializer/outreach_surface
	var/list/surface_props_probs = list(
		/obj/effect/decal/cleanable/lichen = 40,
		/obj/effect/decal/cleanable/ash    = 20,
		/obj/structure/boulder             = 30,
		/obj/structure/leech_spawner       = 5,
	)
	var/list/underwater_props_probs = list(
		/obj/structure/flora/seaweed/glow  = 5,
		/obj/structure/flora/seaweed/large = 10,
		/obj/structure/flora/seaweed/mid   = 20,
		/obj/structure/flora/seaweed       = 40
	)
	var/list/mob_probs = list(
		/mob/living/simple_animal/hostile/slug                 = 1,
		/mob/living/simple_animal/hostile/retaliate/giant_crab = 3,
	)
	var/list/underwater_mob_probs = list(
		/mob/living/simple_animal/hostile/retaliate/giant_crab = 3,
	)
	var/list/allowed_turfs = list(
		/turf/exterior/barren,
		/turf/exterior/chlorine_sand,
		/turf/exterior/water/outreach,
	)

/decl/turf_initializer/outreach_surface/InitializeTurf(var/turf/exterior/T)
	if(!istype(T) || T.density)
		return
	if(!is_type_in_list(T, allowed_turfs))
		return
	//Don't place anything here, if there's anything on the turf already
	if(locate(/obj, T))
		return

	var/list/possible_spawns = istype(T, /turf/exterior/water)? (underwater_props_probs|underwater_mob_probs) : (surface_props_probs|mob_probs)
	if(rand(0, 50) != 50)
		return //No prop for this tile

	for(var/path in possible_spawns)
		possible_spawns[path] = rand(0, possible_spawns[path])
	sortTim(possible_spawns, .proc/cmp_numeric_dsc, TRUE)
	var/spawn_type = possible_spawns[1]
	new spawn_type(T)
