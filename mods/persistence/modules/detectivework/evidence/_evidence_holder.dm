#define EVIDENCE_SPOIL_TIME 2 DAYS

/datum/extension/forensic_evidence
	should_save = TRUE

	var/last_updated 

/datum/extension/forensic_evidence/add_data(evidence_type, data)
	. = ..()
	last_updated = world.realtime

/datum/extension/forensic_evidence/remove_data(evidence_type)
	. = ..()
	last_updated = world.realtime

/datum/extension/forensic_evidence/should_save(object_parent)
	if(world.realtime > (last_updated + EVIDENCE_SPOIL_TIME))
		return FALSE
	. = ..()

#undef EVIDENCE_SPOIL_TIME