/obj/machinery/material_processing/before_save()
	. = ..()
	if(input_turf)
		CUSTOM_SV("input_dir", get_dir(src, input_turf))
	if(output_turf)
		CUSTOM_SV("output_dir", get_dir(src, output_turf))

/obj/machinery/material_processing/after_deserialize()
	. = ..()
	var/input_dir = LOAD_CUSTOM_SV("input_dir")
	if(input_dir)
		input_turf = input_dir
		CLEAR_SV("input_dir")

	var/output_dir = LOAD_CUSTOM_SV("output_dir")
	if(output_dir)
		output_turf = output_dir
		CLEAR_SV("output_dir")