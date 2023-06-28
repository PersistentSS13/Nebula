/obj/effect/overmap/visitable
	should_save = TRUE 		 // Overmap sectors move themselves from the overmap to either a z-level or an area for landable ships on save.TRUE
					  		 // If the area or z-level is saved, the overmap effect will be saved.
	var/atom/old_loc	 	 // Where the ship was prior to saving. Used to relocate the ship following saving, not on load.

	//#FIXME: Don't store this here.
	var/rent_amount = 15000	  // The amount of rent per period.
	var/paid_rent = 0		  // The rent paid so far.
	var/rent_period = 14 DAYS // Time between rent payments.
	var/last_due			  // The last time the rent was due.

/obj/effect/overmap/visitable/Initialize()
	. = ..()
	events_repository.register(/decl/observ/world_saving_start_event, SSpersistence, src, .proc/on_saving_start)
	events_repository.register(/decl/observ/world_saving_finish_event, SSpersistence, src, .proc/on_saving_end)
	if(!last_due)
		last_due = world.realtime

/obj/effect/overmap/visitable/Destroy()
	. = ..()
	events_repository.unregister(/decl/observ/world_saving_start_event, SSpersistence, src)
	events_repository.unregister(/decl/observ/world_saving_finish_event, SSpersistence, src)

/obj/effect/overmap/visitable/proc/on_saving_start()
	// Record where to replace the sector upon reinitialization
	start_x = x
	start_y = y

	CUSTOM_SV("old_loc", loc)

	// Force move the sector to its z level(s) so that it can properly reinitialize.
	forceMove(locate(world.maxx/2, world.maxy/2, max(map_z)))

	if(check_rent())
		for(var/sector_z in map_z)
			SSpersistence.AddSavedLevel(sector_z)

/obj/effect/overmap/visitable/proc/on_saving_end()
	for(var/sector_z in map_z)
		SSpersistence.RemoveSavedLevel(sector_z)
	forceMove(LOAD_CUSTOM_SV("old_loc"))
	CLEAR_SV("old_loc")

/obj/effect/overmap/visitable/proc/check_rent()
	if(!SSpersistence.rent_enabled || (world.realtime < last_due + rent_period))
		return TRUE
	if(paid_rent - rent_amount >= 0)
		paid_rent -= rent_amount
		last_due = world.realtime
		return TRUE
	return FALSE

//#FIXME: This has to go. It's causing hard deletes in unit tests for something that really should be handled differently.
// This is terrible, but because of when they are generated, there's no good way to override the creation of visiting_shuttle landmarks without
// a ridiculous amount of copypasta.
// /obj/effect/overmap/visitable/add_landmark(obj/effect/shuttle_landmark/landmark, shuttle_restricted_type)
// 	if(istype(landmark, /obj/effect/shuttle_landmark/visiting_shuttle))
// 		SSshuttle.unregister_landmark(landmark)
// 		qdel(landmark)
// 		return
// 	. = ..()

SAVED_VAR(/datum/planetoid_data, id)
SAVED_VAR(/datum/planetoid_data, name)
SAVED_VAR(/datum/planetoid_data, width)
SAVED_VAR(/datum/planetoid_data, height)
SAVED_VAR(/datum/planetoid_data, tallness)
SAVED_VAR(/datum/planetoid_data, topmost_level_id)
SAVED_VAR(/datum/planetoid_data, surface_level_id)
SAVED_VAR(/datum/planetoid_data, surface_area)
SAVED_VAR(/datum/planetoid_data, habitability_class)
SAVED_VAR(/datum/planetoid_data, atmosphere)
SAVED_VAR(/datum/planetoid_data, surface_color)
SAVED_VAR(/datum/planetoid_data, water_color)
SAVED_VAR(/datum/planetoid_data, rock_color)
SAVED_VAR(/datum/planetoid_data, has_rings)
SAVED_VAR(/datum/planetoid_data, ring_color)
SAVED_VAR(/datum/planetoid_data, ring_type_name)
SAVED_VAR(/datum/planetoid_data, themes)
SAVED_VAR(/datum/planetoid_data, subtemplates)
SAVED_VAR(/datum/planetoid_data, engraving_generator)
SAVED_VAR(/datum/planetoid_data, starts_at_night)
SAVED_VAR(/datum/planetoid_data, day_duration)
SAVED_VAR(/datum/planetoid_data, surface_light_level)
SAVED_VAR(/datum/planetoid_data, surface_light_color)
SAVED_VAR(/datum/planetoid_data, flora)
SAVED_VAR(/datum/planetoid_data, fauna)
SAVED_VAR_AS_TYPE(/datum/planetoid_data, strata)

//Save picked engravings
SAVED_VAR(/datum/xenoarch_engraving_flavor, picked_actors)

//Fauna Generator Sate
SAVED_VAR(/datum/fauna_generator, fauna_types)
SAVED_VAR(/datum/fauna_generator, megafauna_types)
SAVED_VAR(/datum/fauna_generator, live_fauna)
SAVED_VAR(/datum/fauna_generator, live_megafauna)
SAVED_VAR(/datum/fauna_generator, max_fauna_alive)
SAVED_VAR(/datum/fauna_generator, max_megafauna_alive)
SAVED_VAR(/datum/fauna_generator, repopulate_fauna_threshold)
SAVED_VAR(/datum/fauna_generator, repopulate_megafauna_threshold)
SAVED_VAR(/datum/fauna_generator, time_last_repop)
SAVED_VAR(/datum/fauna_generator, repopulation_interval)
SAVED_VAR(/datum/fauna_generator, species_names)
SAVED_VAR(/datum/fauna_generator, level_data_id)

//Fauna Generated State
SAVED_VAR(/datum/generated_fauna_template, min_gases)
SAVED_VAR(/datum/generated_fauna_template, max_gases)
SAVED_VAR(/datum/generated_fauna_template, body_temp_low)
SAVED_VAR(/datum/generated_fauna_template, body_temp_high)
SAVED_VAR(/datum/generated_fauna_template, body_temp_init)
SAVED_VAR(/datum/generated_fauna_template, heat_damage_per_tick)

//Flora Generator State
SAVED_VAR(/datum/planet_flora, small_flora_types)
SAVED_VAR(/datum/planet_flora, big_flora_types)
SAVED_VAR(/datum/planet_flora, grass_color)
SAVED_VAR(/datum/planet_flora, plant_colors)
SAVED_VAR(/datum/planet_flora, exuded_gases_exclusions)

SAVED_VAR(/datum/planet_flora/random, flora_diversity)
SAVED_VAR(/datum/planet_flora/random, has_trees)

//Planetoid Overmap Markers
SAVED_VAR(/obj/effect/overmap/visitable/sector/planetoid, planetoid_id)
SAVED_VAR(/obj/effect/overmap/visitable/sector/planetoid, surface_color)
SAVED_VAR(/obj/effect/overmap/visitable/sector/planetoid, water_color)