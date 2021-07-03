/obj/structure/stairs
	// Being multi-tile objects, stairs do not behave nicely with the "turf contents up" serialization.
	// TO-DO: Generalize this for other multi-tile objects.
	var/saved_x
	var/saved_y

/obj/structure/stairs/Initialize()
	if(saved_x && saved_y)
		forceMove(locate(saved_x, saved_y, z))
	. = ..()
	events_repository.register(/decl/observ/world_saving_start_event, SSpersistence, src, .proc/on_save)

/obj/structure/stairs/Destroy()
	. = ..()
	events_repository.unregister(/decl/observ/world_saving_start_event, SSpersistence, src)

/obj/structure/stairs/proc/on_save()
	saved_x = x
	saved_y = y