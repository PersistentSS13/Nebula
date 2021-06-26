/obj/machinery/power/port_gen/pacman/stirling
	name = "D.I.M.A.N.-type Portable Generator" // get it? carbon dioxide? hee hee
	desc = "A portable stirling generator that utilizes coal as fuel. Can run for longer than standard PACMAN generators, but produces less power. Rated for 16 kW max safe output."
	icon_state = "portgen1"
	sheet_path = /obj/item/stack/material/graphite
	sheet_material = /decl/material/solid/mineral/graphite
	power_gen = 4000 // 16 kW at max safe power
	time_per_sheet = 192 // 98 + 98 = 192, this generator will last twice as long as a PACMAN generator - 40 minutes
	stat_immune = NOINPUT | NOSCREEN

/obj/item/stock_parts/circuitboard/pacman/stirling
	name = "circuitboard (DIMAN-type generator)"
	build_path = /obj/machinery/power/port_gen/pacman/stirling
	origin_tech = "{'powerstorage':2,'engineering':2}"
	
	req_components = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stack/cable_coil = 15
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
		)