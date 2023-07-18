#define STASIS_CRYO		"cryo"

/obj/machinery/cryopod
	var/obj/item/radio/intercom/old_intercom
	var/despawning = FALSE

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

/obj/machinery/cryopod/set_occupant(var/mob/living/carbon/occupant, var/silent)
	despawning = FALSE
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

	for(var/obj/item/W in items)
		W.dropInto(loc)

	src.go_out()
	add_fingerprint(usr)

	SetName(initial(name))
	return

// Players shoved into this will be removed from the game and added to limbo to be deserialized later.
/obj/machinery/cryopod/despawner
	name = "cryo storage pod"
	time_till_despawn = 60 SECONDS

//#FIXME: This messing with spawnlists could definitely be improved on.
/obj/machinery/cryopod/despawner/Initialize()
	. = ..()
	global.latejoin_locations |= get_turf(src)
	global.latejoin_cryo_locations |= get_turf(src)

/obj/machinery/cryopod/despawner/forceMove(atom/dest)
	global.latejoin_locations -= get_turf(src)
	global.latejoin_cryo_locations -= get_turf(src)
	. = ..()
	global.latejoin_locations |= get_turf(src)
	global.latejoin_cryo_locations |= get_turf(src)

/obj/machinery/cryopod/despawner/Destroy()
	global.latejoin_locations -= get_turf(src)
	global.latejoin_cryo_locations -= get_turf(src)
	. = ..()

/obj/machinery/cryopod/despawner/Process()
	if(occupant)
		if(applies_stasis && iscarbon(occupant) && (world.time > time_entered + 20 SECONDS))
			var/mob/living/carbon/C = occupant
			C.set_stasis(2)

		if(despawning)
			return

		var/time_elapsed = world.time - time_entered
		var/time_left = round((time_till_despawn - time_elapsed) / (1 SECOND))
		if((time_left > 0) && ((time_left % 5) == 0))
			to_chat(occupant, SPAN_NOTICE("[time_left] seconds left until transfer to deep storage.."))

		//Force despawn when no client
		if ((time_elapsed < time_till_despawn) && occupant.ckey)
			return

		despawn_occupant()

/obj/machinery/cryopod/despawner/despawn_occupant()
	set waitfor = FALSE
	if(!occupant)
		return
	state("Now transferring occupant [capitalize(occupant.real_name)] into long term storage. Please stand clear!")
	audible_message("\The [src] whirrs and shudders.")
	if(!occupant)
		return

	despawning = TRUE

	var/role_alt_title = occupant.mind ? occupant.mind.role_alt_title : "Unknown"
	log_and_message_admins("[key_name(occupant)] ([role_alt_title]) entered cryostorage.")
	do_telecomms_announcement(src, "[occupant.real_name], [role_alt_title], [on_store_message]", "[on_store_name]")

	var/mob/living/carbon/human/H = occupant
	if(istype(H))
		H.home_spawn = src
		var/datum/mind/occupant_mind = occupant.mind
		if(occupant_mind)
			var/success = SSpersistence.AddToLimbo(list(occupant, occupant_mind), occupant_mind.unique_id, LIMBO_MIND, occupant_mind.key, occupant_mind.current.real_name, TRUE)
			if(!success)
				log_and_message_admins("\The cryopod at ([x], [y], [z]) failed to despawn the occupant [occupant]!")
				to_chat(occupant, SPAN_WARNING("Something has gone wrong while saving your character. Contact an admin!"))
				audible_message("\The [src] emits a series of warning tones!")
				return // We don't set despawning here in order to keep the mob safe without continuously retrying despawns.
			QDEL_NULL(occupant.mind)
		else
			despawning = FALSE
			return
	if(occupant.ckey)
		var/mob/new_player/new_player = new()
		new_player.ckey = occupant.ckey

	despawning = FALSE
	// Delete the mob.
	occupant.forceMove(null)
	qdel(occupant)
	set_occupant(null)

	//Open the pod
	if(open_sound)
		playsound(src, open_sound, 40)
	icon_state = base_icon_state