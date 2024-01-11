#define MAX_THEORIES 5
#define THEORY_GEN_ATTEMPTS 20

/datum/computer_file/data/design
	filetype = "ACD"
	do_not_edit = TRUE

	var/list/research_levels = list()
	var/list/field_flags = list()
	var/list/research_requirements

	var/tier = 1
	var/remaining_points
	var/free_points = 0

	var/list/theory_options = list() // Theory -> boolean for keeping the theory after one is selected.
	var/list/specifications

	var/finalized = FALSE
	var/progressing = FALSE // Ready to select a progression/finalization theory.

	var/datum/fabricator_recipe/recipe

	var/static/list/random_fields = list(TECH_MATERIAL, TECH_POWER, TECH_BIO, TECH_DATA, TECH_ENGINEERING, TECH_EXOTIC_MATTER, TECH_COMBAT, TECH_WORMHOLES)
	var/is_copy = FALSE // Designs can only be copied once, they cannot be copied from copies.

/datum/computer_file/data/design/New(list/md, datum/fabricator_recipe/template_recipe)
	. = ..()
	// Find the default recipe and load the required technology.
	if(template_recipe)
		recipe = new()
		recipe.required_technology = template_recipe.required_technology.Copy()
		recipe.name = template_recipe.name
		recipe.path = template_recipe.path
		recipe.resources = template_recipe.resources.Copy()
		recipe.fabricator_types = template_recipe.fabricator_types.Copy()
		research_requirements = recipe.get_mod_research_cost()

		// We use this rather than the recipe name or product name, as it does not have the 'weapon prototype (...)' etc. addition
		var/item_name = atom_info_repository.get_name_for(recipe.path, amount = 1)
		// The use of 'sanitize_for_group' is incidental, it just works well for this.
		item_name = sanitize_for_group(item_name)
		filename = "[item_name]-([replacetext(uniqueness_repository.Generate(/datum/uniqueness_generator/phrase), " ", "_")])"
		// Initialize us to zero'd research fields.
		for(var/field in research_requirements)
			add_field(field)

		var/list/picked_fields = random_fields.Copy()
		picked_fields -= research_levels // Remove all fields already in research levels

		// Build the initial theory options.
		var/list/theory_types = decls_repository.get_decls_of_subtype(/decl/theory_type/starter)
		for(var/theory in theory_types)
			if(length(theory_options) >= MAX_THEORIES)
				break
			var/decl/theory_type/theory_decl = theory_types[theory]
			if(length(research_requirements) < (theory_decl.increased_fields + theory_decl.decreased_fields + theory_decl.flagged_fields))
				continue

			var/list/theory_fields = picked_fields.Copy()

			// Select up to two incidental fields to add to the design
			var/list/incidental_fields = list()
			var/num_fields = min(length(theory_fields), 2)
			for(var/i in 1 to num_fields)
				incidental_fields += pick_n_take(theory_fields)

			var/datum/theory/starter = new(theory, research_requirements.Copy(), 4, null, null, incidental_fields)
			theory_options += starter

		remaining_points = POINTS_PER_TIER * tier

/datum/computer_file/data/design/Destroy()
	. = ..()
	QDEL_NULL_LIST(theory_options)
	QDEL_NULL_LIST(specifications)
	if(!finalized) // If the design has not been finalized, the recipe should not have any floating references.
		QDEL_NULL(recipe)

// Select the theory from the options or other sources, and attempt to apply it to the design. If it fails, the option remains until it is satisfied.
/datum/computer_file/data/design/proc/select_theory(datum/theory/selected, obj/item/analyzed, mob/user)
	// Clear the theory options for everything but the selected option.
	var/application_result = selected.apply_to_design(src, analyzed)
	if(finalized)
		return "You successfully finalize your design!"
	switch(application_result)
		if(THEORY_SUCCESS)
			if(selected in theory_options)
				theory_options[selected] = FALSE // Make sure this theory is removed from the options.

			// We can progress, generate progression theories.
			if(can_progress())
				// Remove all theory options.
				for(var/theory in theory_options)
					theory_options[theory] = FALSE
				progressing = TRUE
			generate_theories(user)
			return
		if(THEORY_NEEDS_ITEM)
			return "The theory cannot be applied with [analyzed ? "the loaded item" : "no item to be analyzed"]."
		if(THEORY_CANNOT_PROGRESS)
			// Somehow we've gotten progression options when the design can't progress. Regenerate all theories.
			generate_theories(user)
			return "Requirements for concluding the theory and progressing have not been met. Use all research points, and distribute them entirely into required fields."

		if(THEORY_INCOMPATIBLE)
			return "That theory is incompatible with the design."

/datum/computer_file/data/design/proc/generate_theories(mob/user)
	// Remove theories not marked to be kept.
	for(var/datum/theory/current_theory in theory_options)
		if(!theory_options[current_theory] || current_theory.is_special())
			theory_options -= current_theory
			qdel(current_theory)

	var/generated_theories = clamp(user.get_skill_value(SKILL_SCIENCE) + 1, 2, MAX_THEORIES)

	if(length(theory_options) >= generated_theories)
		return

	var/list/theory_paths = get_theory_options(tier, progressing)

	var/theories = length(theory_options)

	var/iterations = 0

	while((theories < generated_theories) && length(theory_paths) && (iterations < THEORY_GEN_ATTEMPTS))
		iterations++
		var/theory_path = pick(theory_paths)
		var/decl/theory_type/theory_decl = GET_DECL(theory_path)
		if(!theory_decl.allow_dupl)
			theory_paths -= theory_path

		// Some quality of life, don't generate theories which increase fields if we don't have any more points.
		if(remaining_points == 0 && theory_decl.increased_fields)
			continue
		// Determine what specifications are valid for this design.
		var/list/spec_types = theory_decl.specification_choices
		if(length(spec_types))
			spec_types = spec_types.Copy()
			for(var/spec_type in spec_types)
				var/decl/specification_type/spec_decl = GET_DECL(spec_type)
				if(!check_specification_validity(spec_decl))
					spec_types -= spec_type
			if(!length(spec_types)) // If none of the specification types are valid, move on to a different theory type.
				continue

		var/theory_value = max(1, user.get_skill_value(SKILL_SCIENCE) + rand(-1, 1))
		if(theory_value - theory_decl.rel_power < 1)
			continue
		var/datum/theory/added_theory = new(theory_decl.type, research_levels.Copy(), theory_value, spec_types)
		theory_options[added_theory] = TRUE
		theories++

/datum/computer_file/data/design/proc/check_specification_validity(decl/specification_type/spec_decl)
	for(var/path in spec_decl.valid_paths)
		if(ispath(recipe.path, path))
			. = TRUE
	if(!.)
		return
	var/list/incompatible_types = list()
	for(var/datum/specification/current_spec in specifications)
		incompatible_types |= current_spec.get_incompatible_types()
	if(spec_decl.type in incompatible_types)
		return FALSE

/datum/computer_file/data/design/proc/debug_spec(mob/user, strength = 3)
	var/spec_type = input(user, "Select the specification type") as null|anything in subtypesof(/decl/specification_type)
	if(!spec_type)
		return
	var/datum/specification = new /datum/specification(spec_type, strength)
	LAZYADD(specifications, specification)

/datum/computer_file/data/design/proc/progress_tier()
	progressing = FALSE
	for(var/field in research_requirements)
		if(research_levels[field] < research_requirements[field])
			tier += 1
			remaining_points += POINTS_PER_TIER
			return

	// All research requirements have been satisfied, finalize the design.
	finalize_design()

// In order to progress to the next tier, all points must be used and cannot be in incidental fields.
/datum/computer_file/data/design/proc/can_progress()
	if(remaining_points)
		for(var/field in research_requirements)
			if(research_levels[field] < research_requirements[field])
				return FALSE
	var/list/incidental_fields = (research_levels ^ research_requirements)
	for(var/field in incidental_fields)
		if(incidental_fields[field] > 0)
			return FALSE
	return TRUE

/datum/computer_file/data/design/proc/finalize_design()
	var/list/spec_descs = list()
	if(LAZYLEN(specifications))
		for(var/datum/specification/spec in specifications)
			spec_descs += spec.get_description()
			switch(spec.spec_type)
				if(SPEC_RECIPE)
					spec.apply_to_recipe(recipe)
				if(SPEC_PRODUCTION)
					LAZYADD(recipe.production_requirements, spec)
				if(SPEC_FINISH)
					LAZYADD(recipe.finishing_requirements, spec)
				if(SPEC_ITEM)
					LAZYADD(recipe.item_specifications, spec)

	// Once the design has been finalized, the contained recipe has all necessary information, so clear some unused vars.
	stored_data = "A design for [recipe.get_product_name()]. The following specifications have been added to the design: [english_list(spec_descs)]."
	research_levels = null
	research_requirements = null
	field_flags = null
	specifications = null // Don't qdel specifications since they are referenced by the recipe.
	QDEL_NULL_LIST(theory_options) // Theory options, on the other hand, are generated per design.
	finalized = TRUE

/datum/computer_file/data/design/proc/apply_specifications(list/new_specifications)
	LAZYDISTINCTADD(specifications, new_specifications)

/datum/computer_file/data/design/proc/add_points(field, amount, ignore_flags = FALSE)
	if(!(field in research_levels))
		return

	var/flags
	var/self_amount = amount // If a field is linked to another, it takes the original amount.
	if(!ignore_flags)
		flags = field_flags[field]

		if(flags & FIELD_BONUS)
			self_amount *= 2
		if(flags & FIELD_LOCKED)
			self_amount = 0
	var/added_points = min(remaining_points, self_amount)
	research_levels[field] += added_points
	remaining_points -= added_points
	if(flags & FIELD_LINKED)
		for(var/other_field in field_flags)
			var/other_flags = field_flags[other_field]
			if(other_flags & FIELD_LINKED)
				field_flags[other_field] &= ~FIELD_LINKED // Remove the flag so we don't start an endless loop
				add_points(other_field, amount)
	if(!ignore_flags)
		field_flags[field] = 0 // Reset the flags on the target field because they're one time use.
	return added_points

/datum/computer_file/data/design/proc/remove_points(field, amount, ignore_flags = FALSE)
	if(!(field in research_levels))
		return
	var/flags
	if(!ignore_flags)
		flags = field_flags[field]

	if(flags & FIELD_BONUS)
		amount *= 2
	if(flags & FIELD_LOCKED)
		amount = 0
	var/removed_points = min(amount, research_levels[field])
	research_levels[field] -= removed_points
	remaining_points += removed_points
	if(flags & FIELD_LINKED)
		for(var/other_field in field_flags)
			var/other_flags = field_flags[other_field]
			if(other_flags & FIELD_LINKED)
				field_flags[other_field] &= ~FIELD_LINKED // Remove the flag so we don't start an endless loop
				remove_points(other_field, amount)
	field_flags[field] = 0
	return removed_points

/datum/computer_file/data/design/proc/add_field_flag(field, flag)
	field_flags[field] |= flag

/datum/computer_file/data/design/proc/get_highest_field()
	var/max = -1
	for(var/field in research_levels)
		if(research_levels[field] > max)
			. = field
			max = research_levels[field]
		else if(research_levels[field] == max)
			. = pick(list(field, .))

/datum/computer_file/data/design/proc/get_lowest_field()
	var/min = INFINITY
	for(var/field in research_levels)
		if(research_levels[field] < min && research_levels[field] > 0) // Ignore 0'd fields.
			. = field
			min = research_levels[field]
		else if(research_levels[field] == min)
			. = pick(list(field, .))

/datum/computer_file/data/design/proc/use_free_point(field)
	if(!(field in research_levels))
		return
	if(free_points && remaining_points)
		add_points(field, 1)
		free_points -= 1

/datum/computer_file/data/design/proc/add_field(field)
	if(field in research_levels)
		return

	research_levels[field] = 0
	field_flags[field] = 0

/datum/computer_file/data/design/proc/discard_theory(datum/theory/discarded)
	if(!(discarded in theory_options))
		return
	theory_options[discarded] = !theory_options[discarded]

/datum/computer_file/data/design/proc/get_ui_data()
	var/list/research_data = list()
	for(var/field in research_levels)
		var/flags = field_flags[field]
		var/decl/research_field/field_decl = SSfabrication.get_research_field_by_id(field)
		var/field_data = list(
			"name" = field_decl.name,
			"field_id" = field_decl.id,
			"points" = research_levels[field],
			"req_points" = ((field in research_requirements) ? research_requirements[field] : 0),
			"bonus" = (flags & FIELD_BONUS),
			"linked" = (flags & FIELD_LINKED),
			"locked" = (flags & FIELD_LOCKED),
			)
		research_data += list(field_data)
	return research_data

/datum/computer_file/data/design/PopulateClone(var/rename = 0)
	if(!finalized || is_copy) // Only finalized designs can be copied, and only once.
		return

	var/datum/computer_file/data/design/copy = ..()
	if(!copy)
		return
	copy.recipe = recipe
	copy.is_copy = TRUE
	copy.finalized = TRUE

	copy.stored_data += " This design appears to be a copy of the original, and cannot be copied further."

	return copy

#undef MAX_THEORIES
#undef THEORY_GEN_ATTEMPTS

// Saved vars

SAVED_VAR(/datum/computer_file/data/design, research_levels)
SAVED_VAR(/datum/computer_file/data/design, field_flags)
SAVED_VAR(/datum/computer_file/data/design, research_requirements)
SAVED_VAR(/datum/computer_file/data/design, tier)
SAVED_VAR(/datum/computer_file/data/design, remaining_points)
SAVED_VAR(/datum/computer_file/data/design, free_points)
SAVED_VAR(/datum/computer_file/data/design, specifications)
SAVED_VAR(/datum/computer_file/data/design, finalized)
SAVED_VAR(/datum/computer_file/data/design, recipe)







