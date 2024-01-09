/datum/planetoid_data/outreach
	id                  = OUTREACH_PLANETOID_ID
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
	day_duration        = 30 MINUTES
	surface_light_level = 0.8
	surface_light_color = COLOR_PALE_GREEN_GRAY
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

/obj/effect/overmap/visitable/sector/planetoid/outreach
	name         = "\proper Outreach"
	desc         = "A rare barren chlorine planet rich in minerals. Now a decrepit mining world."
	start_x      = 27
	start_y      = 23
	color        = "#407c40"
	planetoid_id = OUTREACH_PLANETOID_ID
	sector_flags = OVERMAP_SECTOR_BASE


//////////////////////////////////////////////////////////////////////////
// Mining Stuff
//////////////////////////////////////////////////////////////////////////
/datum/random_map/automata/cave_system/outreach/abyss
	iterations = 5
	descriptor = "outreach abyssal caves"
	wall_type =  /turf/exterior/wall/outreach/abyss
	floor_type = /turf/exterior/volcanic/mining/outreach/abyss
	mineral_turf = /turf/exterior/wall/random/outreach/abyss

/datum/random_map/automata/cave_system/outreach/subterrane
	iterations = 5
	descriptor = "outreach subterrane caves"
	wall_type =  /turf/exterior/wall/outreach/subterrane
	floor_type = /turf/exterior/barren/mining/outreach/subterrane
	mineral_turf = /turf/exterior/wall/random/outreach/subterrane

/datum/random_map/automata/cave_system/outreach/mountain
	iterations = 5
	descriptor = "outreach mountain caves"
	wall_type =  /turf/exterior/wall/outreach/mountain
	floor_type = /turf/exterior/volcanic/mining
	mineral_turf = /turf/exterior/wall/random/outreach/mountain

//////////////////////////////////////////////////////////////////////////
// Strata
//////////////////////////////////////////////////////////////////////////
/decl/strata/outreach/abyssal
	name = "metamorphic rock"
	default_strata_candidate = TRUE
	base_materials = list(
		/decl/material/solid/stone/granite,
		/decl/material/solid/stone/basalt,
		)
	ores_rich = list(
		/decl/material/solid/sphalerite  = 20,
		/decl/material/solid/pitchblende = 30,
		/decl/material/solid/rutile      = 15,
		/decl/material/solid/cassiterite = 20,
		/decl/material/solid/hematite    = 40,
		/decl/material/solid/wolframite  = 25,
		/decl/material/solid/sperrylite  = 20,
		/decl/material/solid/quartz      = 40,
		/decl/material/solid/calaverite  = 10,
		/decl/material/solid/spodumene   = 10,
		/decl/material/solid/graphite    = 20,
		/decl/material/solid/sand        = 10,
	)
	ores_sparse = list(
		/decl/material/solid/densegraphite = 5,
		/decl/material/solid/cinnabar      = 5,
		/decl/material/solid/phosphorite   = 5,
	)

/decl/strata/outreach/subterrane
	name = "igneous rock"
	default_strata_candidate = TRUE
	base_materials = list(
		/decl/material/solid/stone/granite,
		/decl/material/solid/stone/basalt,
		/decl/material/solid/stone/marble,
		/decl/material/solid/stone/slate,
		)
	ores_rich = list(
		/decl/material/solid/sodiumchloride = 20,
		/decl/material/gas/chlorine         = 15,
		/decl/material/solid/stone/basalt   = 20,
		/decl/material/solid/sand           = 10,
		/decl/material/solid/graphite       = 10,
		/decl/material/solid/bauxite        = 10,
		/decl/material/solid/hematite       = 15,
		/decl/material/solid/sphalerite     = 10,
		/decl/material/solid/quartz         = 40,
		/decl/material/solid/galena         = 8,
		/decl/material/solid/spodumene      = 10,
		/decl/material/solid/clay           = 8,
	)
	ores_sparse = list(
		/decl/material/solid/tetrahedrite   = 8,
		/decl/material/solid/hematite       = 5,
		/decl/material/solid/potash         = 5,
		/decl/material/solid/sodium         = 5,
		/decl/material/solid/sodiumchloride = 10,
		/decl/material/solid/sulfur         = 8,
		/decl/material/solid/potassium      = 6,
		/decl/material/solid/phosphorite    = 3,
		/decl/material/solid/cassiterite    = 3,
		/decl/material/solid/cinnabar       = 5,
	)

/decl/strata/outreach/mountain
	name = "mountain rock"
	default_strata_candidate = TRUE
	base_materials = list(
		/decl/material/solid/stone/granite,
		/decl/material/solid/stone/sandstone,
		) //#TODO: Replace me with something less dumb
	ores_rich = list(
		/decl/material/solid/stone/basalt   = 15,
		/decl/material/solid/sodiumchloride = 20,
		/decl/material/solid/sodium         = 15,
		/decl/material/gas/chlorine         = 20,
		/decl/material/solid/hematite       = 5,
		/decl/material/solid/stone/basalt   = 5,
		/decl/material/solid/sand           = 5,
	)
	ores_sparse = list(
		/decl/material/solid/hematite     = 5,
		/decl/material/solid/magnetite    = 4,
		/decl/material/solid/pyrite       = 4,
		/decl/material/solid/potash       = 5,
		/decl/material/solid/chalcopyrite = 2,
		/decl/material/solid/calaverite   = 1,
		/decl/material/solid/phosphorite  = 4,
		/decl/material/solid/cinnabar     = 5,
		/decl/material/solid/spodumene    = 5,
	)
