/datum/planetoid_data/outreach
	id                  = "outreach"
	name                = "\improper Outreach"
	topmost_level_id    = "outreach_sky"
	surface_level_id    = "outreach_surface"
	habitability_class  = HABITABILITY_BAD
	atmosphere          = new /datum/gas_mixture/outreach
	surface_color       = COLOR_PALE_GREEN_GRAY
	water_color         = COLOR_BOTTLE_GREEN
	rock_color          = COLOR_ASTEROID_ROCK
	has_rings           = FALSE
	strata              = /decl/strata/sedimentary
	engraving_generator = new /datum/xenoarch_engraving_flavor
	starts_at_night     = FALSE
	day_duration        = 25 MINUTES
	surface_light_level = 0.8
	surface_light_color = COLOR_GREEN_GRAY
	flora               = /datum/planet_flora/outreach
	fauna               = /datum/fauna_generator/outreach

///////////////////////////////////////
// Outreach Atmosphere
///////////////////////////////////////

/datum/gas_mixture/outreach
	gas = list(
		/decl/material/gas/chlorine = MOLES_CELLSTANDARD * 0.65,
		/decl/material/gas/oxygen   = MOLES_CELLSTANDARD * 0.10,
		/decl/material/gas/nitrogen = MOLES_CELLSTANDARD * 0.25,
	)
/datum/gas_mixture/outreach/New(_volume = CELL_VOLUME, _temperature = 0, _group_multiplier = 1)
	..(CELL_VOLUME, T0C)
	update_values()

///////////////////////////////////////
// Outreach Flora Data
///////////////////////////////////////

/datum/planet_flora/outreach
	grass_color     = "#407c40"
	plant_colors    = list(COLOR_PALE_PINK, COLOR_PALE_GREEN_GRAY, COLOR_CIVIE_GREEN)

///////////////////////////////////////
// Outreach Fauna
///////////////////////////////////////

/datum/fauna_generator/outreach
	fauna_types = list(
		/mob/living/simple_animal/thinbug,
		/mob/living/simple_animal/hostile/retaliate/beast/samak/alt,
		/mob/living/simple_animal/yithian,
		/mob/living/simple_animal/tindalos,
		/mob/living/simple_animal/hostile/retaliate/jelly
	)
	megafauna_types = list(
		/mob/living/simple_animal/hostile/retaliate/jelly/mega
	)

///////////////////////////////////////
// Outreach Overmap Marker
///////////////////////////////////////

/obj/effect/overmap/visitable/sector/planetoid/exoplanet/outreach
	name         = "\proper Outreach"
	desc         = "A rare barren chlorine planet rich in minerals. Now a decrepit mining world."
	start_x      = 27
	start_y      = 23
	color        = "#407c40"
	planetoid_id = "outreach"
	sector_flags = OVERMAP_SECTOR_BASE
