/mob/living/carbon/human/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	if(message_mode == "cortical")
		var/obj/item/organ/internal/stack/owner_stack = internal_organs_by_name[BP_STACK]
		for(var/obj/item/radio/stack_radio/sr in owner_stack?.contents)
			sr.talk_into(src, message, verb, speaking)
			used_radios += sr

	. = ..()