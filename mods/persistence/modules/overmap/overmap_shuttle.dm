/datum/shuttle/autodock/overmap
	landing_skill_needed = SKILL_ADEPT // All landing in Persistence depends on free landing, so tune this down a bit.

/datum/shuttle/autodock/overmap/after_deserialize()
	. = ..()
	refresh_fuel_ports_list()