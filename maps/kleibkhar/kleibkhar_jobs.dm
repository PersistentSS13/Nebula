/datum/map/kleibkhar
	default_job_type = /datum/job/colonist
	allowed_jobs = list(/datum/job/colonist)

/datum/job/colonist
	title = "Colonist"
	department_types = list(/decl/department/civilian)
	outfit_type = /decl/hierarchy/outfit/job/kleibkhar
	hud_icon = "hudblank"
	total_positions = -1 //Infinite slots
	announced = FALSE
	forced_spawnpoint = /decl/spawnpoint/chargen

/decl/hierarchy/outfit/job/kleibkhar
	name = "Job - Kleibkhar Colonist"
	id_type = /obj/item/card/id/network
	pda_type = null
	pda_slot = null
	l_ear = null
	r_ear = null

/decl/spawnpoint/chargen
	name = "Chargen sucks OwO"

/decl/spawnpoint/chargen/Initialize()
	. = ..()
	LAZYINITLIST(turfs)
	for(var/obj/abstract/landmark/chargen_spawn/C in global.chargen_landmarks)
		turfs |= get_turf(C)

/decl/spawnpoint/chargen/after_join(mob/victim)
	var/turf/myturf = get_turf(victim.loc)
	var/area/chargen/A = get_area(myturf)
	if(istype(A))
		SSchargen.assign_spawn_pod(A) //Mark the pod area as reserved
	else 
		var/mess = "'[victim]' (CKEY: [victim.ckey]) spawned outside chargen for some reasons."
		log_warning(mess)
		message_staff(mess)

/datum/job/colonist/get_roundstart_spawnpoint()
	CRASH("!!!!! datum/job/colonist/get_roundstart_spawnpoint() was called! !!!!!")
