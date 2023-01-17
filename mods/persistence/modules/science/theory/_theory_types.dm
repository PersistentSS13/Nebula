var/global/list/cached_theories_by_tier = list()

/proc/get_theory_options(tier, finishing)
	if(finishing)
		if(tier == 1)
			return list(/decl/theory_type/concluding)
		if(tier == 2)
			return list(/decl/theory_type/concluding/tier2)
		if(tier == 3)
			return list(/decl/theory_type/concluding/tier3)
		else
			return list(/decl/theory_type/concluding/tier4)

	var/list/theory_options = cached_theories_by_tier["[tier]"]
	if(!theory_options)
		cached_theories_by_tier["[tier]"] = list()
		for(var/theory_path in (decls_repository.get_decls_of_subtype(/decl/theory_type) - decls_repository.get_decls_of_type(/decl/theory_type/concluding)))
			var/decl/theory_type/theory = theory_path // Bit of silliness here to use initial()
			if(tier < initial(theory.min_tier))
				continue
			cached_theories_by_tier["[tier]"] += theory_path
		cached_theories_by_tier["[tier]"] -= decls_repository.get_decls_of_type(/decl/theory_type/starter)
		theory_options = cached_theories_by_tier["[tier]"]

	theory_options = theory_options.Copy()

	return theory_options

/decl/theory_type
	var/name = "Theory Type"
	abstract_type = /decl/theory_type

	var/rel_power = 1	   // Relative power of the theory type. When generating a theory, a overall value will be generated
						   // and the difference between it and the relative power will be the strength

	var/increased_fields = 0 // Number of fields to be increased that must be passed from theory.
	var/decreased_fields = 0 // Number of fields to be decreased that must be passed from theory.
	var/flagged_fields   = 0 // Number of fields to be flagged/some other effect that must be passed from theory.

	var/min_tier = 1         // The minimum tier a design must be to access this theory.
	var/list/specification_choices // List of specification types possibly associated with this theory

	var/special = FALSE      // Mark this theory as special. Special theories cannot be kept between generations.
	var/allow_dupl = FALSE

/decl/theory_type/proc/check_requirements(datum/computer_file/data/design/target, obj/item/analyzed)
	return THEORY_SUCCESS

/decl/theory_type/proc/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)

/decl/theory_type/proc/get_description(strength, list/increased, list/decreased, list/flagged)

// Theory type implementation follows.

// Starter theories are picked when beginning a design.
/decl/theory_type/starter
	abstract_type = /decl/theory_type/starter
	special = TRUE

/decl/theory_type/starter/hypothesis
	name = "Hypothesis"
	uid = "hypothesis_theory"
	rel_power = 3

/decl/theory_type/starter/hypothesis/get_description(strength, list/increased, list/decreased, list/flagged)
	return "Generate a new hypothesis related to the technology. Gain [strength] points assignable in any field"

/decl/theory_type/starter/hypothesis/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	target.free_points += strength

/decl/theory_type/starter/experiment
	name = "Experiment"
	uid = "experiment_theory"

/decl/theory_type/starter/experiment/get_description(strength, list/increased, list/decreased, list/flagged)
	return "Perform some preliminary experiments. Distribute [strength] research points randomly among all fields"

/decl/theory_type/starter/experiment/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	var/remaining_points = strength
	while(remaining_points > 0 && target.remaining_points)
		var/field = pick(target.research_levels)
		target.add_points(field, 1)
		remaining_points -= 1

/decl/theory_type/starter/analyze
	name = "Initial analysis"
	uid = "analyze_theory"
	rel_power = 2

/decl/theory_type/starter/analyze/get_description(strength, list/increased, list/decreased, list/flagged)
	return "Analyze another object using the destructive analyzer. Distribute [strength] research points randomly among the analyzed objects own research fields"

/decl/theory_type/starter/analyze/check_requirements(datum/computer_file/data/design/target, obj/item/analyzed)
	if(!analyzed || !analyzed.origin_tech)
		return THEORY_NEEDS_ITEM
	return THEORY_SUCCESS

/decl/theory_type/starter/analyze/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	if(!analyzed || !analyzed.origin_tech)
		return
	var/list/target_fields = cached_json_decode(analyzed.origin_tech)
	var/remaining_points = strength
	while(remaining_points > 0 && target.remaining_points)
		var/prev_points = remaining_points
		for(var/field in target_fields)
			target.add_points(field, 1)
			remaining_points -= 1
		if(remaining_points == prev_points)
			break

	var/obj/machinery/destructive_analyzer/analyzer = analyzed.loc
	if(istype(analyzer))
		analyzer.process_loaded()
	else
		analyzed.physically_destroyed()

/decl/theory_type/reevaluate
	name = "Reevaluate"
	uid = "reevaluate_theory"
	decreased_fields = 1

/decl/theory_type/reevaluate/get_description(strength, list/increased, list/decreased, list/flagged)
	var/target_field = decreased[1]
	return "Reevaluate and discard some of your previous findings. Regain [strength] research points from [tech_id_to_name[target_field]]"

/decl/theory_type/reevaluate/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	var/target_field = decreased[1]
	target.remove_points(target_field, strength)

/decl/theory_type/refine
	name = "Refine findings"
	uid = "refine_theory"

/decl/theory_type/refine/get_description(strength, list/increased, list/decreased, list/flagged)
	return "Refine your previous findings. Distribute [strength] research points into the field with the most research points"

/decl/theory_type/refine/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	var/target_field = target.get_highest_field()
	target.add_points(target_field, strength)

/decl/theory_type/narrow_scope
	name = "Narrow scope"
	uid = "narrow_theory"

/decl/theory_type/narrow_scope/get_description(strength, list/increased, list/decreased, list/flagged)
	return "Narrow the scope of your research. Regain [strength] research points from the field with the least research points"

/decl/theory_type/narrow_scope/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	var/target_field = target.get_lowest_field()
	target.remove_points(target_field, strength)

/decl/theory_type/broaden_scope
	name = "Broaden scope"
	uid = "broaden_theory"

/decl/theory_type/broaden_scope/get_description(strength, list/increased, list/decreased, list/flagged)
	return "Broaden the scope of your research. Regain [strength] research points from the field with the most research points"

/decl/theory_type/broaden_scope/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	var/target_field = target.get_highest_field()
	target.remove_points(target_field, strength)

/decl/theory_type/crunch_data
	name = "Crunch data"
	uid = "crunch_data_theory"
	increased_fields = 1

/decl/theory_type/crunch_data/proc/get_increased_fields(strength, list/increased_fields)
	var/list/points_increases = list()
	var/remaining_points = strength
	if(length(increased_fields))
		while(remaining_points > 0)
			for(var/field in increased_fields)
				points_increases[field] += 1
				remaining_points -= 1
	return points_increases

/decl/theory_type/crunch_data/get_description(strength, list/increased, list/decreased, list/flagged)
	var/list/points_increases = get_increased_fields(strength, increased)
	var/list/description_lines = list()
	for(var/field in points_increases)
		var/points = points_increases[field]
		description_lines += "[points] research points into [tech_id_to_name[field]]"
	return "Analyze some data you've collected. Distribute [english_list(description_lines)]"

/decl/theory_type/crunch_data/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	var/list/points_increases = get_increased_fields(strength, increased)
	for(var/field in points_increases)
		var/points = points_increases[field]
		target.add_points(field, points)

/decl/theory_type/crunch_data/integrate
	name = "Integrate findings"
	uid = "integrate_theory"
	increased_fields = 2

/decl/theory_type/crunch_data/integrate/get_description(strength, list/increased, list/decreased, list/flagged)
	var/list/points_increases = get_increased_fields(strength, increased)
	var/list/description_lines = list()
	for(var/field in points_increases)
		var/points = points_increases[field]
		description_lines += "[points] research points into [tech_id_to_name[field]]"
	return "Integrate some findings into your research. Distribute [english_list(description_lines)]"

/decl/theory_type/crunch_data/broad_spectrum
	name = "Broad spectrum analysis"
	uid = "broad_spectrum_theory"
	increased_fields = 3

/decl/theory_type/crunch_data/broad_spectrum/get_description(strength, list/increased, list/decreased, list/flagged)
	var/list/points_increases = get_increased_fields(strength, increased)
	var/list/description_lines = list()
	for(var/field in points_increases)
		var/points = points_increases[field]
		description_lines += "[points] research points into [tech_id_to_name[field]]"
	return "Perform some broad spectrum analysis of your collected data. Distribute [english_list(description_lines)]"

/decl/theory_type/prediction
	name = "Testable prediction"
	uid = "prediction_theory"
	flagged_fields = 1

/decl/theory_type/prediction/get_description(strength, list/increased, list/decreased, list/flagged)
	return "Make some testable predictions. The next effect on [tech_id_to_name[flagged[1]]] will be doubled"

/decl/theory_type/prediction/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	target.add_field_flag(flagged[1], FIELD_BONUS)

/decl/theory_type/holistic
	name = "Holistic methods"
	uid = "holistic_theory"
	flagged_fields = 2

/decl/theory_type/holistic/get_description(strength, list/increased, list/decreased, list/flagged)
	return "Proceed with holistic methods. Link the fields [tech_id_to_name[flagged[1]]] and [tech_id_to_name[flagged[2]]], causing the next effect on either to affect both"

/decl/theory_type/holistic/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	for(var/field in flagged)
		target.add_field_flag(field, FIELD_LINKED)

/decl/theory_type/lock
	name = "Set in stone"
	uid = "lock_theory"
	flagged_fields = 1

/decl/theory_type/lock/get_description(strength, list/increased, list/decreased, list/flagged)
	return "Set some of your work in stone. The next effect on [tech_id_to_name[flagged[1]]] will have no effect"

/decl/theory_type/lock/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	for(var/field in flagged)
		target.add_field_flag(field, FIELD_LOCKED)

/decl/theory_type/paradigm
	name = "Paradigm shift"
	uid = "paradigm_theory"
	flagged_fields = 2

/decl/theory_type/paradigm/get_description(strength, list/increased, list/decreased, list/flagged)
	return "Adjust your approach to your findings thus far. Swap the values of [tech_id_to_name[flagged[1]]] and [tech_id_to_name[flagged[2]]]. Field flags will have no effect"

/decl/theory_type/paradigm/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	ASSERT(!(length(flagged) % 2))
	var/list/prev_points[length(flagged)]
	// Remove points from all fields first.
	for(var/i in 1 to length(flagged))
		var/field = flagged[i]
		prev_points[i] = target.research_levels[field]
		target.remove_points(field, prev_points[i], TRUE)
	// Now readd them to their neighbor
	for(var/i in 1 to length(flagged))
		var/field = flagged[i]
		var/dir = (i % 2) ? 1 : -1 // Odd indices look foward, even indices look backward.
		target.add_points(field, prev_points[i + dir], TRUE)

/decl/theory_type/breakthrough
	name = "Breakthough"
	uid = "breakthough_theory"
	rel_power = 3

/decl/theory_type/breakthrough/get_description(strength, list/increased, list/decreased, list/flagged)
	return "Find a new breakthrough in your research. Gain [strength] points assignable in any field"

/decl/theory_type/breakthrough/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	target.free_points += strength

/decl/theory_type/analyze
	name = "Destructive analysis"
	uid = "dest_analyze_theory"
	rel_power = 2

/decl/theory_type/analyze/get_description(strength, list/increased, list/decreased, list/flagged)
	return "Analyze another object using the destructive analyzer. Distribute [strength] research points randomly among the analyzed objects own research fields"

/decl/theory_type/analyze/check_requirements(datum/computer_file/data/design/target, obj/item/analyzed)
	if(!analyzed || !analyzed.origin_tech)
		return THEORY_NEEDS_ITEM
	return THEORY_SUCCESS

/decl/theory_type/analyze/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	if(!analyzed || !analyzed.origin_tech)
		return
	var/list/target_fields = cached_json_decode(analyzed.origin_tech)
	var/remaining_points = strength
	while(remaining_points > 0 && target.remaining_points)
		var/prev_points = remaining_points
		for(var/field in target_fields)
			target.add_points(field, 1)
			remaining_points -= 1
		if(remaining_points == prev_points)
			break

	// TODO: Make this less snowflakey.
	var/obj/machinery/destructive_analyzer/analyzer = analyzed.loc
	if(istype(analyzer))
		analyzer.process_loaded()
	else
		analyzed.physically_destroyed()

/decl/theory_type/concluding
	name = "Conclusion"
	uid = "conclusion_theory"

	special = TRUE
	allow_dupl = TRUE
	specification_choices = list(
		/decl/specification_type/material_cost,
		/decl/specification_type/manual_finish,
		/decl/specification_type/instability
		)

/decl/theory_type/concluding/get_description(strength, list/increased, list/decreased, list/flagged)
	return "Conclude this portion of your research. Finalize your design if all research requirements have been satisfied, or add [POINTS_PER_TIER] research points"

/decl/theory_type/concluding/check_requirements(datum/computer_file/data/design/target, obj/item/analyzed)
	if(target.tier < min_tier)
		return THEORY_INCOMPATIBLE
	if(!target.can_progress())
		return THEORY_CANNOT_PROGRESS
	return THEORY_SUCCESS

/decl/theory_type/concluding/affect_design(datum/computer_file/data/design/target, strength, list/increased, list/decreased, list/flagged, obj/item/analyzed)
	target.progress_tier()

/decl/theory_type/concluding/tier2
	uid = "conclusion_theory2"
	min_tier = 2

	specification_choices = list(
		/decl/specification_type/instability/two,
		/decl/specification_type/cold_production,
		/decl/specification_type/dark_room,
		/decl/specification_type/stock_part/runs_hot
		)

/decl/theory_type/concluding/tier3
	uid = "conclusion_theory3"
	min_tier = 3

	specification_choices = list(
		/decl/specification_type/instability/three,
		/decl/specification_type/hypoxic_production,
		/decl/specification_type/cold_production,
		/decl/specification_type/fired_finish,
		/decl/specification_type/stock_part/hypoxic,
		/decl/specification_type/stock_part/rad_emitter,
		/decl/specification_type/stock_part/low_pressure,
		)

/decl/theory_type/concluding/tier4
	uid = "conclusion_theory4"

	min_tier = 4