/obj/item/stock_parts/power/battery/Initialize(ml, material_key)
	. = ..()
	var/obj/item/cell/old_cell = locate() in src
	if(old_cell)
		add_cell(null, old_cell)