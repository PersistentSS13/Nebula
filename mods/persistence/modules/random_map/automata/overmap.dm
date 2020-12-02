// Generates the overmap with tiles randomly set as saved/unsaved based off cellular automata.

/datum/random_map/automata/overmap
	iterations = 4
	initial_wall_cell = 50
	descriptor = "persistent overmap"
	wall_type = /turf/unsimulated/map/hazardous
	floor_type = /turf/unsimulated/map
	target_turf_type = /turf/unsimulated/map