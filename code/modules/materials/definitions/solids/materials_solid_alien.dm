/decl/material/solid/metal/aliumium
	name = "alien alloy"
	uid = "solid_alien"
	icon_base = 'icons/turf/walls/metal.dmi'
	wall_flags = PAINT_PAINTABLE
	door_icon_base = "metal"
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	hitsound = 'sound/weapons/smash.ogg'
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	hidden_from_codex = TRUE
	value = 2.5
	default_solid_form = /obj/item/stack/material/cubes
	exoplanet_rarity = MAT_RARITY_EXOTIC

/decl/material/solid/metal/aliumium/Initialize()
	icon_base = 'icons/turf/walls/metal.dmi'
	wall_flags = PAINT_PAINTABLE
	color = rgb(rand(10,150),rand(10,150),rand(10,150))
	explosion_resistance = rand(25,40)
	brute_armor = rand(10,20)
	burn_armor = rand(10,20)
	hardness = rand(15,100)
	reflectiveness = rand(15,100)
	integrity = rand(200,400)
	melting_point = rand(400,11000)
	. = ..()

/decl/material/solid/metal/aliumium/place_dismantled_girder(var/turf/target, var/decl/material/reinf_material)
	return


/decl/material/solid/phoron
	name = "phoron"
	uid = "phoron"
	lore_text = "Time bleeding backwards; This rare substance is prized throughout the universe for the marvelous wonders it enables."
	color = "#940dbd"
	stack_origin_tech = "{'materials':6,'powerstorage':6,'magnets':5}"
	heating_point = 990
	ore_name = "raw phoron"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "gems"
	value = 2
	gas_symbol_html = "Ph"
	gas_symbol = "Ph"
	wall_name = "bulkhead"
	construction_difficulty = MAT_VALUE_HARD_DIY
	gas_specific_heat = 100
	molar_mass = 0.002
	gas_flags = XGM_GAS_FUEL | XGM_GAS_CONTAMINANT
	ore_type_value = ORE_EXOTIC
	ore_data_value = 4
	default_solid_form = /obj/item/stack/material/shiny
	exoplanet_rarity = MAT_RARITY_EXOTIC
	shard_type = SHARD_SHARD
	hardness = MAT_VALUE_RIGID
	flags = MAT_FLAG_FUSION_FUEL
	construction_difficulty = MAT_VALUE_HARD_DIY
	reflectiveness = MAT_VALUE_SHINY
	ignition_point = FLAMMABLE_GAS_MINIMUM_BURN_TEMPERATURE
	gas_specific_heat = 200	// J/(mol*K)
	molar_mass = 0.405	// kg/mol
	gas_flags = XGM_GAS_FUEL | XGM_GAS_CONTAMINANT
	taste_mult = 1.5
	toxicity = 30
	touch_met = 5
	fuel_value = 6


/decl/material/solid/metal/nebu
	name = "nebu"
	uid = "nebu"
	lore_text = "This mysterious metal is only found in truly hidden corners of the frontier. It is revered by some, but useless to most."
	color = "#fffb00"
	stack_origin_tech = "{'materials':6,'powerstorage':6,'magnets':5}"
	ore_name = "raw nebu"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "gems"
	value = 2
	gas_symbol_html = "NeB"
	gas_symbol = "NeB"
	wall_name = "bulkhead"
	construction_difficulty = MAT_VALUE_HARD_DIY
	hardness = MAT_VALUE_SOFT
	ore_type_value = ORE_EXOTIC
	ore_data_value = 4
	default_solid_form = /obj/item/stack/material/ingot
	exoplanet_rarity = MAT_RARITY_NOWHERE
	shard_type = SHARD_SHARD
	construction_difficulty = MAT_VALUE_HARD_DIY+40
	reflectiveness = MAT_VALUE_SHINY+10
	toxicity = 30
	touch_met = 5
