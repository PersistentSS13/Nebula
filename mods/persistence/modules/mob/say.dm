/mob/living/carbon/human/parse_message_mode(message, standard_mode)
	if(length(message) >= 1 && copytext(message,1,2) == get_prefix_key(/decl/prefix/cortical_chat)) // Prefix adjustable in preferences.
		return "cortical"
	
	. =..()