/datum/map/persistence
	allowed_jobs = list(/datum/job/colonist)

/datum/job/colonist
	title = "Outreach Colonist"
	supervisors = "Your own will and conscience."
	department_refs = list(DEPT_CIVILIAN)
	outfit_type = /decl/hierarchy/outfit/job/outreach
	hud_icon = "hudcargotechnician"

/decl/hierarchy/outfit/job/outreach/
	name = OUTFIT_JOB_NAME("Outreach Colonist")
	pda_type = null
	pda_slot = null
	l_ear = null
	r_ear = null