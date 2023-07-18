/obj/machinery/cloning_pod
	name = "cloning pod"
	desc = "Clones a backup of a deceased crew member."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "pod_0"
	density = TRUE
	anchored = TRUE

	idle_power_usage = 250
	active_power_usage = 5 KILOWATTS

	base_type = /obj/machinery/cloning_pod
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null

	var/initial_network_id
	var/initial_network_key

	var/atom/movable/occupant = null

	var/allow_occupant_types = list(
		/mob/living/carbon/human,
		/obj/item/organ/internal/stack
	)
	var/disallow_occupant_types = list()
	var/error

/obj/machinery/cloning_pod/Initialize()
	. = ..()
	set_extension(src, /datum/extension/network_device/cloning_pod, initial_network_id, initial_network_key, RECEIVER_STRONG_WIRELESS)
	if(occupant)
		eject()

/obj/machinery/cloning_pod/receive_mouse_drop(atom/dropping, mob/living/user)
	if(dropping != user)
		return
	attempt_enter(dropping, user, "[user] starts putting [dropping] into \the [src].")

/obj/machinery/cloning_pod/attackby(var/obj/item/G, var/mob/user)
	if(istype(G, /obj/item/grab))
		var/obj/item/grab/grab = G
		attempt_enter(grab.affecting, user, "[user] starts putting [grab.affecting] into \the [src].")

	if(istype(G, /obj/item/organ/internal/stack))
		attempt_enter(G, user, "[user] starts putting [G] into \the [src].")
	return ..()

/obj/machinery/cloning_pod/proc/check_occupant_allowed(mob/M)
	var/correct_type = 0
	for(var/type in allow_occupant_types)
		if(istype(M, type))
			correct_type = 1
			break

	if(!correct_type) return 0

	for(var/type in disallow_occupant_types)
		if(istype(M, type))
			return 0

	return 1

/obj/machinery/cloning_pod/interface_interact(user)
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	D.ui_interact(user)
	return TRUE

/obj/machinery/cloning_pod/ui_data(mob/user, ui_key)
	var/list/data[0]
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(!istype(D))
		error = "HARDWARE FAILURE: NETWORK DEVICE NOT FOUND"
		data["error"] = error
		return data
	data["error"] = error
	data += D.ui_data(user, ui_key)
	return data

/obj/machinery/cloning_pod/power_change()
	. = ..()
	if(.)
		update_network_status()

/obj/machinery/cloning_pod/set_broken(new_state, cause = MACHINE_BROKEN_GENERIC)
	. = ..()
	if(.)
		update_network_status()

/obj/machinery/cloning_pod/on_update_icon()
	. = ..()
	icon_state = "pod_[occupant ? "1" : "0"]"

/obj/machinery/cloning_pod/proc/update_network_status()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(!D)
		return
	if(operable())
		D.connect()
	else
		D.disconnect()

/obj/machinery/cloning_pod/verb/eject()
	set name = "Eject Pod"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0)
		return
	if(eject_occupant())
		add_fingerprint(usr)

/obj/machinery/cloning_pod/verb/move_inside()
	set name = "Enter Pod"
	set category = "Object"
	set src in oview(1)

	attempt_enter(usr, usr, "\The [usr] starts climbing into \the [src].")

/obj/machinery/cloning_pod/proc/attempt_enter(var/atom/movable/target, var/mob/user, var/message)
	if(user.stat != 0 || !check_occupant_allowed(target))
		return

	if(occupant)
		to_chat(user, SPAN_NOTICE("<B>\The [src] is in use.</B>"))
		return

	if(!user.can_enter_cryopod(user))
		return

	visible_message(message, range = 3)
	if(do_after(user, 20, src))
		set_occupant(target, user)
		add_fingerprint(user)

/obj/machinery/cloning_pod/proc/set_occupant(var/atom/movable/target, var/mob/user)
	var/datum/extension/network_device/cloning_pod/D = get_extension(src, /datum/extension/network_device)
	occupant = target
	D.occupied = !!occupant
	update_icon()
	if(!target)
		D.cloning = FALSE
		D.scanning = FALSE
		return

	if(istype(target, /mob))
		var/mob/M = target
		M.forceMove(src)
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src

	if(istype(target, /obj/item/organ/internal/stack))
		var/obj/item/organ/internal/stack/S = target
		if(user && !user.unequip(S, src))
			return FALSE
		if(S.stackmob && S.stackmob.client)
			S.stackmob.client.perspective = EYE_PERSPECTIVE
			S.stackmob.client.eye = src

/obj/machinery/cloning_pod/proc/eject_occupant(var/mob/user, var/forced = FALSE)
	if(!occupant)
		return
	var/datum/extension/network_device/cloning_pod/D = get_extension(src, /datum/extension/network_device)
	// Don't allow for manual early ejection from the pod.
	if(!forced)
		if(D.scanning)
			to_chat(user, SPAN_NOTICE("Cannot eject [occupant] while scans are running."))
			return
		if(D.cloning)
			to_chat(user, SPAN_NOTICE("Cannot eject [occupant] while cloning process is active."))
			return

	var/mob/M = occupant
	if(istype(M) && M.client)
		M.client.eye = M.client.mob
		M.client.perspective = MOB_PERSPECTIVE
		M.unset_sdisability(BLINDED)

	var/obj/item/organ/internal/stack/S = occupant
	if(istype(occupant, /obj/item/organ/internal/stack) && S && S.stackmob && S.stackmob.client)
		S.stackmob.client.eye = S.stackmob.client.mob
		S.stackmob.client.perspective = MOB_PERSPECTIVE

	occupant.dropInto(get_turf(src))
	set_occupant(null)
	return TRUE