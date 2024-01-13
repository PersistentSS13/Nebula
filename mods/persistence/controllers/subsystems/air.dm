// TODO: Solve this issue properly
// On load, we check turfs which have been marked for update and cull any which are outside. What's likely happening is they're being marked for update before
// all z-levels are initialized, but it will take some time to track this down
/datum/controller/subsystem/air/proc/cull_updated_turfs()

	var/list/new_tiles_to_update = list()

	var/list/curr_tiles = tiles_to_update
	for(var/turf/T as anything in curr_tiles)
		if(SHOULD_PARTICIPATE_IN_ZONES(T))
			new_tiles_to_update += T

	tiles_to_update.Cut()
	tiles_to_update = new_tiles_to_update