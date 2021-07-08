/obj/machinery/material_processing/smeltery/can_eat(var/obj/item/eating)
	if(istype(eating, /obj/item/organ/internal/stack))
		return FALSE
	return ..()