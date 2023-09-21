//Tools for implementing save db tests
/obj/debug
	is_spawnable_type = FALSE //Prevent unrelated unit tests from creating those.

///Object that when saved will create an error
/obj/debug/error_on_save
/obj/debug/error_on_save/Initialize(mapload)
	. = ..()
	message_staff("Error on save debug object was spawned!")
/obj/debug/error_on_save/before_save()
	. = ..()
	CRASH("obj/debug/error_on_save: Crashing save!")

//
/obj/debug/error_on_load
/obj/debug/error_on_load/Initialize(mapload)
	. = ..()
	message_staff("Error on load debug object was spawned!")
/obj/debug/error_on_save/after_deserialize()
	. = ..()
	CRASH("obj/debug/error_on_save: Crashing load!")

///Test object that always crash during after_deserialize()
/obj/debug/error_on_after_load
/obj/debug/error_on_after_load/Initialize(mapload)
	. = ..()
	message_staff("Error on after_deserialize() debug object was spawned!")