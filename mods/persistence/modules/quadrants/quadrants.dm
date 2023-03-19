/datum/overmap_quadrant_controller
	var/list/all_quadrants = list()

/datum/overmap_quadrant_controller/proc/get_quadrant(var/turf/T) // turf must be off the overmap
	for(var/datum/overmap_quadrant/quadrant in all_quadrants)
		if(quadrant.check_tile(T))
			return quadrant

/datum/overmap_quadrant
	var/name = "Overmap Quadrant"
	var/desc = "A description of the overmap that highlights exclusive imports, exports, materials or enemies. Also alludes to the default security and hostility level of the quadrant."
	var/datum/monster_table/monster_table = /datum/monster_table/monster_table
	var/datum/asteroid_table/asteroid_table = /datum/asteroid_table/asteroid_table
	var/datum/security_level/security_level = /datum/security_level/security_level
	var/datum/hostility_level/hostility_level = /datum/hostility_level/hostility_level
	var/list/bounds = list()

	var/default_sec_level = 1
	var/default_hostility_level = 1

/datum/overmap_quadrant/New()
	var/list/final_bounds = list()
	for(var/x in bounds)
		var/y = bounds[x]
		final_bounds |= new /datum/overmap_tile(x,y)
	bounds = final_bounds
	monster_table = new monster_table()
	asteroid_table = new asteroid_table()
	security_level = new security_level()
	hostility_level = new hostility_level()

/datum/overmap_quadrant/proc/check_tile(var/turf/T)
	for(var/datum/overmap_tile in bounds)
		if(T.x == overmap_tile.x && T.y == overmap_tile.y)
			return 1

/datum/overmap_tile
	var/x
	var/y

/datum/overmap_tile/New(x, y)


/datum/security_level
	var/list/modifiers = list()

/datum/security_level/proc/get_security_level/(var/datum/overmap_quadrant/quadrant)
	return "TBD"


/datum/hostility_level
	var/list/modifiers = list()

/datum/hostility_level/proc/get_hostility_level/(var/datum/overmap_quadrant/quadrant)
	return "TBD"




/datum/monster_table
	var/name = "Monster Table"
	var/list/possible_monsters = list()
	var/list/active_monsters = list()
	var/list/monster_types = list()

/datum/monster_table/proc/update_active_monsters()
	active_monsters.Cut()
	for(var/datum/monster_choice/monster in possible_monsters)
		if(monster.valid_choice(src))
			active_monsters |= monster

/datum/monster_choice
	var/list/encounter_setup = list(/mob/living/simple_animal/hostile/carp = 3) // type = numbertospawn
	var/min_sec_level = 1
	var/max_sec_level = 1
	var/min_host_level = 1
	var/max_host_level = 1

/datum/monster_choice/proc/valid_choice(var/datum/overmap_quadrant/quadrant)
	if(quadrant.get_security_level < min_sec_level) return 0
	if(quadrant.get_security_level > max_sec_level) return 0
	if(quadrant.get_hostility_level < min_host_level) return 0
	if(quadrant.get_hostility_level > max_host_level) return 0
	return 1