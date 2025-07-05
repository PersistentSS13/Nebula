//Tools for implementing save db tests
/obj/debug
	is_spawnable_type = FALSE //Prevent unrelated unit tests from creating those.

///Object meant to be saved and cause an error
/obj/debug/serialization
	should_save = TRUE
/obj/debug/serialization/Initialize(mapload)
	. = ..()
	message_staff("Debug object `[type]` was spawned! This will cause a crash in any saves it's part of!! Make sure to delete before making any live server save!")

///Object that when saved will cause an error in it's before_save() proc.
/obj/debug/serialization/error_on_save
/obj/debug/serialization/error_on_save/before_save()
	. = ..()
	CRASH("[type]: Crashing before_save()!")

///Object that when loaded will cause an error in it's Initialize() proc.
/obj/debug/serialization/error_on_load_init
/obj/debug/serialization/error_on_load_init/Initialize(mapload)
	. = ..()
	if(persistent_id)
		CRASH("[type]: Crashing Initialize()!")

///Test object that always crash during after_deserialize().
/obj/debug/serialization/error_on_after_load
/obj/debug/serialization/error_on_after_load/after_deserialize()
	. = ..()
	CRASH("[type]: Crashing after_deserialize()!")
