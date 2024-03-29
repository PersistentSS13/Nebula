/obj/item/stock_parts/circuitboard/recycler
	name           = "circuit board (crusher)"
	build_path     = /obj/machinery/recycler
	board_type     = "machine"
	origin_tech    = @'{"engineering":2,"materials":1}'
	req_components = list()
	additional_spawn_components = list(
		/obj/item/stock_parts/matter_bin      = 2,
		/obj/item/stock_parts/manipulator     = 4,
		/obj/item/stock_parts/scanning_module = 1,
		/obj/item/stock_parts/power/apc/buildable = 1,
	)

/datum/fabricator_recipe/imprinter/circuit/recycler
	path = /obj/item/stock_parts/circuitboard/recycler
