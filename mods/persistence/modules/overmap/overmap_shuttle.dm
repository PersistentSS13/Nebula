/datum/shuttle/autodock/overmap/after_deserialize()
	. = ..()
	refresh_fuel_ports_list()