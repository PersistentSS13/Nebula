// Temporary override until report access is made a little more modifiable in game.
// Set all report field accesses to null when created. This doesn't effect loaded crew_records as the fields var
// is set to save.
/datum/computer_file/report/crew_record/New()
	. = ..()
	for(var/datum/report_field/field in fields)
		field.set_access(list(), list())