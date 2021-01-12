/obj/machinery/network/acl/outreach
	initial_grants = list(
		access_judge,
		access_outreach_engineer
	)

/var/const/access_judge = "ACCESS_JUDGE"
/datum/access/access_judge
	id = access_judge
	desc = "Judge"
	access_type = ACCESS_TYPE_NONE

/var/const/access_outreach_engineer = "ACCESS_OUTREACH_ENGINEER"
/datum/access/merchant
	id = access_outreach_engineer
	desc = "Outreach Engineer"
	access_type = ACCESS_TYPE_NONE
