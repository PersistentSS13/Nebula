/datum/theory
	var/archetype
	var/strength

	var/list/increased_fields // Fields which are increased by this theory
	var/list/decreased_fields // Fields which are decreased by this theory.
	var/list/flagged_fields   // Fields which are flagged/otherwise affected by the theory.
	var/list/specifications // Specifications, if any, which will be applied to the design upon finalization.

	var/list/added_fields  // Fields the theory adds to the design.

/datum/theory/New(theory_type, list/picked_fields, theory_value, list/spec_types, list/req_materials, list/new_fields)
	if(theory_type)
		archetype = theory_type
		var/decl/theory_type/theory_info = GET_DECL(archetype)
		strength = max(1, theory_value - theory_info.rel_power)
		if(theory_info.increased_fields)
			increased_fields = list()
			for(var/i in 1 to theory_info.increased_fields)
				increased_fields += pick_n_take(picked_fields)

		if(theory_info.decreased_fields)
			decreased_fields = list()
			for(var/i in 1 to theory_info.decreased_fields)
				decreased_fields += pick_n_take(picked_fields)
		
		if(theory_info.flagged_fields)
			flagged_fields = list()
			for(var/i in 1 to theory_info.flagged_fields)
				flagged_fields += pick_n_take(picked_fields)

		var/list/picked_specifications = length(spec_types) ? spec_types : theory_info.specification_choices
		if(length(picked_specifications))
			specifications = list()
			var/spec_type = pick(picked_specifications)
			specifications += new /datum/specification(spec_type, strength, req_materials)
		
		added_fields = new_fields
	. = ..()

/datum/theory/Destroy(force)
	. = ..()
	specifications = null // Let the garbage collector manually clean up specifications when there are no longer any references,
						  // since theoretically theories can be applied more than once.

/datum/theory/proc/apply_to_design(datum/computer_file/data/design/target, obj/item/analyzed)
	var/decl/theory_type/theory_info = GET_DECL(archetype)
	var/theory_result = theory_info.check_requirements(target, analyzed)
	if(theory_result != THEORY_SUCCESS)
		return theory_result
	for(var/datum/specification/spec in specifications)
		var/decl/specification_type/spec_type = GET_DECL(spec.archetype)
		if(!target.check_specification_validity(spec_type))
			return THEORY_INCOMPATIBLE
	
	if(length(added_fields))
		for(var/field in added_fields)
			target.add_field(field)
	target.apply_specifications(specifications)
	theory_info.affect_design(target, strength, increased_fields, decreased_fields, flagged_fields, analyzed)
	return THEORY_SUCCESS

/datum/theory/proc/get_description()
	var/decl/theory_type/theory_info = GET_DECL(archetype)
	var/list/desc = list()
	desc += theory_info.get_description(strength, increased_fields, decreased_fields, flagged_fields)
	if(length(specifications))
		for(var/datum/specification/spec in specifications)
			desc += spec.get_description()
	if(length(added_fields))
		var/list/field_names = list()
		for(var/field in added_fields)
			field_names += tech_id_to_name[field]
		desc += "Adds the incidental fields [english_list(field_names)] to the design."
	return jointext(desc, ". ")

/datum/theory/proc/is_special()
	var/decl/theory_type/theory_info = GET_DECL(archetype)
	return theory_info.special

/datum/theory/proc/get_ui_data()
	var/decl/theory_type/theory_info = GET_DECL(archetype)

	var/text_strength = ""
	for(var/i in 1 to strength)
		text_strength += "*"

	var/list/theory_data = list(
				"name" = theory_info.name,
				"desc" = get_description(),
				"strength" = text_strength,
				"special" = theory_info.special,
				"ref" = "\ref[src]"
				)
	return theory_data