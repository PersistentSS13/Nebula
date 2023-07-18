/decl/strata/base_planet
	name = "planetary crust strata"
	base_materials = list(/decl/material/solid/stone/sandstone)
	ores_sparse = list(
		/decl/material/solid/graphite = 10,
		/decl/material/solid/hematite = 20,
		/decl/material/solid/sand = 5,
		/decl/material/solid/sodiumchloride = 5,
		/decl/material/solid/pyrite = 10,
		/decl/material/solid/quartz = 5,
		/decl/material/solid/clay = 10,
		/decl/material/solid/magnetite = 10,
		/decl/material/solid/chalcopyrite = 20,
		/decl/material/solid/sphalerite = 5,
		/decl/material/solid/cassiterite = 5,
		/decl/material/solid/potash = 5,
		/decl/material/solid/potassium = 5,
		/decl/material/solid/cinnabar = 3,
		/decl/material/solid/spodumene = 3,
		/decl/material/solid/bauxite = 5,
		/decl/material/solid/ice/aspium = 2,
		/decl/material/solid/ice/ediroite = 2,
		/decl/material/solid/ice/lukrite = 2,
		/decl/material/solid/ice/trigarite = 2
	)
	ores_rich = list(
		/decl/material/solid/hematite = 20,
		/decl/material/solid/pitchblende = 10,
		/decl/material/solid/chalcopyrite = 20,
		/decl/material/solid/tetrahedrite = 5,
		/decl/material/solid/wolframite = 5,
		/decl/material/solid/galena = 5,
		/decl/material/solid/bauxite = 5,
		/decl/material/solid/sperrylite = 3,
		/decl/material/solid/calaverite = 2,
		/decl/material/solid/ice/lukrite = 3,
		/decl/material/solid/ice/trigarite = 3,
		/decl/material/solid/ice/hydrogen = 2,
		/decl/material/solid/ice/hydrate/oxygen = 2
	)

/decl/strata/asteroid/is_valid_exoplanet_strata()
	return FALSE

/decl/strata/asteroid/iron
	name = "iron-rich spaceborne rock"
	base_materials = list(/decl/material/solid/stone/asteroid)
	ores_sparse = list(
		/decl/material/solid/hematite = 20,
		/decl/material/solid/magnetite = 60,
		/decl/material/solid/pyrite = 20,
		/decl/material/solid/cinnabar = 5,
		/decl/material/solid/phosphorite = 10,
	)
	ores_rich = list(
		/decl/material/solid/metal/gold = 5,
		/decl/material/solid/metal/silver = 3,
		/decl/material/solid/magnetite = 50,
		/decl/material/solid/cinnabar = 10,
	)

/decl/strata/asteroid/carbon
	name = "carbon-rich spaceborne rock"
	base_materials = list(/decl/material/solid/stone/asteroid)
	ores_sparse = list(
		/decl/material/solid/hematite = 10,
		/decl/material/solid/pitchblende = 5,
		/decl/material/solid/graphite = 60,
		/decl/material/solid/quartz = 10,
		/decl/material/solid/sand = 30,
		/decl/material/solid/potash = 10
	)
	ores_rich = list(
		/decl/material/solid/hematite = 25,
		/decl/material/solid/pitchblende = 10,
		/decl/material/solid/graphite = 50,
		/decl/material/solid/quartz = 10,
		/decl/material/solid/potash = 15,
		/decl/material/solid/gemstone/diamond = 1
	)

/decl/strata/asteroid/copper
	name = "copper-rich spaceborne rock"
	base_materials = list(/decl/material/solid/stone/asteroid)
	ores_sparse = list(
		/decl/material/solid/hematite = 5,
		/decl/material/solid/rutile = 2,
		/decl/material/solid/graphite = 5,
		/decl/material/solid/chalcopyrite = 60,
		/decl/material/solid/tetrahedrite = 35,
		/decl/material/solid/sodiumchloride = 5
	)
	ores_rich = list(
		/decl/material/solid/hematite = 10,
		/decl/material/solid/rutile = 5,
		/decl/material/solid/graphite = 5,
		/decl/material/solid/chalcopyrite = 25,
		/decl/material/solid/tetrahedrite = 50
	)

/decl/strata/asteroid/dense
	name = "dense spaceborne rock"
	base_materials = list(/decl/material/solid/stone/asteroid)
	ores_sparse = list(
		/decl/material/solid/cassiterite = 50,
		/decl/material/solid/galena = 25,
		/decl/material/solid/hematite = 10,
		/decl/material/solid/rutile = 5,
		/decl/material/solid/pitchblende = 5
	)
	ores_rich = list(
		/decl/material/solid/cassiterite = 20,
		/decl/material/solid/wolframite = 10,
		/decl/material/solid/hematite = 5,
		/decl/material/solid/pitchblende = 10
	)

/decl/strata/asteroid/shimmering
	name = "shimmering spaceborne rock"
	base_materials = list(/decl/material/solid/stone/asteroid)
	ores_sparse = list(
		/decl/material/solid/quartz = 15,
		/decl/material/solid/pyrite = 60,
		/decl/material/solid/spodumene = 20,
		/decl/material/solid/potash = 10,
		/decl/material/solid/crocoite = 20
	)
	ores_rich = list(
		/decl/material/solid/quartz = 5,
		/decl/material/solid/pyrite = 25,
		/decl/material/solid/spodumene = 5,
		/decl/material/solid/potash = 5,
		/decl/material/solid/sperrylite = 10,
		/decl/material/solid/calaverite = 7,
		/decl/material/solid/crocoite = 10,
		/decl/material/solid/metal/gold = 2
	)

/decl/strata/asteroid/rich
	name = "mineral rich spaceborne rock"
	base_materials = list(/decl/material/solid/stone/asteroid)
	ores_sparse = list(
		/decl/material/solid/magnetite = 20,
		/decl/material/solid/metal/gold = 5,
		/decl/material/solid/sperrylite = 20,
		/decl/material/solid/calaverite = 15,
		/decl/material/solid/crocoite = 20
	)
	ores_rich = list(
		/decl/material/solid/magnetite = 5,
		/decl/material/solid/metal/gold = 10,
		/decl/material/solid/sperrylite = 20,
		/decl/material/solid/calaverite = 20,
		/decl/material/solid/gemstone/diamond = 3
	)

/decl/strata/comet/is_valid_exoplanet_strata(datum/planetoid_data/planet)
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
		/decl/material/solid/ice/hydrogen = 5,
		/decl/material/solid/ice/hydrate/oxygen = 5,
		/decl/material/solid/ice/hydrate/carbon_dioxide = 5
	)

/decl/strata/comet/gas
	name = "gas rich space-borne ice"
	base_materials = list(/decl/material/solid/ice)
	ores_sparse = list(
		/decl/material/solid/ice/hydrogen = 10,
		/decl/material/solid/ice/hydrate/methane = 5,
		/decl/material/solid/ice/hydrate/oxygen = 25,
		/decl/material/solid/ice/hydrate/nitrogen = 10,
		/decl/material/solid/ice/lukrite = 15
	)
	ores_rich = list(
		/decl/material/solid/ice/aspium = 5,
		/decl/material/solid/ice/rubenium = 10,
		/decl/material/solid/ice/trigarite = 5,
		/decl/material/solid/ice/hydrogen = 15,
		/decl/material/solid/ice/hydrate/oxygen = 10,
		/decl/material/solid/ice/hydrate/argon = 5,
		/decl/material/solid/ice/hydrate/neon = 5,
		/decl/material/solid/ice/hydrate/krypton = 5,
		/decl/material/solid/ice/hydrate/xenon = 5
	)