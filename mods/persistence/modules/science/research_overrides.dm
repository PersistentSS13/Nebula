// Overrides for the tech requirements of items and the exclusion of certain recipes

/obj/item/stock_parts/circuitboard/router
	origin_tech = @'{"programming":1,"magnets":1}'

/obj/item/stock_parts/circuitboard/mainframe
	origin_tech = @'{"programming":1}'

/obj/item/stock_parts/subspace/filter
	origin_tech = @'{"programming":1,"magnets":1}'

/datum/fabricator_recipe/imprinter/circuit/shuttle
	research_excluded = TRUE

/datum/fabricator_recipe/imprinter/ai
	research_excluded = TRUE

/datum/fabricator_recipe/imprinter/ai_core
	research_excluded = TRUE