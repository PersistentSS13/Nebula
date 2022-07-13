/mob/living/carbon/after_deserialize()
	. = ..()

	//Rebuild cached organ lists + Make sure organs get all setup correctly in-place
	for(var/key in organs_by_tag)
		var/obj/item/organ/O = organs_by_tag[key]
		add_organ(O, get_organ(O.parent_organ), TRUE, FALSE)
