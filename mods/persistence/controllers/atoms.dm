/datum/controller/subsystem/atoms
	adjust_init_arguments = FALSE

/datum/controller/subsystem/atoms/InitializeAtoms()
	. = ..()
#ifndef UNIT_TEST
	SSpersistence.clear_late_wrapper_queue() // Trigger late wrappers performing any needed actions once atoms are finished Initializing.
#endif