#define ASTEROID_SIZE 7
#define MAX_OBJS 10
#define MAX_MOBS 5
#define OBJ_PROB 20
#define MOB_PROB 30

/obj/machinery/asteroid_magnet
	name = "asteroid magnet"
	desc = "A massive solenoid used to attract asteroids and other such material from nearby fields for mineral acquisition."
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "injector0"
	density = 1
	idle_power_usage = 0.1 KILOWATTS // Displays etc. Actual attraction of the asteroid takes far more.
	active_power_usage = 25 KILOWATTS
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	base_type = /obj/machinery/asteroid_magnet

	var/attraction_progress = 0 // Progress towards attracting an asteroid.

/obj/machinery/asteroid_magnet/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()
	var/obj/effect/overmap/event/meteor/asteroid = get_asteroid()
	if(istype(asteroid))
		var/decl/asteroid_class/class = GET_DECL(asteroid.class)
		data["error"] = FALSE
		data["asteroid_type"] = "[class.name]"
		data["asteroid_desc"] = "[class.desc]"
		data["attracting"] = (use_power == POWER_USE_ACTIVE)
		data["progress"] = attraction_progress
	else
		data["error"] = asteroid // get_asteroid() returns an error if the asteroid could not be found.

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "asteroid_magnet.tmpl", "Asteroid Magnet Control", 400, 600)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/asteroid_magnet/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)

	if(href_list["toggle_attract"])
		if(use_power == POWER_USE_ACTIVE)
			update_use_power(POWER_USE_IDLE)
		if(use_power == POWER_USE_IDLE)
			update_use_power(POWER_USE_ACTIVE)
		return TOPIC_REFRESH

/obj/machinery/asteroid_magnet/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/asteroid_magnet/Process()
	if(stat & (BROKEN|NOPOWER) || use_power == POWER_USE_IDLE)
		return

	var/obj/effect/overmap/event/meteor/asteroid = get_asteroid()
	if(istype(asteroid)) // Check to ensure the asteroid is still in range.
		if(attraction_progress >= 100) // Successfully attracted an asteroid.
			attraction_progress = 0
			if(!generate_asteroid(asteroid))
				visible_message(SPAN_DANGER("\The [src] flashes numerous errors!"))
			update_use_power(POWER_USE_IDLE)
			return
		attraction_progress += 5
	else
		attraction_progress = 0
		visible_message(SPAN_WARNING("\The [src] flashes an 'Out of range' error!"))
		update_use_power(POWER_USE_IDLE)
		return

/obj/machinery/asteroid_magnet/proc/generate_asteroid(var/obj/effect/overmap/event/meteor/asteroid)
	if(!asteroid || !asteroid.class)
		return FALSE
	var/turf/center_turf = get_ranged_target_turf(get_turf(src), dir, ASTEROID_SIZE+1) // +1 for the sake of not enveloping the asteroid magnet.
	if(!center_turf) // Null check just in case.
		return FALSE

	asteroid.spent = TRUE

	var/decl/asteroid_class/class = GET_DECL(asteroid.class)
	if(!class)
		return FALSE
	var/decl/strata/asteroid/asteroid_strata = pick(class.possible_stratas)
	//#FIXME: This shouldn't use exterior turfs and stratas. Just use the asteroid mining turf instead?
	if(asteroid_strata)
		// This is a little gross, but it's better than having a ridiculous amount of turf subtypes.
		var/datum/level_data/LD = SSmapping.levels_by_z[z]
		LD.strata = asteroid_strata
		LD.setup_strata()
	var/list/outer_types = class.outer_types // Rocks etc.
	var/list/inner_types = class.inner_types // Minerals, open turfs etc.
	var/list/object_types = class.object_types
	var/list/mob_types = class.mob_types

	if(!length(outer_types) || !length(inner_types))
		return FALSE

	for(var/mob/living/M in range(10, src))
		shake_camera(M, 10, 5)

	for(var/mob/living/M in range(ASTEROID_SIZE, center_turf))
		// Don't be standing where the asteroid is about to be.
		M.throw_at(get_random_edge_turf(global.reverse_dir[dir],TRANSITIONEDGE + 2, z), 250, 5)

	var/list/target_turfs = RANGE_TURFS(center_turf, ASTEROID_SIZE)

	var/num_objs = 0
	var/num_mobs = 0

	for(var/turf/T in target_turfs)

		if(!istype(T, /turf/space) && !istype(get_area(T), /area/space))
			continue // No dropping asteroids in the middle of a room.

		var/dist = get_dist(center_turf, T) // Determine how far away the turf is from the center. Nearer tiles have much a much lower chance of being empty.
		var/det = max(0, dist + rand(-1, 1))
		var/out_ub = ASTEROID_SIZE
		var/out_lb = ASTEROID_SIZE/2

		var/in_ub = ASTEROID_SIZE/2 - 1
		var/in_lb = 0

		//#FIXME: This shouldn't use exterior turfs and stratas.

		// This doesn't play nicely with a switch statement.
		if(det >= out_lb && det <= out_ub)
			T = T.ChangeTurf(pick(outer_types))
		else if(det >= in_lb && det <= in_ub)
			T = T.ChangeTurf(pick(inner_types))


		if(length(mob_types) && !T.density && num_mobs < MAX_MOBS && prob(MOB_PROB)) // Only spawn mobs on non-dense turfs.
			num_mobs++
			var/mob_type = pickweight(mob_types)
			new mob_type(T)

		if(length(object_types) && !T.density && num_objs < MAX_OBJS && prob(OBJ_PROB))
			if(!class.objs_inside_only || (det >= in_lb && det <= in_ub))
				num_objs++
				var/obj_type = pickweight(object_types)
				new obj_type(T)

	playsound(src, 'sound/effects/metalscrape3.ogg', 50, 2)
	visible_message(SPAN_NOTICE("There's a terrible sound of screeching metal as \the [src] attracts a neaby asteroid!"))

	return TRUE

/obj/machinery/asteroid_magnet/proc/get_asteroid()
	var/obj/effect/overmap/visitable/curr_sector = global.overmap_sectors["[z]"]
	if(!curr_sector)
		return "Could not find orientation in space!"
	if(!istype(curr_sector) || istype(curr_sector, /obj/effect/overmap/visitable/ship/landable))
		return "Cannot attract an asteroid from this location!"
	if(!curr_sector.is_still())
		return "Cannot attract an asteroid while the sector is in motion!"
	var/found_spent = FALSE // Let players know that the asteroid field has been spent.
	for(var/obj/effect/overmap/event/meteor/M in SSmapping.overmap_event_handler.hazard_by_turf[get_turf(curr_sector)])
		if(!M.spent)
			return M // Return the first unspent asteroid field found in the same tile as the ship/station that the asteroid magnet is attached to.
		else
			found_spent = TRUE

	return found_spent ? "Asteroid field has already been exhausted!" : "Could not detect asteroid!"

/obj/item/stock_parts/circuitboard/asteroid_magnet
	name = "circuitboard (asteroid magnet)"
	board_type = "machine"
	build_path = /obj/machinery/asteroid_magnet
	origin_tech = "{'magnets':2}"
	req_components = list(
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/micro_laser = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

#undef ASTEROID_SIZE
#undef MAX_OBJS
#undef MAX_MOBS
#undef OBJ_PROB
#undef MOB_PROB