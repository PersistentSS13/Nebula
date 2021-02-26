/datum/map/outreach
	allowed_jobs = list(/datum/job/colonist)

/datum/job/colonist
	title = "Outreach Colonist"
	supervisors = "Your own will and conscience."
	department_types = list(/decl/department/civilian)
	outfit_type = /decl/hierarchy/outfit/job/outreach
	hud_icon = "hudcargotechnician"

/decl/hierarchy/outfit/job/outreach
	name = OUTFIT_JOB_NAME("Outreach Colonist")
	id_type = /obj/item/card/id/network
	pda_type = null
	pda_slot = null
	l_ear = null
	r_ear = null