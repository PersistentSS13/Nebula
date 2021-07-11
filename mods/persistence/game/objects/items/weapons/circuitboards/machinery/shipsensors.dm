/obj/item/stock_parts/circuitboard/shipsensors/weak
	name = "circuitboard (ship sensors (basic))"
	build_path = /obj/machinery/shipsensors/weak
	board_type = "machine"
	origin_tech = "{'wormholes':1,'programming':2}"
	req_components = list(
							/obj/item/stack/cable_coil = 30,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stock_parts/micro_laser = 2,
							/obj/item/stock_parts/scanning_module = 2
						  )
	additional_spawn_components = list(
		/obj/item/stock_parts/shielding/heat = 1
	)