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
	var/owner_name = "Owner Name"
	var/lore = "A generic trade beacon not associated to any particular owner."
	var/showing_contents_of_ref
	var/list/contents_of_order = list()
	var/screen = 1
	var/selected_category

/obj/machinery/trade_beacon/powered()
	return 1

/obj/machinery/trade_beacon/power_change()
	return

/obj/machinery/trade_beacon/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)
	var/list/data = list()
	if(screen == 1)
		data["categories"] = category_names
		if(selected_category)
			data["category"] = selected_category
			data["possible_purchases"] = category_contents[selected_category]
			if(showing_contents_of_ref)
				data["showing_contents_of"] = showing_contents_of_ref
				data["contents_of_order"] = contents_of_order
	if(screen == 2)


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "trade_beacon.tmpl", "Trade Beacon", 440, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/trade_beacon/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["select_category"])
		clear_order_contents()
		selected_category = href_list["select_category"]
		return 1

	if(href_list["show_contents"])
		generate_order_contents(href_list["show_contents"])

	if(href_list["hide_contents"])
		clear_order_contents()

	if(href_list["change_tax"])
		// tax handling here

	if(href_list["set_screen"])
		clear_order_contents()
		screen = text2num(href_list["set_screen"])
		return 1
	// Items requiring cargo access go below this entry. Other items go above.
	if(!check_access(access_cargo))
		return 1

/obj/machinery/trade_beacon/proc/clear_order_contents()
	contents_of_order.Cut()
	showing_contents_of_ref = null


/obj/machinery/trade_beacon/proc/generate_order_contents(var/order_ref)
	var/decl/hierarchy/supply_pack/sp = locate(order_ref) in SSsupply.master_supply_list
	if(!istype(sp))
		return FALSE
	contents_of_order.Cut()
	showing_contents_of_ref = order_ref
	for(var/item_path in sp.contains) // Thanks to Lohikar for helping me with type paths - CarlenWhite
		var/obj/item/stack/OB = item_path // Not always a stack, but will always have a name we can fetch.
		var/name = initial(OB.name)
		var/amount = sp.contains[item_path] || 1 // If it's just one item (has no number associated), fallback to 1.
		if(ispath(item_path, /obj/item/stack)) // And if it is a stack, consider the amount
			amount *= initial(OB.amount)


		contents_of_order.Add(list(list(
			"name" = name,
			"amount" = amount
		)))

	if(sp.contains.len == 0) // Handles the case where sp.contains is empty, e.g. for livecargo
		contents_of_order.Add(list(list(
			"name" = sp.containername,
			"amount" = 1
		)))

	return TRUE


/obj/machinery/trade_beacon/proc/get_category_contents()
	if(!category_contents || !category_contents.len)
		generate_categories()
	return category_contents


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
			if((spc.hidden || !(spc.type in imports)))
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
	owner_name = "Nanotrasen"
	lore = "Nanotrasen go brrrrrrrrrrrr"
	imports = list(
		/decl/hierarchy/supply_pack/materials/steel50,
		/decl/hierarchy/supply_pack/materials/alum50,
		/decl/hierarchy/supply_pack/materials/glass50,
		/decl/hierarchy/supply_pack/materials/fiberglass50,
		/decl/hierarchy/supply_pack/materials/plastic50,
		/decl/hierarchy/supply_pack/materials/marble50,
		/decl/hierarchy/supply_pack/materials/plasteel50,
		/decl/hierarchy/supply_pack/materials/copper50,
		/decl/hierarchy/supply_pack/materials/titanium50,
		/decl/hierarchy/supply_pack/materials/ocp50,
		/decl/hierarchy/supply_pack/materials/graphite50,
		/decl/hierarchy/supply_pack/materials/gold10,
		/decl/hierarchy/supply_pack/materials/silver10,
		/decl/hierarchy/supply_pack/materials/uranium10,
		/decl/hierarchy/supply_pack/materials/diamond10,
		/decl/hierarchy/supply_pack/materials/wood50,
		/decl/hierarchy/supply_pack/materials/mahogany25,
		/decl/hierarchy/supply_pack/materials/maple50,
		/decl/hierarchy/supply_pack/materials/walnut25,
		/decl/hierarchy/supply_pack/materials/ebony25,
		/decl/hierarchy/supply_pack/materials/yew25,

		/decl/hierarchy/supply_pack/supply/toner,
		/decl/hierarchy/supply_pack/supply/cardboard_sheets,
		/decl/hierarchy/supply_pack/supply/stickies,
		/decl/hierarchy/supply_pack/supply/wpaper,
		/decl/hierarchy/supply_pack/supply/tapes,
		/decl/hierarchy/supply_pack/supply/taperolls,
		/decl/hierarchy/supply_pack/supply/bogrolls,

		/decl/hierarchy/supply_pack/engineering/electrical,
		/decl/hierarchy/supply_pack/engineering/mechanical,
		/decl/hierarchy/supply_pack/engineering/pacman_parts,
		/decl/hierarchy/supply_pack/engineering/voidsuit_engineering,

		/decl/hierarchy/supply_pack/flooring/carpetbrown,
		/decl/hierarchy/supply_pack/flooring/white_tiles,
		/decl/hierarchy/supply_pack/flooring/dark_tiles,

		/decl/hierarchy/supply_pack/medical/medical,
		/decl/hierarchy/supply_pack/medical/atk,
		/decl/hierarchy/supply_pack/medical/abk,
		/decl/hierarchy/supply_pack/medical/trauma,
		/decl/hierarchy/supply_pack/medical/bodybag,
		/decl/hierarchy/supply_pack/medical/stretcher,
		/decl/hierarchy/supply_pack/medical/wheelchair,
		/decl/hierarchy/supply_pack/medical/rescuebag,
		/decl/hierarchy/supply_pack/medical/doctorgear,
		/decl/hierarchy/supply_pack/medical/autopsy,
		/decl/hierarchy/supply_pack/medical/surgery,
		/decl/hierarchy/supply_pack/medical/sterile,
		/decl/hierarchy/supply_pack/medical/scanner_module,
		/decl/hierarchy/supply_pack/medical/defib,
		/decl/hierarchy/supply_pack/medical/autocomp,

		/decl/hierarchy/supply_pack/galley/food,
		/decl/hierarchy/supply_pack/galley/beef,
		/decl/hierarchy/supply_pack/galley/eggs,
		/decl/hierarchy/supply_pack/galley/milk,
		/decl/hierarchy/supply_pack/galley/pizza,
		/decl/hierarchy/supply_pack/galley/barsupplies,
		/decl/hierarchy/supply_pack/galley/party,
		/decl/hierarchy/supply_pack/galley/beer_dispenser,
		/decl/hierarchy/supply_pack/galley/soda_dispenser,

		/decl/hierarchy/supply_pack/operations/orebox,
		/decl/hierarchy/supply_pack/operations/bureaucracy,
		/decl/hierarchy/supply_pack/operations/voidsuit_engineering,

		/decl/hierarchy/supply_pack/nonessent/painters,
		/decl/hierarchy/supply_pack/nonessent/artscrafts,
		/decl/hierarchy/supply_pack/nonessent/card_packs,
		/decl/hierarchy/supply_pack/nonessent/instruments,
		/decl/hierarchy/supply_pack/nonessent/llamps,
		/decl/hierarchy/supply_pack/nonessent/chaplaingear,

		/decl/hierarchy/supply_pack/custodial/janitor,
		/decl/hierarchy/supply_pack/custodial/cleaning,
		/decl/hierarchy/supply_pack/custodial/mousetrap,
		/decl/hierarchy/supply_pack/custodial/janitorbiosuits
	)
