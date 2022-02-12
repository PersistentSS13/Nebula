/datum/fabricator_recipe
	var/list/item_specifications		// Specifications passed on to the normal item path.
	var/list/production_requirements	// Specifications which are checked on build before producing the normal path.
	var/list/finishing_requirements		// If this list is not null, the recipe will produce a dummy object which will require
										// the specifications in the list to be fulfilled before being completed.

	var/instability = 0

/datum/fabricator_recipe/build(turf/location, amount)
	if(length(finishing_requirements))
		. = list()
		for(var/i = 1, i <= amount, i++)
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