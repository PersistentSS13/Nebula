#define STASIS_CRYO		"cryo"

/obj/machinery/cryopod
	var/obj/item/radio/intercom/old_intercom

/obj/machinery/cryopod/Initialize()
	old_intercom = locate() in src
	
	// While we could save the occupant var directly, this is much less likely to cause issues with floating mob references.
	var/mob/living/carbon/human/old_occupant = locate() in src
	if(old_occupant)
		occupant = old_occupant
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/cryopod/LateInitialize()
	. = ..()
	if(old_intercom)
		QDEL_NULL(old_intercom)

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

// Players shoved into this will be removed from the game and added to limbo to be deserialized later.
/obj/machinery/cryopod/despawner
	name = "experimental cryopod"
	time_till_despawn = 20

/obj/machinery/cryopod/despawner/Process()
	. = ..()
	if ((world.time - time_entered < time_till_despawn) && (occupant.ckey))
		return
	despawn_occupant()

/obj/machinery/cryopod/despawner/despawn_occupant()
	if(!occupant)
		return
	var/mob/living/carbon/human/H = occupant
	if(istype(H))
		H.home_spawn = src
		var/datum/mind/occupant_mind = occupant.mind
		if(occupant_mind)
			SSpersistence.AddToLimbo(occupant_mind, occupant_mind.unique_id, LIMBO_MIND, occupant_mind.key, TRUE)
			QDEL_NULL(occupant.mind)
		else
			return
	if(occupant.ckey)
		var/mob/new_player/new_player = new()
		new_player.ckey = occupant.ckey
	// Delete the mob.
	occupant.forceMove(null)
	qdel(occupant)
	set_occupant(null)