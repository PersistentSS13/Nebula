/decl/overmap_event_handler/create_events(var/z_level, var/overmap_size, var/number_of_events)
	return

/obj/effect/overmap/event/meteor
	var/decl/asteroid_class/class // Determines material make up of asteroid when using the asteroid magnet.
	var/spent = FALSE			  // Whether or not the asteroid field has been harvested yet.

/obj/effect/overmap/event/meteor/get_scan_data(mob/user)
	return desc + (class ? "<br> You detect \a [class.name] inside the asteroid field." : "") 

/obj/effect/overmap/event/meteor/Initialize()
	. = ..()
	if(!class)
		var/list/classes = decls_repository.get_decls_of_subtype(/decl/asteroid_class/)
		var/list/weighted_classes = list()
		for(var/c_type in classes)
			var/decl/asteroid_class/C = GET_DECL(c_type)
			weighted_classes[c_type] = C.weight
		class = pickweight(weighted_classes)
	
/obj/effect/overmap/event/meteor/asteroid
	class = /decl/asteroid_class/asteroid
	colors = list(COLOR_BROWN_ORANGE)

/obj/effect/overmap/event/meteor/comet
	name = "comet field"
	class = /decl/asteroid_class/comet
	colors = list(COLOR_LIGHT_CYAN)

/obj/effect/overmap/event/meteor/rich_asteroid
	class = /decl/asteroid_class/rare
	colors = list(COLOR_ORANGE)

// Spawns overmap effects in a ring centered on the spawner.
/obj/effect/overmap_effect_spawner
	var/effect_type	// Type of effect spawned
	var/width		// The width of the ring, inwards from the radius
	var/radius		// Distance from the spawner that effects will be spawned

	var/effect_count
	var/effects_to_spawn

/obj/effect/overmap_effect_spawner/Initialize()
	. = ..()
	activate()
	return INITIALIZE_HINT_QDEL

/obj/effect/overmap_effect_spawner/proc/activate()
	var/list/target_turfs = list()
	for(var/i = 0 to (width-1))
		target_turfs |= getcircle(get_turf(src), radius-i)
	while(effect_count < effects_to_spawn && length(target_turfs))
		var/turf/T = pick(target_turfs)
		if(!locate(/obj/effect/overmap/event) in T)
			new effect_type(T)
			effect_count++
		target_turfs -= T

/obj/effect/overmap_effect_spawner/asteroids
	effect_type = /obj/effect/overmap/event/meteor/asteroid
	width = 3
	radius = 8
	effects_to_spawn = 30

/obj/effect/overmap_effect_spawner/comets
	effect_type = /obj/effect/overmap/event/meteor/comet
	width = 3
	radius = 16
	effects_to_spawn = 40

/obj/effect/overmap_effect_spawner/rich_asteroid
	effect_type = /obj/effect/overmap/event/meteor/rich_asteroid
	width = 2
	radius = 20
	effects_to_spawn = 10