/datum/random_map/automata/cave_system/outreach
	floor_type = /turf/exterior/barren/mining
	var/rich_mineral_turf = /turf/exterior/wall/random/high_chance

/datum/random_map/automata/cave_system/outreach/apply_to_map()
	if(!origin_x) origin_x = 1
	if(!origin_y) origin_y = 1
	if(!origin_z) origin_z = 1

	var/tmp_cell
	var/new_path
	var/num_applied = 0
	for (var/turf/T in block(locate(origin_x, origin_y, origin_z), locate(limit_x, limit_y, origin_z)))
		new_path = null
		var/area/A = get_area(T)
		if(A.ignore_mining_regen)
			continue

		tmp_cell = TRANSLATE_COORD(T.x, T.y)

		var/minerals
		switch (map[tmp_cell])
			if(DOOR_CHAR)
				new_path = mineral_turf
			if(EMPTY_CHAR)
				new_path = rich_mineral_turf
			if(FLOOR_CHAR)
				new_path = floor_type
			if(WALL_CHAR)
				new_path = wall_type

		if (!new_path)
			continue

		num_applied += 1
		T.ChangeTurf(new_path, minerals)
		get_additional_spawns(map[tmp_cell], T)

// Mining turfs may have issues finding an owner on load - upon return air, look for the owner if one does not exist
/turf/exterior/barren/mining/return_air()
	if(!owner)
		owner = LAZYACCESS(map_sectors, "[z]")
		if(!istype(owner))
			owner = null
	. = ..()

SUBSYSTEM_DEF(mining)
	name = "Mining"
	wait = 1 MINUTES
	next_fire = 1 MINUTES	// To prevent saving upon start.
	init_order = SS_INIT_MAPPING - 1
	runlevels = RUNLEVEL_GAME

	var/regen_interval = 90		// How often in minutes to generate mining levels.
	var/warning_wait = 2   		// How long to wait before regenerating the mining level after a warning.
	var/warning_message = "The ground begins to shake."
	var/collapse_message = "A deep rumbling is felt in the ground as the mines collapse!"
	var/collapse_imminent = FALSE
	var/last_collapse
	var/list/generators = list()
	var/generating_mines = FALSE

/datum/map
	var/list/mining_areas = list()

/area
	var/ignore_mining_regen = TRUE

/datum/controller/subsystem/mining/Initialize()
	Regenerate()
	last_collapse = world.timeofday

/datum/controller/subsystem/mining/fire()
	if(collapse_imminent)
		if(world.timeofday - last_collapse >= ((regen_interval + warning_wait) * 600))
			to_world(collapse_message)
			collapse_imminent = FALSE
			last_collapse = world.timeofday
			Regenerate()
	else
		if(world.timeofday - last_collapse >= regen_interval * 600)
			collapse_imminent = TRUE
			to_world(warning_message)

/datum/controller/subsystem/mining/proc/Regenerate()
	if(generating_mines)
		to_world_log("Called regenerate while already regenerating mines. Ignored.")
		return
	generating_mines = TRUE
	generators.Cut(1)
	var/list/eject_mobs = list()
	for(var/z in global.using_map.mining_areas)
		for(var/x in 1 to world.maxx)
			for(var/y in 1 to world.maxy)
				var/turf/T = locate(x, y, z)
				for(var/content in T.contents)
					if(istype(content, /mob))
						var/mob/M = content
						LAZYADD(eject_mobs, M)
	SpitOutMobs(eject_mobs, 3)


	for(var/z_level in global.using_map.mining_areas)
		var/datum/random_map/automata/cave_system/outreach/generator = new(null, TRANSITIONEDGE, TRANSITIONEDGE, z_level, world.maxx - TRANSITIONEDGE, world.maxy - TRANSITIONEDGE, FALSE, FALSE, FALSE)
		generators.Add(generator)

	// for(var/z in global.using_map.mining_areas)
	// 	for(var/x in 1 to world.maxx)
	// 		for(var/y in 1 to world.maxy)
	// 			var/turf/T = locate(x, y, z)
	// 			T.update_icon()
	generating_mines = FALSE

/obj/structure/ladder/updown/mine/climb(mob/M, obj/item/I = null)
	if(SSmining.generating_mines)
		to_chat(M, "<span class='notice'>With the ground shaking, it doesn't feel safe to climb down \the [src].</span>")
		return
	return ..(M, I)

// Spits out all mobs from the list to the Z level provided, damaging them and removing any ore.
/datum/controller/subsystem/mining/proc/SpitOutMobs(var/list/mobs, var/Z)
	if(!Z)
		CRASH("No Z level was provided for mining spitout!")

	if(!LAZYLEN(mobs))
		return

	// Try to locate any exoplanet turfs
	var/list/turfs = block(locate(1, 1, Z), locate(world.maxx, world.maxy, Z))
	var/list/good_turfs = list()
	for(var/turf/T in turfs)
		if(istype(T, /turf/exterior))
			LAZYDISTINCTADD(good_turfs, T)

	// If we can't, find the mineshaft ladder. Failing that, just eject
	// them somewhere and let the admins know
	var/turf/emergency_turf
	if(!LAZYLEN(good_turfs))
		emergency_turf = get_turf(locate(/obj/structure/ladder/updown/mine))
		if(!emergency_turf)
			emergency_turf = pick(turfs)
			message_admins("Failed to find a suitable turf to eject miners! Using [emergency_turf]!")

	for(var/mob/living/carbon/human/M in mobs)
		var/list/contents = list()
		// This searches the mob for all items, and adds them to contents.
		recursive_content_check(M, contents, 10, FALSE, FALSE, FALSE, TRUE)

		for(var/obj/item/ore/O in contents)
			LAZYREMOVE(contents, O)
			qdel(O)

		M.take_overall_damage(100, 0, null)

		if(emergency_turf)
			M.forceMove(emergency_turf)
		else
			M.forceMove(pick(good_turfs))