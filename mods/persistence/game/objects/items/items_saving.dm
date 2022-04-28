/obj/item/Initialize(ml, material_key)
	. = ..()
	if(persistent_id)
		//Regen coating icon cache
		if(coating)
			generate_blood_overlay()
			if(blood_overlay)
				blood_overlay.color = coating.get_color()