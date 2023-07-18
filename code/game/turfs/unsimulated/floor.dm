/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "Floor3"
	turf_flags = TURF_IS_HOLOMAP_PATH

/turf/unsimulated/floor/can_climb_from_below(var/mob/climber)
	return TRUE

/turf/unsimulated/floor/infinity //non-doomsday version for transit and wizden
	name = "\proper infinity"
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespace"
	desc = "Looks like eternity."

/turf/unsimulated/mask
	name = "mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"

/turf/unsimulated/floor/rescue_base
	icon_state = "asteroidfloor"

/turf/unsimulated/floor/shuttle_ceiling
	icon_state = "reinforced"


//
// Tiled stuff
//
/turf/unsimulated/floor/tiled
	icon = 'icons/turf/flooring/tiles.dmi'

/turf/unsimulated/floor/tiled/dark
	name = "dark floor"
	icon_state = "dark"

/turf/unsimulated/floor/tiled/dark/monotile
	name = "floor"
	icon_state = "monotiledark"

/turf/unsimulated/floor/tiled/dark/airless
	initial_gas = null
	temperature = TCMB

/turf/unsimulated/floor/tiled/white
	name = "white floor"
	icon_state = "white"

/turf/unsimulated/floor/tiled/white/monotile
	name = "floor"
	icon_state = "monotile"

/turf/unsimulated/floor/tiled/white/airless
	initial_gas = null
	temperature = TCMB

/turf/unsimulated/floor/tiled/freezer
	name = "tiles"
	icon_state = "freezer"

/turf/unsimulated/floor/tiled/monofloor
	icon_state = "monofloor"
/turf/unsimulated/floor/tiled/monotile
	icon_state = "steel_monotile"

/turf/unsimulated/floor/tiled/techmaint
	icon_state = "techmaint"
/turf/unsimulated/floor/tiled/techfloor
	icon_state = "techfloor_gray"

/turf/unsimulated/floor/tiled/steel_grid
	icon_state = "steel_grid"

/turf/unsimulated/floor/tiled/steel_ridged
	icon_state = "steel_ridged"

/turf/unsimulated/floor/tiled/old_tile
	icon_state = "tile_full"

/turf/unsimulated/floor/tiled/old_cargo
	icon_state = "cargo_one_full"

/turf/unsimulated/floor/tiled/kafel_full
	icon_state = "kafel_full"

/turf/unsimulated/floor/tiled/stone
	name = "stone slab floor"
	icon_state = "stone_full"

/turf/unsimulated/floor/tiled/techfloor/grid
	icon_state = "techfloor_grid"

/turf/unsimulated/floor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"

/turf/unsimulated/floor/crystal
	name = "crystal floor"
	icon = 'icons/turf/flooring/crystal.dmi'
	icon_state = ""