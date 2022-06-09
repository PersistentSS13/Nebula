/datum/specification
	var/archetype
	var/strength		// Strength of the specification. Higher strengths correlate with lesser requirements.
	var/auto_process = FALSE // Whether or not the specification should process automatically.
	var/process_on_install = FALSE // Whether or not the specification should process on installation into a machine.
	var/spec_type

	var/list/materials  // Associative list of material decl to unit, if specification requires it.

/datum/specification/New(specification_type, new_strength, list/req_materials)
	. = ..()
	if(specification_type) // Check if we're creating a new specification or just loading.
		strength = new_strength
		archetype = specification_type
		
		var/decl/specification_type/spec_info = GET_DECL(archetype)
		spec_type = spec_info.spec_type
		auto_process = spec_info.auto_process
		process_on_install = spec_info.process_on_install

		if(length(req_materials))
			materials = req_materials.Copy()
		else if(length(spec_info.default_materials))
			materials = list()
			var/list/default_materials = spec_info.default_materials.Copy()
			var/picked_materials = min(spec_info.req_materials, length(default_materials))
			for(var/i in 1 to picked_materials)
				materials += pick_n_take(default_materials)

/datum/specification/Destroy(force)
	LAZYCLEARLIST(materials)
	. = ..()

/datum/specification/after_deserialize()
	. = ..()
	var/decl/specification_type/spec_info = GET_DECL(archetype)
	spec_type = spec_info.spec_type
	auto_process = spec_info.auto_process
	process_on_install = spec_info.process_on_install

/datum/specification/proc/apply_to_recipe(datum/fabricator_recipe/recipe)
	var/decl/specification_type/spec = GET_DECL(archetype)
	if(spec.spec_type != SPEC_RECIPE)
		CRASH("Specification attempted to apply changes to recipe despite incorrect spec type!")
	spec.apply_to_recipe(recipe, strength, materials)

// Standard "specification action" proc for either checking conditions or performing actions. This should always return a boolean.
/datum/specification/proc/specification_act(obj/holder)
	var/decl/specification_type/spec_info = GET_DECL(archetype)
	return spec_info.specification_act(holder, strength, materials)

/datum/specification/proc/get_name()
	var/decl/specification_type/spec_info = GET_DECL(archetype)
	return spec_info.name

/datum/specification/proc/get_description()
	var/decl/specification_type/spec_info = GET_DECL(archetype)
	return spec_info.get_description(strength, materials)

/datum/specification/proc/get_incompatible_types()
	var/decl/specification_type/spec = GET_DECL(archetype)
	var/list/incompatible = spec.incompatible_specs.Copy()
	if(!spec.allow_duplicates)
		incompatible |= spec.type
	return incompatible

// Holder for specifications on items, circuits etc.
/datum/extension/specification_holder
	base_type = /datum/extension/specification_holder
	expected_type = /obj

	should_save = TRUE

	var/list/specifications
	
	// Since specification holders don't change their specifications, have the holders keep track of this post init
	var/auto_process
	var/process_on_install

	var/spec_passed = FALSE // Whether all specifications which processed last tick passed.

/datum/extension/specification_holder/New(datum/holder, list/added_specifications)
	. = ..()
	if(length(added_specifications))
		specifications = added_specifications.Copy()

	for(var/datum/specification/spec as anything in specifications)
		auto_process = max(auto_process, spec.auto_process)
		process_on_install = max(process_on_install, spec.process_on_install)
	
	if(auto_process)
		START_PROCESSING(SSspecifications, src)

/datum/extension/specification_holder/after_deserialize()
	. = ..()
	for(var/datum/specification/spec as anything in specifications)
		auto_process = max(auto_process, spec.auto_process)
		process_on_install = max(process_on_install, spec.process_on_install)
	
	if(auto_process)
		START_PROCESSING(SSspecifications, src)
	if(process_on_install)
		var/obj/item/stock_parts/part = holder
		if(istype(part) && (part.status & PART_STAT_INSTALLED))
			START_PROCESSING(SSspecifications, src)

/datum/extension/specification_holder/proc/specifications_act()
	. = TRUE
	for(var/datum/specification/spec as anything in specifications)
		. = min(., spec.specification_act(holder))
	
	// Snowflakey check so we don't have to process unfinished assemblies seperately
	if(. && istype(holder, /obj/item/unfinished_assembly))
		var/obj/item/unfinished_assembly/assembly = holder
		assembly.finalize()

/datum/extension/specification_holder/Process()
	spec_passed = specifications_act()

// Saved vars

SAVED_VAR(/datum/specification, archetype)
SAVED_VAR(/datum/specification, strength)
SAVED_VAR(/datum/specification, materials)

SAVED_VAR(/datum/extension/specification_holder, specifications)

