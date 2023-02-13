/obj/effect/overmap/visitable
	should_save = TRUE 		 // Overmap sectors move themselves from the overmap to either a z-level or an area for landable ships on save.TRUE
					  		 // If the area or z-level is saved, the overmap effect will be saved.
	var/atom/old_loc	 	 // Where the ship was prior to saving. Used to relocate the ship following saving, not on load.

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

	old_loc = loc

	// Force move the sector to its z level(s) so that it can properly reinitialize.
	forceMove(locate(world.maxx/2, world.maxy/2, map_z[1]))

	if(check_rent())
		for(var/sector_z in map_z)
			SSpersistence.AddSavedLevel(sector_z)

/obj/effect/overmap/visitable/proc/on_saving_end()
	for(var/sector_z in map_z)
		SSpersistence.RemoveSavedLevel(sector_z)
	forceMove(old_loc)

/obj/effect/overmap/visitable/proc/check_rent()
	if(!SSpersistence.rent_enabled || (world.realtime < last_due + rent_period))
		return TRUE
	if(paid_rent - rent_amount >= 0)
		paid_rent -= rent_amount
		last_due = world.realtime
		return TRUE
	return FALSE

// This is terrible, but because of when they are generated, there's no good way to override the creation of visiting_shuttle landmarks without
// a ridiculous amount of copypasta.
/obj/effect/overmap/visitable/add_landmark(obj/effect/shuttle_landmark/landmark, shuttle_restricted_type)
	if(istype(landmark, /obj/effect/shuttle_landmark/visiting_shuttle))
		SSshuttle.unregister_landmark(landmark)
		qdel(landmark)
		return
	. = ..()

SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, planetary_area)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, night)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, daycycle)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, daycolumn)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, daycycle_column_delay)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, maxx)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, maxy)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, x_origin)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, y_origin)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, x_size)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, y_size)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, shuttle_size)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, landing_points_to_place)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, rock_colors)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, plant_colors)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, grass_color)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, surface_color)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, water_color)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, water_material)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, ice_material)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, skybox_image)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, actors)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, species)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, breathgas)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, badgas)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, repopulating)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, repopulate_types)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, fauna_types)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, megafauna_types)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, animals)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, max_animal_count)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, flora_diversity)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, has_trees)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, small_flora_types)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, big_flora_types)

SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, max_themes)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, possible_themes)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, themes)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, map_generators)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, ruin_tags_whitelist)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, ruin_tags_blacklist)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, features_budget)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, possible_features)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, spawned_features)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, habitability_class)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, crust_strata)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, spawn_weight)
SAVED_VAR(/obj/effect/overmap/visitable/sector/exoplanet, weather_system)

SAVED_VAR(/datum/exoplanet_theme/mountains, rock_color)