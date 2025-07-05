/**
	Level data for the chargen level. Used by the SSchargen subsystem.
 */
/datum/level_data/chargen
	name        = "chargen"
	level_id    = "chargen_pods"
	level_flags = ZLEVEL_SEALED | ZLEVEL_ADMIN

/datum/level_data/chargen/setup_level_data(skip_gen)
	. = ..()
	//Tell SSchargen we've been setup
	SSchargen.set_chargen_level_id(level_id)
