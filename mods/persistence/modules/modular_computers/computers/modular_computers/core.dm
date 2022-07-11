/obj/item/modular_computer/install_default_hardware()
	if(persistent_id)
		return
	. = ..()

/obj/item/modular_computer/install_default_programs()
	if(persistent_id)
		return
	. = ..()