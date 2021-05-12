/datum/extension/eye/blueprints/area_control
	expected_type = /obj/machinery/network/area_controller
	eye_type = /mob/observer/eye/blueprints/area_control

	action_type = /datum/action/eye/blueprints/area_control

/datum/action/eye/blueprints/area_control
	eye_type = /mob/observer/eye/blueprints/area_control

/datum/action/eye/blueprints/area_control/mark_new_area
	name = "Mark new area"
	procname = "create_area"
	button_icon_state = "pencil"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/area_control/remove_selection
	name = "Remove selection"
	procname = "remove_selection"
	button_icon_state = "eraser"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/area_control/edit_area
	name = "Edit area"
	procname = "edit_area"
	button_icon_state = "edit_area"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/area_control/remove_area
	name = "Remove area"
	procname = "remove_area"
	button_icon_state = "remove_area"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/area_control/claim_area
	name = "Claim area"
	procname = "claim_area"
	button_icon_state = "edit_area"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/area_control/release_area
	name = "Release area"
	procname = "release_area"
	button_icon_state = "edit_area"
	target_type = EYE_TARGET