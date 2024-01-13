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

// Currently, we don't want colonists to spawn with cash on hand, so we return 0 credits.
/datum/job/colonist/create_cash_on_hand(var/mob/living/carbon/human/H, var/datum/money_account/M)
	return 0

/decl/hierarchy/outfit/job/kleibkhar
	name = "Job - Kleibkhar Colonist"
	id_type = /obj/item/card/id/network
	pda_type = null
	pda_slot = null
	l_ear = null
	r_ear = null

