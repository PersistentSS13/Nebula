/decl/strata/base_planet
	name = "planetary crust strata"
	base_materials = list(/decl/material/solid/stone/sandstone)
	ores_sparse = list(
		/decl/material/solid/mineral/graphite = 10,
		/decl/material/solid/mineral/hematite = 25,
		/decl/material/solid/mineral/sand = 5,
		/decl/material/solid/mineral/sodiumchloride = 5,
		/decl/material/solid/mineral/pyrite = 10,
		/decl/material/solid/mineral/quartz = 5,
		/decl/material/solid/mineral/clay = 10,
		/decl/material/solid/mineral/magnetite = 10,
		/decl/material/solid/mineral/chalcopyrite = 20,
		/decl/material/solid/mineral/sphalerite = 5,
		/decl/material/solid/mineral/cassiterite = 5,
		/decl/material/solid/mineral/potash = 5,
		/decl/material/solid/mineral/potassium = 5,
		/decl/material/solid/mineral/cinnabar = 3,
		/decl/material/solid/mineral/spodumene = 3,
		/decl/material/solid/ice/aspium = 2,
		/decl/material/solid/ice/ediroite = 2,
		/decl/material/solid/ice/lukrite = 2,
		/decl/material/solid/ice/trigarite = 2
	)
	ores_rich = list(
		/decl/material/solid/mineral/hematite = 20,
		/decl/material/solid/mineral/pitchblende = 10,
		/decl/material/solid/mineral/chalcopyrite = 20,
		/decl/material/solid/mineral/tetrahedrite = 5,
		/decl/material/solid/mineral/wolframite = 5,
		/decl/material/solid/mineral/galena = 5,
		/decl/material/solid/mineral/sperrylite = 3,
		/decl/material/solid/mineral/calaverite = 2,
		/decl/material/solid/ice/lukrite = 3,
		/decl/material/solid/ice/trigarite = 3,
		/decl/material/solid/ice/hydrate/hydrogen = 2,
		/decl/material/solid/ice/hydrate/oxygen = 2
	)

/decl/strata/asteroid/is_valid_exoplanet_strata()
	return FALSE

/decl/strata/asteroid/iron
	name = "iron-rich spaceborne rock"
	base_materials = list(/decl/material/stone/asteroid)
	ores_sparse = list(
		/decl/material/solid/mineral/hematite = 20,
		/decl/material/solid/mineral/magnetite = 60,
		/decl/material/solid/mineral/pyrite = 20,
		/decl/material/solid/mineral/cinnabar = 5,
		/decl/material/solid/mineral/phosphorite = 10,
	)
	ores_rich = list(
		/decl/material/solid/metal/gold = 5,
		/decl/material/solid/metal/silver = 3,
		/decl/material/solid/mineral/magnetite = 50,
		/decl/material/solid/mineral/cinnabar = 10,
	)

/decl/strata/asteroid/carbon
	name = "carbon-rich spaceborne rock"
	base_materials = list(/decl/material/stone/asteroid)
	ores_sparse = list(
		/decl/material/solid/mineral/hematite = 10,
		/decl/material/solid/mineral/pitchblende = 5,
		/decl/material/solid/mineral/graphite = 60,
		/decl/material/solid/mineral/quartz = 10,
		/decl/material/solid/mineral/sand = 30,
		/decl/material/solid/mineral/potash = 10
	)
	ores_rich = list(
		/decl/material/solid/mineral/hematite = 25,
		/decl/material/solid/mineral/pitchblende = 10,
		/decl/material/solid/mineral/graphite = 50,
		/decl/material/solid/mineral/quartz = 10,
		/decl/material/solid/mineral/potash = 15,
		/decl/material/solid/gemstone/diamond = 1
	)

/decl/strata/asteroid/copper
	name = "copper-rich spaceborne rock"
	base_materials = list(/decl/material/stone/asteroid)
	ores_sparse = list(
		/decl/material/solid/mineral/hematite = 5,
		/decl/material/solid/mineral/rutile = 2,
		/decl/material/solid/mineral/graphite = 5,
		/decl/material/solid/mineral/chalcopyrite = 60,
		/decl/material/solid/mineral/tetrahedrite = 35,
		/decl/material/solid/mineral/sodiumchloride = 5
	)
	ores_rich = list(
		/decl/material/solid/mineral/hematite = 10,
		/decl/material/solid/mineral/rutile = 5,
		/decl/material/solid/mineral/graphite = 5,
		/decl/material/solid/mineral/chalcopyrite = 25,
		/decl/material/solid/mineral/tetrahedrite = 50
	)

/decl/strata/asteroid/dense
	name = "dense spaceborne rock"
	base_materials = list(/decl/material/stone/asteroid)
	ores_sparse = list(
		/decl/material/solid/mineral/cassiterite = 50,
		/decl/material/solid/mineral/galena = 25,
		/decl/material/solid/mineral/hematite = 10,
		/decl/material/solid/mineral/rutile = 5,
		/decl/material/solid/mineral/pitchblende = 5
	)
	ores_rich = list(
		/decl/material/solid/mineral/cassiterite = 20,
		/decl/material/solid/mineral/wolframite = 10,
		/decl/material/solid/mineral/hematite = 5,
		/decl/material/solid/mineral/pitchblende = 10
	)

/decl/strata/asteroid/shimmering
	name = "shimmering spaceborne rock"
	base_materials = list(/decl/material/stone/asteroid)
	ores_sparse = list(
		/decl/material/solid/mineral/quartz = 15,
		/decl/material/solid/mineral/pyrite = 60,
		/decl/material/solid/mineral/spodumene = 20,
		/decl/material/solid/mineral/potash = 10,
		/decl/material/solid/mineral/crocoite = 20
	)
	ores_rich = list(
		/decl/material/solid/mineral/quartz = 5,
		/decl/material/solid/mineral/pyrite = 25,
		/decl/material/solid/mineral/spodumene = 5,
		/decl/material/solid/mineral/potash = 5,
		/decl/material/solid/mineral/sperrylite = 10,
		/decl/material/solid/mineral/calaverite = 7,
		/decl/material/solid/mineral/crocoite = 10,
		/decl/material/solid/metal/gold = 2
	)

/decl/strata/asteroid/rich
	name = "mineral rich spaceborne rock"
	base_materials = list(/decl/material/stone/asteroid)
	ores_sparse = list(
		/decl/material/solid/mineral/magnetite = 20,
		/decl/material/solid/metal/gold = 5,
		/decl/material/solid/mineral/sperrylite = 20,
		/decl/material/solid/mineral/calaverite = 15,
		/decl/material/solid/mineral/crocoite = 20
	)
	ores_rich = list(
		/decl/material/solid/mineral/magnetite = 5,
		/decl/material/solid/metal/gold = 10,
		/decl/material/solid/mineral/sperrylite = 20,
		/decl/material/solid/mineral/calaverite = 20,
		/decl/material/solid/gemstone/diamond = 3
	)

/decl/strata/comet/is_valid_exoplanet_strata(obj/effect/overmap/visitable/sector/exoplanet/planet)
	return FALSE

/decl/strata/comet/liquid
	name = "liquid rich space-borne ice"
	base_materials = list(/decl/material/solid/ice)
	ores_sparse = list(
		/decl/material/solid/ice/aspium = 10,
		/decl/material/solid/ice/lukrite = 15,
		/decl/material/solid/ice/rubenium = 5,
		/decl/material/solid/ice/trigarite = 5,
		/decl/material/solid/ice/ediroite = 10
	)
	ores_rich = list(
		/decl/material/solid/ice/aspium = 15,
		/decl/material/solid/ice/lukrite = 10,
		/decl/material/solid/ice/rubenium = 10,
		/decl/material/solid/ice/trigarite = 5,
		/decl/material/solid/ice/ediroite = 5,
		/decl/material/solid/ice/hydrate/hydrogen = 5,
		/decl/material/solid/ice/hydrate/oxygen = 5,
		/decl/material/solid/ice/hydrate/carbon_dioxide = 5
	)

/decl/strata/comet/gas
	name = "gas rich space-borne ice"
	base_materials = list(/decl/material/solid/ice)
	ores_sparse = list(
		/decl/material/solid/ice/hydrate/hydrogen = 10,
		/decl/material/solid/ice/hydrate/methane = 5,
		/decl/material/solid/ice/hydrate/oxygen = 25,
		/decl/material/solid/ice/hydrate/nitrogen = 10,
		/decl/material/solid/ice/lukrite = 15
	)
	ores_rich = list(
		/decl/material/solid/ice/aspium = 5,
		/decl/material/solid/ice/rubenium = 10,
		/decl/material/solid/ice/trigarite = 5,
		/decl/material/solid/ice/hydrate/hydrogen = 15,
		/decl/material/solid/ice/hydrate/oxygen = 10,
		/decl/material/solid/ice/hydrate/argon = 5,
		/decl/material/solid/ice/hydrate/neon = 5,
		/decl/material/solid/ice/hydrate/krypton = 5,
		/decl/material/solid/ice/hydrate/xenon = 5
	)