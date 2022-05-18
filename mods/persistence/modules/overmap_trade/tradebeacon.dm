	/datum/beacon_export
	var/name = "Beacon Export"
	var/price_per_purchase = 1
	var/unit_per_purchase = 1
	var/unit_type
	
/obj/machinery/trade_beacon
	name = "trade beacon"
	desc = "An large broadcasting array meant to control trade between the Outreach system and the wider galaxy."
	icon = 'icons/obj/jukebox_new.dmi'
	icon_state = "jukebox3-nopower"
	anchored = 1
	density = 1
	power_channel = EQUIP
	idle_power_usage = 0
	active_power_usage = 0
	clicksound = 'sound/machines/buttonbeep.ogg'
	uncreated_component_parts = null
	stat_immune = 0
	construct_state = /decl/machine_construction/default/panel_closed
	var/list/imports = list()
	var/list/exports = list()
	var/list/category_names = list()
	var/list/category_contents = list()
	
/obj/machinery/trade_beacon/interface_interact()
  ui_interact(user)
	return TRUE


/obj/machinery/trade_beacon/powered()
	return 1

/obj/machinery/trade_beacon/power_change()
	return

/obj/machinery/trade_beacon/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)
	var/list/data = list()
	data["state"] = state
	var/name
	var/cost
	var/type_name
	var/path
	if (state == BG_READY)
		data["points"] = points
		var/list/listed_types = list()
		for(var/c_type =1 to products.len)
			type_name = products[c_type]
			var/list/current_content = products[type_name]
			var/list/listed_products = list()
			for(var/c_product =1 to current_content.len)
				path = current_content[c_product]
				var/atom/A = path
				name = initial(A.name)
				cost = current_content[path]
				listed_products.Add(list(list(
					"product_index" = c_product,
					"name" = name,
					"cost" = cost)))
			listed_types.Add(list(list(
				"type_name" = type_name,
				"products" = listed_products)))
		data["types"] = listed_types
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "trade_beacon.tmpl", "Trade Beacon", 440, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/trade_beacon/proc/get_category_contents()
	if(!category_contents || !category_contents.len)
		generate_categories()
	return catogry_contents

/obj/machinery/trade_beacon/proc/get_category_contents()
	if(!category_names || !category_names.len)
		generate_categories()
	return catogry_names

/obj/machinery/trade_beacon/proc/generate_categories()
	category_names.Cut()
	category_contents.Cut()
	var/decl/hierarchy/supply_pack/root = GET_DECL(/decl/hierarchy/supply_pack)
	var/decl/currency/cur = GET_DECL(global.using_map.default_currency)
	for(var/decl/hierarchy/supply_pack/sp in root.children)
		var/found = 0
		if(!sp.is_category())
			continue // No children
		var/list/category[0]
		for(var/decl/hierarchy/supply_pack/spc in sp.get_descendents())
			if((spc.hidden || spc.contraband || !spc.sec_available()) && !emagged || !(spc.type in imports))
				continue
			category.Add(list(list(
				"name" = spc.name,
				"cost" = cur.format_value(spc.cost),
				"ref" = "\ref[spc]"
			)))
			found = 1
		if(found)
			category_names.Add(sp.name)
			category_contents[sp.name] = category

/obj/machinery/trade_beacon/Outreach
	imports = list(
		/decl/hierarchy/supply_pack/materials/steel50,
		/decl/hierarchy/supply_pack/materials/alum50
	)