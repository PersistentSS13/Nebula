/**
	Expected event proc format:
 		proc/on_chargen_state_changed(datum/source, new_state, old_state)
 */
/decl/observ/chargen/state_changed
	name = "Chargen State Changed"
	expected_type = /datum //Can be emitted from the area or the player mind

/**
	Expected event proc format:
		proc/on_player_registered(area/chargen/source, mob/player)
 */
/decl/observ/chargen/player_registered
	name = "Chargen Player Registered"
	expected_type = /area/chargen

/**
	Expected event proc format:
		proc/on_player_unregistered(area/chargen/source, mob/player)
 */
/decl/observ/chargen/player_unregistered
	name = "Chargen Player Unregistered"
	expected_type = /area/chargen