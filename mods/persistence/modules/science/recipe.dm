/datum/fabricator_recipe
	var/list/item_specifications		// Specifications passed on to the normal item path.
	var/list/production_requirements	// Specifications which are checked on build before producing the normal path.
	var/list/finishing_requirements		// If this list is not null, the recipe will produce a dummy object which will require
										// the specifications in the list to be fulfilled before being completed.

	var/instability = 0

	var/research_excluded = FALSE

/datum/fabricator_recipe/build(turf/location, datum/fabricator_build_order/order)
	if(length(finishing_requirements))
		. = list()
		for(var/i in 1 to order.multiplier)
			var/obj/item/unfinished_assembly/assembly = new(location, null, path, item_specifications, finishing_requirements)
			set_extension(assembly, /datum/extension/specification_holder, finishing_requirements)
			. += assembly
		return
	
	. = ..()
	if(length(item_specifications))
		for(var/obj/item/thing in .)
			set_extension(thing, /datum/extension/specification_holder, item_specifications)

/datum/fabricator_recipe/proc/check_production_requirements(obj/machinery/fabricator/owner)
	. = TRUE
	if(length(production_requirements))
		for(var/datum/specification/spec in production_requirements)
			if(!spec.specification_act(owner))
				return FALSE

/datum/fabricator_recipe/proc/get_mod_research_cost()
	. = required_technology.Copy()
	for(var/tech in .)
		.[tech] *= TECH_POINT_MULT

// Saved vars

SAVED_VAR(/datum/fabricator_recipe, name)
SAVED_VAR(/datum/fabricator_recipe, path)
SAVED_VAR(/datum/fabricator_recipe, hidden)
SAVED_VAR(/datum/fabricator_recipe, category)
SAVED_VAR(/datum/fabricator_recipe, resources)
SAVED_VAR(/datum/fabricator_recipe, build_time)
SAVED_VAR(/datum/fabricator_recipe, item_specifications)
SAVED_VAR(/datum/fabricator_recipe, production_requirements)
SAVED_VAR(/datum/fabricator_recipe, finishing_requirements)
SAVED_VAR(/datum/fabricator_recipe, instability)
SAVED_VAR(/datum/fabricator_recipe, fabricator_types)