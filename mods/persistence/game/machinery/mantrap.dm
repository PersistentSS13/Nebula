/obj/machinery/mantrap
	name = "mantrap airlock"
	desc = "A small personal airlock ubiquitous throughout colonized space. The space inside is extremely claustrophobic."
	icon = 'mods/persistence/icons/obj/machines/mantrap.dmi'
	icon_state = "mantrap_inactive"
	anchored = 1
	idle_power_usage = 80
	active_power_usage = 1000
	power_channel = ENVIRON

	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	base_type = /obj/machinery/mantrap

	layer = ABOVE_WINDOW_LAYER

	var/mob/occupant
	var/entrance_dir		  // The side on which the occupant entered.

/obj/machinery/mantrap/Process()
	if(occupant && (stat & (NOPOWER|BROKEN)))
		cancel_transport()

/obj/machinery/mantrap/Destroy()
	cancel_transport()
	. = ..()
	
/obj/machinery/mantrap/proc/attempt_enter(var/mob/target, var/mob/user)
	if(occupant)
		to_chat(user, SPAN_NOTICE("Someone is already using \the [src]!"))
		return
	if(!allowed(user)) // No access modification be default, but can use network locks.
		to_chat(user, SPAN_WARNING("Access denied!"))
		return
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, SPAN_WARNING("\The [src] isn't operational!"))
		return
	if(!user.incapacitated() && user.Adjacent(src) && user.Adjacent(target))
		visible_message(SPAN_NOTICE("[user] starts putting [target] into \the [src]."))
		if(!do_after(user, 20, src))
			return
		set_occupant(target)
		add_fingerprint(user)

/obj/machinery/mantrap/proc/set_occupant(var/mob/target)
	if(occupant)
		return
	occupant = target

	if(dir == NORTH || dir == SOUTH)
		entrance_dir = ((target.y >= y) ? NORTH : SOUTH)
	else if(dir == EAST || dir == WEST)
		entrance_dir = ((target.x >= x) ? EAST : WEST)

	if(occupant.client)
		occupant.client.perspective = EYE_PERSPECTIVE
		occupant.client.eye = src
	occupant.forceMove(src)

	to_chat(target, SPAN_NOTICE("\The [src] locks you tightly inside as the transfer process begins."))
	playsound(src, 'sound/machines/AirlockClose_heavy.ogg', 25, 1)
	update_use_power(POWER_USE_ACTIVE)
	queue_icon_update()
	addtimer(CALLBACK(src, .proc/transport_occupant), 10 SECONDS)

/obj/machinery/mantrap/proc/transport_occupant()
	update_use_power(POWER_USE_IDLE)
	queue_icon_update()
	if(!check_transfer()) // No shoving people into walls etc.
		cancel_transport()
		return
	visible_message(SPAN_NOTICE("\The [src] pings loudly as completes the transfer process!"))
	var/turf/exit_turf = get_step(src, turn(entrance_dir, 180))
	
	if(occupant.client)
		occupant.client.eye = src.occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	if(occupant in src)
		occupant.dropInto(exit_turf)
	occupant = null

/obj/machinery/mantrap/proc/cancel_transport()
	update_use_power(POWER_USE_IDLE)
	queue_icon_update()
	if(!occupant)
		occupant = null
		return
	visible_message(SPAN_WARNING("\The [src] buzzes loudly as it ejects \the [occupant]!"))
	playsound(src, 'sound/machines/chime.ogg', 25, 1)
	var/turf/exit_turf = get_step(src, entrance_dir)
	if(occupant.client)
		occupant.client.eye = src.occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	if(occupant in src)
		occupant.dropInto(exit_turf)
	occupant = null

/obj/machinery/mantrap/proc/check_transfer()
	if(stat & (NOPOWER|BROKEN))
		return FALSE
	if(!occupant)
		return FALSE
	var/turf/exit_turf = get_step(src, entrance_dir)
	if(!exit_turf || exit_turf.density)
		return FALSE
	if(TurfBlockedNonWindow(exit_turf) || DirBlocked(exit_turf, entrance_dir))
		return FALSE
	
	return TRUE

/obj/machinery/mantrap/receive_mouse_drop(mob/living/dropping, mob/living/user)
	if(occupant)
		to_chat(user, SPAN_NOTICE("\The [src] is already in use!"))
		return
	attempt_enter(dropping, user)

/obj/machinery/mantrap/attackby(var/obj/item/G, var/mob/user)
	if(istype(G, /obj/item/grab))
		var/obj/item/grab/grab = G
		if(!ismob(grab.affecting))
			return
		attempt_enter(grab.affecting, user)
	return ..()

/obj/machinery/mantrap/relaymove(var/mob/user)
	cancel_transport()

/obj/machinery/mantrap/hide(var/hide)
	if(istype(get_turf(src), /turf/simulated/wall)) // Mantrap airlocks always appear on top of walls.
		return ..(0)
	. = ..()

/obj/machinery/mantrap/on_update_icon()
	if((use_power == POWER_USE_ACTIVE) && !(stat & (NOPOWER|BROKEN)))
		icon_state = "mantrap_active"
	else
		icon_state = "mantrap_inactive"

/obj/item/stock_parts/circuitboard/mantrap
	name = "circuitboard (mantrap airlock)"
	build_path = /obj/machinery/mantrap
	board_type = "machine"
	origin_tech = "{'engineering':1,'magnets':1}"
	req_components = list(
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 1
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/datum/fabricator_recipe/imprinter/circuit/mantrap
	path = /obj/item/stock_parts/circuitboard/mantrap