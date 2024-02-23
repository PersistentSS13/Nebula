//////////////////////////////////////////
// Save Overrides
//////////////////////////////////////////
//Overrides that have nowhere else to go.

///obj/machinery/embedded_controller
/obj/machinery/embedded_controller
	var/saved_memory

/obj/machinery/embedded_controller/before_save()
	..()
	if(istype(program))
		saved_memory = program.memory

/obj/machinery/embedded_controller/after_deserialize()
	..()
	if(saved_memory)
		program.memory = saved_memory

///datum/computer_file/report
/datum/computer_file/report/after_deserialize()
	..()
	for(var/datum/report_field/field in fields)
		field.owner = src

//Don't create more shit on reloads
/obj/machinery/power/tracker/Make(var/obj/item/solar_assembly/S)
	if(persistent_id)
		return
	. = ..()
/obj/machinery/power/solar/Make(var/obj/item/solar_assembly/S)
	if(persistent_id)
		return
	. = ..()

/obj/item/tank/after_deserialize()
	..()
	starting_pressure = 0