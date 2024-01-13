/decl/specification_type
	abstract_type = /decl/specification_type

	var/name = "Specification Type"
	var/list/incompatible_specs = list()	// List of specification types which are incompatible with this one.
											// These will be removed from the design if the specialization is applied.
	var/allow_duplicates = FALSE

	var/list/valid_paths = list(/obj/item)
	var/list/invalid_paths = list(/obj/item/stock_parts/circuitboard) // In general, circuitboards need stock part specifications.
	var/list/default_materials
	var/req_materials = 0

	var/auto_process = FALSE // Whether or not specification holders should *automatically* process, calling specification_act() in Process()
	var/process_on_install = FALSE // Whether or not specification holders should begin processing on installation into a machine.

	var/spec_type // How the specification affects the design - either the recipe, the production, or the item produced.

/decl/specification_type/proc/specification_act(obj/holder, strength, materials)

/decl/specification_type/proc/apply_to_recipe(datum/fabricator_recipe/recipe, strength, list/req_materials)

/decl/specification_type/proc/get_description(strength, list/materials)

// Specification type definitions follow
/decl/specification_type/manual_finish
	name = "Complex assembly"
	spec_type = SPEC_FINISH

/decl/specification_type/manual_finish/get_description(strength, list/req_materials)
	return "Design will require manual finishing with a screwdriver upon construction"

/decl/specification_type/manual_finish/specification_act(obj/holder, strength, list/materials)
	var/obj/item/unfinished_assembly/assembly = holder
	if(!istype(holder))
		CRASH("Finishing specification applied to non-assembly!")

	if(assembly.screwdrivered)
		return TRUE

/decl/specification_type/material_cost
	name = "Crucial materials I"

	req_materials = 1
	default_materials = list(
							/decl/material/solid/metal/copper,
							/decl/material/solid/metal/gold,
							/decl/material/solid/metal/aluminium,
							/decl/material/solid/organic/plastic,
							/decl/material/solid/metal/silver
	)
	spec_type = SPEC_RECIPE
	allow_duplicates = TRUE

/decl/specification_type/material_cost/get_description(strength, list/req_materials)
	var/list/material_descs = list()
	for(var/material in req_materials)
		var/decl/material/mat = GET_DECL(material)
		material_descs += "[STRENGTH_TO_MAT_AMOUNT(strength)] units of [mat.name]"

	return "Design will require [english_list(material_descs)]."

/decl/specification_type/material_cost/apply_to_recipe(datum/fabricator_recipe/recipe, strength, list/req_materials)
	for(var/material_type in req_materials)
		recipe.resources[material_type] += STRENGTH_TO_MAT_AMOUNT(strength)

/decl/specification_type/material_cost/two
	default_materials = list(
							/decl/material/solid/gemstone/diamond,
							/decl/material/solid/metal/stainlesssteel,
							/decl/material/solid/metal/titanium,
							/decl/material/solid/metal/uranium,
							/decl/material/solid/metal/platinum
	)

// These are all quite difficult to get in large quantities.
/decl/specification_type/material_cost/three
	default_materials = list(
							/decl/material/solid/metal/neptunium,
							/decl/material/solid/metallic_hydrogen,
							/decl/material/solid/metal/plutonium
	)

/decl/specification_type/instability
	name = "Instability I"
	spec_type = SPEC_RECIPE
	var/instability = 5
	allow_duplicates = TRUE

/decl/specification_type/instability/get_description(strength, list/materials)
	return "Design will be slightly more unstable. Expect potential material loss"

/decl/specification_type/instability/apply_to_recipe(datum/fabricator_recipe/recipe, strength, list/req_materials)
	recipe.instability += instability

/decl/specification_type/instability/two
	name = "Instability II"
	spec_type = SPEC_RECIPE
	instability = 10

/decl/specification_type/instability/two/get_description(strength, list/materials)
	return "Design will be slightly more unstable. Expect potential material loss or damage to machinery"

/decl/specification_type/instability/three
	name = "Instability III"
	spec_type = SPEC_RECIPE
	instability = 15

/decl/specification_type/instability/three/get_description(strength, list/materials)
	return "Design will be extremely unstable. Expect potential material loss or massive damage to machinery"

/decl/specification_type/cold_production
	name = "Cold Production"
	spec_type = SPEC_PRODUCTION

/decl/specification_type/cold_production/get_description(strength, list/materials)
	return "Design must be produced in temperatures below [0 CELSIUS + 3*strength] degrees Kelvin. Production will generate small amounts of heat"

/decl/specification_type/cold_production/specification_act(obj/holder, strength, list/materials)
	var/datum/gas_mixture/environment = holder.return_air()
	if(!environment)
		return TRUE // Null and/or normal space is pretty cold!
	if(environment.temperature <= (0 CELSIUS + 3*strength))
		environment.add_thermal_energy(1000)
		return TRUE

/decl/specification_type/hypoxic_production
	name = "Hypoxic Production"
	spec_type = SPEC_PRODUCTION

/decl/specification_type/hypoxic_production/get_description(strength, list/materials)
	return "Design must be produced in an oxygen free, pressurized environment. Oxygen partial pressure must be below [strength*2] kPa"

/decl/specification_type/hypoxic_production/specification_act(obj/holder, strength, list/materials)
	var/datum/gas_mixture/environment = holder.return_air()
	if(!environment || environment.return_pressure() < ONE_ATMOSPHERE*0.80)
		return FALSE
	if(!environment.gas[/decl/material/gas/oxygen])
		return TRUE
	var/oxygen_partial_pressure = (environment.gas[/decl/material/gas/oxygen] * R_IDEAL_GAS_EQUATION * (environment.temperature / environment.volume))
	if(oxygen_partial_pressure < strength*2)
		return TRUE

/decl/specification_type/dark_room
	name = "Light sensitivity"
	spec_type = SPEC_PRODUCTION

/decl/specification_type/dark_room/get_description(strength, list/materials)
	return "Design must be produced in an dark room"

/decl/specification_type/dark_room/specification_act(obj/holder, strength, list/materials)
	var/turf/T = get_turf(holder)
	if(!T)
		return TRUE // Null-space is dark too!
	var/light_level = T.get_lumcount()
	if(light_level < 0.1)
		return TRUE

/decl/specification_type/fired_finish
	name = "Fired finish"
	spec_type = SPEC_FINISH
	auto_process = TRUE

/decl/specification_type/fired_finish/get_description(strength, list/materials)
	return "Design must be finished in a fire above temperature [500 - 25*strength] degrees Kelvin"

/decl/specification_type/fired_finish/specification_act(obj/holder, strength, list/materials)
	var/obj/item/unfinished_assembly/assembly = holder
	if(!istype(holder))
		CRASH("Finishing specification applied to non-assembly!")
	if(assembly.fired >= 500 - 50*strength)
		return TRUE
	return FALSE

// Stock Part specifications follow
/decl/specification_type/stock_part
	abstract_type = /decl/specification_type/stock_part
	valid_paths = list(/obj/item/stock_parts)
	invalid_paths = list()
	spec_type = SPEC_ITEM

	process_on_install = TRUE

/decl/specification_type/stock_part/specification_act(obj/holder, strength, materials)
	var/obj/item/stock_parts/stock_part = holder
	var/obj/machinery/installation = holder.loc
	if(!istype(installation))
		return TRUE
	// If the stock part isn't actually installed, or if the machine isn't processing, return TRUE.
	if(!(stock_part.status & PART_STAT_INSTALLED) || installation.stat & (BROKEN|NOPOWER))
		return TRUE

/decl/specification_type/stock_part/proc/damage_component(obj/holder)
	var/obj/item/stock_parts/stock_part = holder
	stock_part.take_damage(10, BURN)

/decl/specification_type/stock_part/runs_hot
	name = "Runs hot"

/decl/specification_type/stock_part/runs_hot/get_description(strength, list/materials)
	return "Machine in which this design is installed will run hot, emitting heat into the local air supply. Maximum temperature is [35 CELSIUS + 5*strength] degrees Kelvin"

/decl/specification_type/stock_part/runs_hot/specification_act(obj/holder, strength, list/materials)
	. = ..()
	if(.)
		return
	var/datum/gas_mixture/environment = holder.return_air() // This will probably return the interior air supply on some machines, but that sounds like it'd be funny.
	if(!environment || environment.temperature > 35 CELSIUS + 5*strength)
		damage_component(holder)
		return FALSE
	var/obj/machinery/installation = holder.loc
	if(istype(installation))
		installation.use_power_oneoff(5000)
		environment.add_thermal_energy(5000)
		return TRUE

/decl/specification_type/stock_part/rad_emitter
	name = "Radiation source"

/decl/specification_type/stock_part/rad_emitter/get_description(strength, list/materials)
	return "Machine in which this design is installed will emit weak levels of radiation"

/decl/specification_type/stock_part/rad_emitter/specification_act(obj/holder, strength, list/materials)
	. = ..()
	if(.)
		return
	if(prob(max(10, 30 - 5*strength)))
		SSradiation.radiate(holder, 3)
	return TRUE

/decl/specification_type/stock_part/low_pressure
	name = "Low pressure part"

/decl/specification_type/stock_part/low_pressure/get_description(strength, list/materials)
	return "Design must run in a pressure below [strength] kPa, or it will begin to fail"

/decl/specification_type/stock_part/low_pressure/specification_act(obj/holder, strength, list/materials)
	. = ..()
	if(.)
		return
	var/turf/T = get_turf(holder)
	var/datum/gas_mixture/environment = T.return_air() // Here we should be careful that this is actually the environment's air.
	if(!environment)
		return TRUE
	if(environment.return_pressure() < strength)
		return TRUE
	damage_component(holder)
	return FALSE

/decl/specification_type/stock_part/hypoxic
	name = "Inert environment"
	spec_type = SPEC_ITEM
	valid_paths = list(/obj/item/stock_parts)

/decl/specification_type/stock_part/hypoxic/get_description(strength, list/materials)
	return "Design must run in an oxygen free, pressurized environment. Oxygen partial pressure must be below [strength*2] kPa"

/decl/specification_type/stock_part/hypoxic/specification_act(obj/holder, strength, list/materials)
	. = ..()
	if(.)
		return
	var/turf/T = get_turf(holder)
	var/datum/gas_mixture/environment = T?.return_air()
	if(!environment || environment.return_pressure() < ONE_ATMOSPHERE*0.80)
		. = FALSE
	else if(!environment.gas[/decl/material/gas/oxygen])
		. = TRUE
	else
		var/oxygen_partial_pressure = (environment.gas[/decl/material/gas/oxygen] * R_IDEAL_GAS_EQUATION * (environment.temperature / environment.volume))
		if(oxygen_partial_pressure < strength*2)
			. = TRUE
	if(!.)
		damage_component(holder)