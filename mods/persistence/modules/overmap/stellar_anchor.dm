#define BASE_TURF_UPKEEP_COST 	  50
#define MAX_SHIP_TILES		  	 300
#define MAX_ANCHORED_NAME_LENGTH  50
GLOBAL_LIST_EMPTY(stellar_anchors)

/obj/machinery/network/stellar_anchor
	name = "stellar anchor"
	main_template = "stellar_anchor.tmpl"

	var/list/anchored_areas
	var/list/errors
	var/gen_fluff = "sector"

	var/should_launch = FALSE						 // Used to determine when launching blurb should be added to the UI.
	var/sector_name									 // Name and identifying tag of the created sector, shuttle, ship etc.
	var/obj/effect/overmap/visitable/created_sector  // Keep track of the created effect to prevent spam creation of sectors.
	var/sector_type = /obj/effect/overmap/visitable/sector/created
	var/sector_color = COLOR_WHITE					 // Color of the sector or other objects created by the stellar anchor.

/obj/machinery/network/stellar_anchor/Initialize()
	. = ..()
	GLOB.world_saving_event.register(SSpersistence, src, /obj/machinery/network/stellar_anchor/proc/on_world_saving)
	GLOB.stellar_anchors += src
	set_extension(src, /datum/extension/eye/stellar_anchor)

/obj/machinery/network/stellar_anchor/Destroy()
	. = ..()
	GLOB.world_saving_event.unregister(SSpersistence, src)
	GLOB.stellar_anchors -= src

/obj/machinery/network/stellar_anchor/proc/on_world_saving()
	if(is_paid())
		refresh_anchored_areas()
		for(var/A in anchored_areas)
			SSpersistence.AddSavedArea(A)

/obj/machinery/network/stellar_anchor/ui_data(var/mob/user, ui_key)
	. = ..()
	.["anchored_areas"] = anchored_areas
	.["sector_name"] = sector_name
	.["should_launch"] = should_launch
	.["created_sector"] = !!created_sector
	.["sector_color"] = sector_color
	if(LAZYLEN(errors))
		.["errors"] = errors

/obj/machinery/network/stellar_anchor/OnTopic(var/mob/user, href_list, var/datum/topic_state/state)
	. = ..()
	if(.)
		return
	if(href_list["select_areas"])
		var/datum/extension/eye/anchor_eye = get_extension(src, /datum/extension/eye)
		anchor_eye.look(user)
		return TOPIC_REFRESH
	if(href_list["should_launch"])
		if(!created_sector)
			should_launch = !should_launch
		else
			should_launch = TRUE // Safety in case should_launch gets reset.
		check_errors()
		return TOPIC_REFRESH
	if(href_list["launch"])
		if(!created_sector) // Cannot launch again after the sector is created.
			if(check_errors()) 
				var/confirm = alert(user, "This will permanently register \the [gen_fluff], are you sure?", "[capitalize(gen_fluff)] finalization", "Yes", "No")
				if(confirm == "No")
					return TOPIC_HANDLED
				launch(user)
				return TOPIC_REFRESH
			else
				to_chat(user, SPAN_WARNING("Cannot launch \the [src] due to current errors!"))
				return TOPIC_HANDLED
	if(href_list["change_color"])
		var/new_color = input(user, "Choose a color.", "\the [src]", sector_color) as color|null
		if(new_color && new_color != sector_color)
			sector_color = new_color
			to_chat(user, SPAN_NOTICE("You set \the [src] to register \a [gen_fluff] with <font color='[sector_color]'>this color</font>"))
			return TOPIC_HANDLED

	if(href_list["change_sector_name"])
		var/new_sector_name = sanitize(input(user, "Enter a new name for the created [gen_fluff]:", "Change [gen_fluff] name.") as null|text)
		if(!new_sector_name)
			return TOPIC_HANDLED
		if(length(new_sector_name) > MAX_ANCHORED_NAME_LENGTH)
			to_chat(user, SPAN_WARNING("That name is too long!"))
			return TOPIC_HANDLED
		sector_name = new_sector_name
		return TOPIC_REFRESH
	if(href_list["check_errors"])
		check_errors()
		return TOPIC_REFRESH

/obj/machinery/network/stellar_anchor/proc/add_area(var/area/area_to_add)
	. = list()
	if(should_launch && !created_sector)
		. += "\the [src] must be launched before areas are anchored"
	if(!is_valid_location(FALSE))
		. += "\the [src] is unable to function in this location"
	if(istype(area_to_add, /area/space) || istype(area_to_add, /area/exoplanet))
		. += "this area cannot be anchored"
	if(area_to_add in anchored_areas)
		. += "this area is already being anchored by \the [src]"
	else
		for(var/obj/machinery/network/stellar_anchor/other_anchor in GLOB.stellar_anchors)
			if(area_to_add in other_anchor.anchored_areas)
				. += "this area is already being anchored by another stellar anchor"
				break

	if(!LAZYLEN(.))
		LAZYDISTINCTADD(anchored_areas, area_to_add)

/obj/machinery/network/stellar_anchor/proc/remove_area(var/area/area_to_remove)
	LAZYREMOVE(anchored_areas, area_to_remove)

// returns whether or not the place the stellar_anchor is, is a viable place to actually anchor/persist something. Broader checks for sectors and z-levels.
/obj/machinery/network/stellar_anchor/proc/is_valid_location(var/produce_error = TRUE)
	var/turf/T = get_turf(src)
	if(T.z in SSpersistence.saved_levels)
		if(produce_error)
			error = "This location is already stabilized."
		return FALSE

	var/obj/effect/overmap/visitable/sector/sector = map_sectors["[T.z]"]
	if(istype(sector, /obj/effect/overmap/visitable/sector/exoplanet) || !(sector.sector_flags & OVERMAP_SECTOR_IN_SPACE))
		if(produce_error)
			error = "Cannot anchor a stellar body this large."
		return FALSE
	return TRUE

/obj/machinery/network/stellar_anchor/proc/get_anchored_turf_count()
	. = 0
	for(var/area/A in anchored_areas)
		.+= length(A)

// The amount in moneys to upkeep this every week.
/obj/machinery/network/stellar_anchor/proc/get_upkeep()
	return get_anchored_turf_count() * BASE_TURF_UPKEEP_COST

// The amount in moneys to found this stellar anchor.
/obj/machinery/network/stellar_anchor/proc/get_founding_cost()
	return get_upkeep() * 1.5

/obj/machinery/network/stellar_anchor/proc/is_paid()
	return TRUE

/obj/machinery/network/stellar_anchor/proc/launch(var/mob/user)

	var/obj/effect/overmap/origin_sector = map_sectors["[z]"]
	if(!origin_sector) // Safety check
		return
	var/overmap_x = origin_sector.x
	var/overmap_y = origin_sector.y

	INCREMENT_WORLD_Z_SIZE // Create a new z-level for the sector to correspond to.
	
	// Move the anchor to the center of the new z-level.
	var/turf/target_turf = locate(world.maxx/2, world.maxy/2, world.maxz)
	target_turf.ChangeTurf(/turf/simulated/floor/plating)
	new /obj/effect/portal(get_turf(src))
	src.forceMove(target_turf)
	created_sector = new sector_type(target_turf, sector_name, overmap_x, overmap_y, sector_color)
	
	return TRUE

// Checking for validity of launch
/obj/machinery/network/stellar_anchor/proc/check_errors()
	LAZYCLEARLIST(errors)
	. = TRUE

	if(LAZYLEN(anchored_areas))
		LAZYDISTINCTADD(errors, "\The [src] cannot be launched while anchoring areas")
		. = FALSE
	if(!sector_name || length(sector_name) < 5)
		LAZYDISTINCTADD(errors, "\The [gen_fluff] name must be at least 5 characters in length")
		. = FALSE
	var/obj/effect/overmap/origin_sector = map_sectors["[z]"]
	if(!origin_sector)	// In case a player is launching from an area unknown to the overmap. In normal gameplay this should not occur.
		LAZYDISTINCTADD(errors, "\The [src] cannot be launched from this location")
		. = FALSE
	else if(!istype(origin_sector, /obj/effect/overmap/visitable/ship/))
		LAZYDISTINCTADD(errors, "\The [src] must be launched from a ship")
		. = FALSE
	
	if(!LAZYLEN(errors))
		LAZYDISTINCTADD(errors, "[capitalize(gen_fluff)] is valid for finalization")

/obj/machinery/network/stellar_anchor/after_save()
	. = ..()
	if(is_paid())
		for(var/A in anchored_areas)
			SSpersistence.RemoveSavedArea(A)

// Refreshes the anchored_areas list if necessary.
/obj/machinery/network/stellar_anchor/proc/refresh_anchored_areas()

// Ship core for shuttles specifically.
/obj/machinery/network/stellar_anchor/ship_core
	name = "ship core"
	main_template = "ship_core.tmpl"
	sector_type = /obj/effect/overmap/visitable/ship/created
	gen_fluff = "ship"

	var/datum/shuttle/parent_shuttle
	var/is_landable = TRUE

/obj/machinery/network/stellar_anchor/ship_core/ui_data(var/mob/user, ui_key)
	. = ..()
	.["finalized"] = parent_shuttle
	if(LAZYLEN(errors))
		.["errors"] = errors

/obj/machinery/network/stellar_anchor/ship_core/OnTopic(var/mob/user, href_list, var/datum/topic_state/state)

	// No adding or removing areas after the ship is finalized.
	if(href_list["select_areas"])
		if(parent_shuttle)
			to_chat(user, SPAN_WARNING("You can no longer edit the anchored areas!"))
			return TOPIC_HANDLED
	. = ..()
	if(.)
		return
	user.reset_view()
	if(href_list["finalize"])
		if(check_errors())
			var/confirm = alert(user, "This will permanently finalize the [gen_fluff], are you sure?", "[capitalize(gen_fluff)] finalization", "Yes", "No")
			if(confirm == "No")
				return TOPIC_HANDLED
			else
				create_landable_ship()
				return TOPIC_REFRESH

/obj/machinery/network/stellar_anchor/ship_core/after_save()
	. = ..()
	
	if(istype(parent_shuttle) && length(anchored_areas) && SSpersistence.in_loaded_world)
		// Landmark it
		var/obj/effect/shuttle_landmark/ship/landmark = new()
		landmark.shuttle_name = parent_shuttle.name
		landmark.loc = loc

		// Rebuild shuttle effect.
		var/obj/effect/overmap/visitable/ship/landable/ship = new()
		ship.name = parent_shuttle.name
		ship.loc = loc
		ship.shuttle = parent_shuttle
		ship.landmark = landmark

// Ship cores create ships that do not stay in one z-level, so some checks are unnecessary.
/obj/machinery/network/stellar_anchor/ship_core/is_valid_location(var/produce_error = TRUE)
	var/turf/T = get_turf(src)
	var/area/A = get_area(T)
	for(var/obj/machinery/network/stellar_anchor/other_anchor in GLOB.stellar_anchors)
		if(other_anchor == src)
			continue
		if(A in other_anchor.anchored_areas)
			if(produce_error)
				error = "This area is already stabilized by another stellar anchor."
			return FALSE
	return TRUE

/obj/machinery/network/stellar_anchor/ship_core/check_errors()
	LAZYCLEARLIST(errors)
	. = TRUE
	
	if(should_launch) // Creating a non-landable ship
		. = ..()
		return
	else
		if(parent_shuttle)
			LAZYDISTINCTADD(errors, "\The [src] is already anchoring \a [gen_fluff]!")
			return FALSE
		if(!sector_name || length(sector_name) < 5)
			LAZYDISTINCTADD(errors, "\The [gen_fluff] must have a name.")
			. = FALSE
		else	// In case another ship has an identical name.
			for(var/obj/effect/overmap/visitable/ship/ship_effect in SSshuttle.ships)
				if(sector_name == ship_effect.name)
					LAZYDISTINCTADD(errors, "\A [gen_fluff] with an identical name has already been registered.")
					. = FALSE
					break
		if(!LAZYLEN(anchored_areas))
			LAZYDISTINCTADD(errors, "\The [src] is not anchoring any areas.")
			return FALSE // Further checks require at least one area to be anchored.
		
		var/list/area_turfs = list()
		for(var/area/A in anchored_areas)
			if(LAZYLEN(area_turfs) > MAX_SHIP_TILES)
				LAZYDISTINCTADD(errors, "\The [gen_fluff] is too large.")
				return FALSE // If the ship is too large, skip contiguity checks.
			for(var/turf/T in A)
				area_turfs += T
				// Stops most tearing up the ground with the shuttle, although the landmark should not allow a hole in a planet etc. regardless.
				if(istype(T, /turf/space) || istype(T, /turf/simulated/floor/exoplanet) || istype(T, /turf/simulated/floor/asteroid))
					LAZYDISTINCTADD(errors, "The anchored area [A] contains invalid turfs.")
					. = FALSE
					break

		// Check to make sure all the ships areas are connected.			
		. = min(., check_contiguity(area_turfs))
		if(!LAZYLEN(errors))
			LAZYDISTINCTADD(errors, "\The [gen_fluff] is valid for finalization.")


/obj/machinery/network/stellar_anchor/ship_core/proc/check_contiguity(var/list/area_turfs)
	if(!area_turfs || !LAZYLEN(area_turfs))
		return FALSE
	var/turf/start_turf = pick(area_turfs) // The last added area is the most likely to be incontiguous.
	var/list/pending_turfs = list(start_turf)
	var/list/checked_turfs = list()

	while(pending_turfs.len)
		var/turf/T = pending_turfs[1]
		pending_turfs -= T
		for(var/dir in GLOB.cardinal)	// Floodfill to find all turfs contiguous with the randomly chosen start_turf.
			var/turf/NT = get_step(T, dir)
			if(!isturf(NT) || !(NT in area_turfs) || (NT in pending_turfs) || (NT in checked_turfs))
				continue
			pending_turfs += NT	

		checked_turfs += T

	if(LAZYLEN(area_turfs.Copy()) - LAZYLEN(checked_turfs)) // If there are turfs in area_turfs, not in checked_turfs there are non-contiguous turfs in the selection.
		LAZYDISTINCTADD(errors, "[capitalize(gen_fluff)] construction must be contiguous")
		return FALSE

	return TRUE

/obj/machinery/network/stellar_anchor/ship_core/proc/create_landable_ship()
	var/area/base_area

	var/obj/effect/overmap/visitable/sector/exoplanet/planet = map_sectors["[z]"]
	if(planet && istype(planet))
		base_area = ispath(planet.planetary_area) ? planet.planetary_area : planet.planetary_area.type
	else
		base_area = /area/space
	 
	var/obj/effect/shuttle_landmark/temporary/construction/landmark = new(get_turf(src), base_area, get_base_turf(z))
	parent_shuttle = new /datum/shuttle/autodock/overmap(sector_name, landmark, anchored_areas)

	var/obj/effect/overmap/visitable/ship/landable/ship = new(get_turf(src), sector_name)
	ship.color = sector_color

/obj/machinery/network/stellar_anchor/ship_core/refresh_anchored_areas()
	LAZYCLEARLIST(anchored_areas)

	if(!istype(parent_shuttle))
		return

	for(var/A in parent_shuttle.shuttle_area)
		LAZYDISTINCTADD(anchored_areas, A)

/obj/machinery/network/stellar_anchor/ship_core/add_area(var/area/area_to_add)
	. = ..()
	if(parent_shuttle)
		. += "\the [src] has already finalized the creation of \a [gen_fluff]."
		return

/obj/machinery/network/stellar_anchor/ship_core/remove_area(var/area/area_to_remove)
	if(parent_shuttle)
		return
	. = ..()

/obj/effect/shuttle_landmark/temporary/construction
	flags = null

/obj/effect/shuttle_landmark/temporary/construction/Initialize(var/mapload, var/area/base_area, var/turf/base_turf)
	src.base_area = base_area
	src.base_turf = base_turf
	. = ..(mapload)

// Landmark override
/obj/effect/shuttle_landmark/ship/Initialize(mapload, shuttle_name)
	if(!shuttle_name && src.shuttle_name)
		return ..(mapload, src.shuttle_name)
	return ..()