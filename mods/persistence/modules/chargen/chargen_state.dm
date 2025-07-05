///Common chargen state tracking datum
/datum/chargen_state
	var/area/current_area
	var/current_state

//
// Mind Chargen State
//

/datum/mind
	/// Whether or not the mob starts with a cortical stack.
	var/chargen_stack = TRUE
	/// Temporary skillset used for character generation.
	var/tmp/datum/skillset/chargen_skillset
	/// The origin chosen for this character at chargen.
	var/decl/hierarchy/chargen/origin/origin
	/// The role chosen for this character at chargen.
	var/decl/hierarchy/chargen/role/role
	///Where through the chargen process is this mind at? If not using chargen, state set to CHARGEN_STATE_NONE.
	var/chargen_state = CHARGEN_STATE_NONE

SAVED_VAR(/datum/mind, chargen_stack)
SAVED_VAR(/datum/mind, origin)
SAVED_VAR(/datum/mind, role)
SAVED_VAR(/datum/mind, chargen_state)

//Prevent saving when in chargen
/mob/living/carbon/human/should_save()
	. = ..()
	// We don't save characters who are in chargen
	if(mind?.is_chargen_in_progress())
		return FALSE

/**
	Called by the observ event /decl/observ/chargen/state_changed, during chargen to keep everything in sync.
 */
/datum/mind/proc/set_player_chargen_state(new_state)
	var/old_state = chargen_state
	chargen_state = new_state
	RAISE_EVENT(/decl/observ/chargen/state_changed, src, chargen_state, old_state)

/**
 * Returns whether the player should be considered has having finished the character generator stuff.
 */
/datum/mind/proc/has_finished_chargen()
	return chargen_state >= CHARGEN_STATE_FINALIZED

/**
 * Returns whether the owner of this mind is currently supposed to be going through character gen.
 */
/datum/mind/proc/is_chargen_in_progress()
	return (chargen_state != CHARGEN_STATE_NONE) && (chargen_state < CHARGEN_STATE_FINALIZED)

/**

 */
/datum/mind/proc/should_spawn_with_stack()
	return chargen_stack

/**
	Set whether the mob that own this mind, should spawn with a cortical stack.
 */
/datum/mind/proc/set_spawn_with_stack(new_value)
	chargen_stack = new_value

/**
	Store the currently selected origin during chargen.
 */
/datum/mind/proc/set_chargen_origin(origin_id)
	var/decl/hierarchy/chargen/origin/origins = GET_DECL(/decl/hierarchy/chargen/origin)
	if(origin)
		for(var/skill in origin.skills)
			current.skillset.skill_list[skill] -= origin.skills[skill]

	for(var/decl/hierarchy/chargen/D in origins.children)
		if(D.ID == origin_id)
			// Found.
			origin = D
			for(var/skill in D.skills)
				current.skillset.skill_list[skill] += D.skills[skill]

/**
	Store the currently selected role during chargen.
 */
/datum/mind/proc/set_chargen_role(role_id)
	var/decl/hierarchy/chargen/role/roles = GET_DECL(/decl/hierarchy/chargen/role)
	if(role)
		for(var/skill in role.skills)
			current.skillset.skill_list[skill] -= role.skills[skill]

	for(var/decl/hierarchy/chargen/D in roles.children)
		if(D.ID == role_id)
			// Found.
			role = D
			for(var/skill in D.skills)
				current.skillset.skill_list[skill] += D.skills[skill]

/**
	Applies the chargen stuff saved in the mind during chargen setup and copy it to the mob.
 */
/datum/mind/proc/finalize_chargen_setup()
	// Updating the mob's skills with the actual chargen choices.
	var/datum/skillset/mob_skillset = current.skillset
	mob_skillset.skill_list       = chargen_skillset.skill_list.Copy()
	mob_skillset.default_value    = chargen_skillset.default_value
	mob_skillset.points_remaining += max(origin.remaining_points_offset + role.remaining_points_offset, 0)
	mob_skillset.on_levels_change()
	to_chat(current, SPAN_NOTICE("You have an additional [mob_skillset.points_remaining] skill points to apply to your character. Use the 'Adjust Skills' verb to do so"))

/datum/mind/proc/get_starter_book_type()
	return role.text_book_type