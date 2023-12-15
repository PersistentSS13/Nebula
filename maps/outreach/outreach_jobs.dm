/datum/map/outreach
	default_job_type = /datum/job/colonist
	allowed_jobs     = list(/datum/job/colonist)

/datum/job/colonist
	title = "Colonist"
	department_types = list(/decl/department/civilian)
	outfit_type = /decl/hierarchy/outfit/job/outreach
	hud_icon = "hudblank"
	total_positions = -1 //Infinite slots
	announced = FALSE
	forced_spawnpoint = /decl/spawnpoint/chargen

/decl/hierarchy/outfit/job/outreach
	name = "Job - Outreach Colonist"
	id_type = /obj/item/card/id/network
	pda_type = null
	pda_slot = null
	l_ear = null
	r_ear = null