/datum/fabricator_build_order
	var/power_usage
	var/instability = 0
	var/last_instability_check

	var/build_time // Blueprints use different build time calculations, so we need to keep track of the initial build time.

/obj/machinery/fabricator/update_current_build(var/spend_time)
	// Check if the production requirement specifications of the current design is met. If not, fail and move on.
	if(!currently_building.target_recipe.check_production_requirements(src))
		visible_message(SPAN_WARNING("\The [src] flashes numerous errors before spitting out some sparks! It seems whatever it was building failed."))
		
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, loc)
		sparks.start()
		
		QDEL_NULL(currently_building)
		get_next_build()
		update_icon()
		return
	if(!istype(currently_building) || !is_functioning())
		return ..()
	if(currently_building.instability > 1 && (world.timeofday - currently_building.last_instability_check > 5 SECONDS))
		currently_building.last_instability_check = world.timeofday
		var/roll = currently_building.instability - rand(2, 100)
		if(roll > 80)
			// Explode
			explosion(loc, 2, 3, 2)
			queued_orders -= currently_building
			qdel(currently_building)
		else if (roll > 20)
			// Lose some time.
			currently_building.remaining_time += (roll - 1) / 10
		else if (roll > 0)
			// Throw some sparks.
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
			sparks.set_up(3, 0, loc)
			sparks.start()
	. = ..()