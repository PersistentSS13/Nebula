/decl/asteroid_class/
	var/name = "Space Rock"
	var/desc = "A standard, boring space rock."
	var/weight = 50
	var/list/outer_types = list(/turf/exterior/wall/asteroid) // What the majority of the asteroid will be made out of.
	var/list/inner_types = list(/turf/exterior/wall/random/asteroid) // What the core/minerals in the asteroid will be.
	var/list/mob_types
	var/list/object_types
	var/objs_inside_only = FALSE

/decl/asteroid_class/asteroid
	name = "Asteroid"
	desc = "A silicate dense remnant of a would-be planet. Rich in metals and other materials of industrial use."
	outer_types = list(/turf/exterior/wall/asteroid)
	inner_types = list(/turf/exterior/wall/random/asteroid)
	mob_types = list(/mob/living/simple_animal/hostile/slug)

/decl/asteroid_class/comet
	name = "Comet"
	desc = "An icy ball of dust formed from beyond the system's frostline. Often contains rare volatiles and unusual chemicals trapped within its ice."
	outer_types = list(/turf/exterior/wall/comet)
	inner_types = list(/turf/exterior/wall/random/comet)

/decl/asteroid_class/carp_flesh
	name = "Carp Hive"
	weight = 5
	desc = "A terrible mass of flesh and cartilage, serves as the migratory breeding grounds for the dreaded space carp."
	outer_types = list(/turf/exterior/wall/carp_flesh)
	inner_types = list(/turf/simulated/floor/flesh)
	mob_types = list(/mob/living/simple_animal/hostile/carp = 100)

/decl/asteroid_class/wreckage
	name = "\proper Wreckage"
	weight = 10
	desc = "The wreckage of an unfortunate spacefaring vessel."
	outer_types = list(/turf/simulated/wall/damaged)
	inner_types = list(/turf/simulated/floor/plating)
	object_types = list(
		/obj/structure/rubble = 10,
		/obj/structure/girder = 20,
		/obj/structure/closet/secure_closet/engineering_electrical = 4,
		/obj/structure/closet/secure_closet/medical1 = 4,
		/obj/structure/closet/secure_closet/security = 2,
		/obj/structure/closet/secure_closet/captains = 1,
		/obj/machinery/fabricator = 2,
		/obj/machinery/optable = 2,
		/obj/machinery/portable_atmospherics/hydroponics = 5,
		/obj/machinery/vending/hydroseeds = 2,
	)
