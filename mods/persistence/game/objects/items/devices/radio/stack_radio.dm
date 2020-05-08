/obj/item/radio/stack_radio
	name = "cortical receiver"
	icon = 'icons/obj/items/device/radio/beacon.dmi'
	frequency = COR_FREQ
	canhear_range = 0

	power_usage = 0

// No modification of stack_radios, if they're somehow accessed.
/obj/item/radio/stack_radio/attack_self()
	return

// Skipping a lot of checks here since cortical chat is permanently active, for most purposes.
/obj/item/radio/stack_radio/talk_into(var/mob/living/carbon/M, message, var/verb = "says", var/decl/language/speaking = null)
	if(!M || !istype(M) || !message) return 0

	var/obj/item/organ/internal/stack/mob_stack = M.internal_organs_by_name[BP_STACK]

	if(!mob_stack) return 0

	if(speaking && (speaking.flags & (NONVERBAL|SIGNLANG))) return 0

	// Sedation chemical effect prevents cortical chat use as well.
	var/mob/living/carbon/C = M
	if ((istype(C)) && (C.chem_effects[CE_SEDATE] || C.incapacitated(INCAPACITATION_DISRUPTED)))
		to_chat(M, SPAN_WARNING("You're unable to reach \the [src]."))
		return 0

	if((istype(C)) && C.radio_interrupt_cooldown > world.time)
		to_chat(M, SPAN_WARNING("You're disrupted as you reach for \the [src]."))
		return 0

	if(istype(M)) M.trigger_aiming(TARGET_CAN_RADIO) // Cortical chat can't save you here.

	if(!radio_connection)
		set_frequency(frequency)

	if(loc == M)
		playsound(loc, 'sound/effects/walkietalkie.ogg', 20, 0, -1)

	if (!istype(radio_connection))
		return 0

	var/cortical_alias = mob_stack.cortical_alias

	return Broadcast_Message(radio_connection, null, 0, pick(M.speak_emote),
					  src, message, cortical_alias, null, cortical_alias, cortical_alias,
					  0, 0, list(0), radio_connection.frequency, verb, speaking,
					  ">>", channel_color_presets["Menacing Maroon"])