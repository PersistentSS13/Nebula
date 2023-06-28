/datum/planetoid_data/kleibkhar
	id                  = "kleibkhar"
	name                = "\improper kleibkhar"
	topmost_level_id    = "kleibkhar_sky"
	surface_level_id    = "kleibkhar_surface"
	habitability_class  = HABITABILITY_IDEAL
	atmosphere          = new /datum/gas_mixture/kleibkhar
	surface_color       = COLOR_DARK_GREEN_GRAY
	water_color         = COLOR_BLUE_GRAY
	rock_color          = COLOR_ASTEROID_ROCK
	has_rings           = FALSE
	strata              = /decl/strata/base_planet
	engraving_generator = new /datum/xenoarch_engraving_flavor
	starts_at_night     = FALSE
	day_duration        = 25 MINUTES
	surface_light_level = 0.8
	surface_light_color = COLOR_WHITE
	flora               = /datum/planet_flora/kleibkhar
	fauna               = /datum/fauna_generator/kleibkhar

///////////////////////////////////////
// Kleibkhar Atmosphere
///////////////////////////////////////

/datum/gas_mixture/kleibkhar
	gas = list(
		/decl/material/gas/oxygen =   MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD,
	)
/datum/gas_mixture/kleibkhar/New(_volume = CELL_VOLUME, _temperature = 0, _group_multiplier = 1)
	..(CELL_VOLUME, T20C + 8)
	update_values()

///////////////////////////////////////
// Kelibkhar Flora Data
///////////////////////////////////////

/datum/planet_flora/kleibkhar
	grass_color       = "#407c40"
	plant_colors      = list("#215a00","#195a47","#5a7467","#9eab88","#6e7248", "RANDOM")

///////////////////////////////////////
// Kleibkhar Fauna
///////////////////////////////////////

/datum/fauna_generator/kleibkhar
	fauna_types = list(
		/mob/living/simple_animal/yithian,
		/mob/living/simple_animal/tindalos,
		/mob/living/simple_animal/hostile/retaliate/jelly
	)
	megafauna_types = list(
		/mob/living/simple_animal/hostile/retaliate/parrot/space/megafauna,
		/mob/living/simple_animal/hostile/retaliate/goose/dire
	)

///////////////////////////////////////
// Kleibkhar Overmap Marker
///////////////////////////////////////

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/kleibkhar
	name         = "\proper Kleibkhar"
	desc         = "A habitable border-world, home to a recent dime-a-dozen corporate colony."
	start_x      = 27
	start_y      = 23
	color        = "#407c40"
	planetoid_id = "kleibkhar"
	sector_flags = OVERMAP_SECTOR_BASE
