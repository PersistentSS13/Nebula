#define STASIS_CRYO		"cryo"

/obj/machinery/cryopod/robot/despawn_occupant()
	return

/obj/machinery/cryopod/despawn_occupant()
	return

/obj/machinery/cryopod/Process()
	if(occupant)
		if(applies_stasis && iscarbon(occupant) && (world.time > time_entered + 20 SECONDS))
			var/mob/living/carbon/C = occupant
			C.SetStasis(40, STASIS_CRYO)


/obj/machinery/cryopod/set_occupant(var/mob/living/carbon/occupant, var/silent)
	src.occupant = occupant
	if(!occupant)
		SetName(initial(name))
		return

	if(occupant.client)
		if(!silent)
			to_chat(occupant, SPAN_NOTICE("[on_enter_occupant_message]"))
		occupant.client.perspective = EYE_PERSPECTIVE
		occupant.client.eye = src
	occupant.forceMove(src)
	time_entered = world.time

	SetName("[name] ([occupant])")
	icon_state = occupied_icon_state

/obj/machinery/cryopod/verb/self_eject()
	set name = "Self-eject Pod"
	set category = "Object"
	set src in orange(0)

	if(usr != src.occupant)
		return
	icon_state = base_icon_state

	//Eject any items that aren't meant to be in the pod.
	var/list/items = contents - component_parts
	if(occupant)
		items -= occupant
		occupant.set_status(STAT_ASLEEP, 0) // Reset the sleepiness of the player so they're not permasleeping when they get out of cryo.
		occupant.set_status(STAT_DROWSY, 10)
	if(announce) items -= announce

	for(var/obj/item/W in items)
		W.dropInto(loc)

	src.go_out()
	add_fingerprint(usr)

	SetName(initial(name))
	return