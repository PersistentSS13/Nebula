/obj/item/stock_parts/Initialize(ml, material_key)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/stock_parts/LateInitialize()
	. = ..()
	if(persistent_id && istype(loc, /obj/machinery))
		var/obj/machinery/M = loc
		M.install_component(src, FALSE, TRUE)

/obj/item/stock_parts/on_install(obj/machinery/machine)
	. = ..()
	var/datum/extension/specification_holder/spec_holder = get_extension(src, /datum/extension/specification_holder)
	if(spec_holder && !spec_holder.is_processing)
		if(spec_holder.process_on_install)
			START_PROCESSING(SSspecifications, spec_holder)

/obj/item/stock_parts/on_uninstall(obj/machinery/machine, temporary)
	. = ..()
	var/datum/extension/specification_holder/spec_holder = get_extension(src, /datum/extension/specification_holder)
	if(spec_holder && spec_holder.is_processing)
		if(!spec_holder.auto_process)
			STOP_PROCESSING(SSspecifications, spec_holder)

	
