#define MAX_ANCHORED_NAME_LENGTH  50

/obj/machinery/stellar_anchor
	name = "stellar anchor"
	desc = "A stellar anchor used to register new sectors."
	icon = 'icons/obj/machines/tcomms/bus.dmi'
	icon_state = "bus"
	density = 1

	base_type = /obj/machinery/stellar_anchor
	construct_state = /decl/machine_construction/default/panel_closed

	var/list/anchored_areas
	var/list/errors

	var/sector_name									 // Name and identifying tag of the created sector, ship etc.

	var/sector_type = "sector"
	var/sector_color = COLOR_WHITE					 // Color of the sector or other objects created by the stellar anchor.

/obj/machinery/stellar_anchor/interface_interact(user)
	ui_interact(user)
	return TRUE
	
/obj/machinery/stellar_anchor/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = global.default_topic_state)
	var/data[0]
	data["anchored_areas"] = anchored_areas
	data["sector_name"] = sector_name
	data["sector_color"] = sector_color
	data["sector_type"] = capitalize(sector_type)
	if(LAZYLEN(errors))
		data["errors"] = errors

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "stellar_anchor.tmpl", "Stellar Anchor", 500, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/stellar_anchor/OnTopic(var/mob/user, href_list, var/datum/topic_state/state)
	if(href_list["launch"])
		// Cannot launch again after the sector is created.
		if(check_errors())
			var/confirm = alert(user, "This will permanently register \the [sector_type], are you sure?", "[capitalize(sector_type)] finalization", "Yes", "No")
			if(confirm == "No")
				return TOPIC_HANDLED
			launch(user)
			return TOPIC_REFRESH
		else
			to_chat(user, SPAN_WARNING("Cannot launch \the [src] due to current errors!"))
			return TOPIC_HANDLED

	else if(href_list["change_color"])
		var/new_color = input(user, "Choose a color.", "\the [src]", sector_color) as color|null
		if(new_color && new_color != sector_color)
			sector_color = new_color
			to_chat(user, SPAN_NOTICE("You set \the [src] to register \a [sector_type] with <font color='[sector_color]'>this color</font>"))
			return TOPIC_HANDLED

	else if(href_list["change_sector_name"])
		var/new_sector_name = sanitize(input(user, "Enter a new name for the created [sector_type]:", "Change [sector_type] name.") as null|text)
		if(!new_sector_name)
			return TOPIC_HANDLED
		if(length(new_sector_name) > MAX_ANCHORED_NAME_LENGTH)
			to_chat(user, SPAN_WARNING("That name is too long!"))
			return TOPIC_HANDLED
		sector_name = new_sector_name
		return TOPIC_REFRESH
	else if(href_list["check_errors"])
		check_errors()
		return TOPIC_REFRESH
	
	else if(href_list["sector_type"])
		sector_type = ((sector_type == "sector") ? "ship" : "sector")
		return TOPIC_REFRESH 

/obj/machinery/stellar_anchor/proc/launch()
	var/obj/effect/overmap/origin_sector = global.overmap_sectors["[z]"]
	if(!origin_sector) // Safety check
		return
	var/overmap_x = origin_sector.x
	var/overmap_y = origin_sector.y

	INCREMENT_WORLD_Z_SIZE // Create a new z-level for the sector to correspond to.

	new /obj/effect/portal(get_turf(src))
	qdel_self()
	var/turf/target_turf = locate(world.maxx/2, world.maxy/2, world.maxz)
	var/created_type = (sector_type == "sector") ? /obj/effect/overmap/visitable/sector/created : /obj/effect/overmap/visitable/ship/created

	new created_type(target_turf, sector_name, overmap_x, overmap_y, sector_color)

	return TRUE

// Checking for validity of launch
/obj/machinery/stellar_anchor/proc/check_errors()
	LAZYCLEARLIST(errors)
	. = TRUE

	if(!sector_name || length(sector_name) < 5)
		LAZYDISTINCTADD(errors, "\The [sector_type] name must be at least 5 characters in length")
		. = FALSE
	if(sector_type == "ship")
		for(var/shuttle_tag in SSshuttle.shuttles)
			if(sector_name == shuttle_tag)
				LAZYDISTINCTADD(errors, "\The [sector_type] name is already in use by another ship.")
				. = FALSE
	var/obj/effect/overmap/origin_sector = global.overmap_sectors["[z]"]
	if(!origin_sector)	// In case a player is launching from an area unknown to the overmap. In normal gameplay this should not occur.
		LAZYDISTINCTADD(errors, "\The [src] cannot be launched from this location")
		. = FALSE
	else if(!istype(origin_sector, /obj/effect/overmap/visitable/ship))
		LAZYDISTINCTADD(errors, "\The [src] must be launched from a ship")
		. = FALSE

	if(!LAZYLEN(errors))
		LAZYDISTINCTADD(errors, "[capitalize(sector_type)] is valid for finalization")

/obj/item/stock_parts/circuitboard/stellar_anchor
	name = "circuitboard (stellar anchor)"
	build_path = /obj/machinery/stellar_anchor
	board_type = "machine"
	origin_tech = "{'programming':1, 'engineering':1}"
	req_components = list(
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/micro_laser = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
	)
