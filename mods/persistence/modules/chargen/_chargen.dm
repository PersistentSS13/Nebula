/decl/hierarchy/chargen
	var/ID = "none"                        // ID of this chargen-entry. Needs to be unique.
	name = "None"                          // Name of the chargen-entry. This is what the player sees.
	var/desc = "Placeholder"      		   // Generic description of this entry.
	var/list/skills
	var/whitelist_only = FALSE

/decl/hierarchy/skill/get_cost(var/level)
	return level ** 2

/datum/chargen
	var/origin						// What origin have we selected.
	var/role						// What role have we selected.
	var/completed = FALSE			// Have we completed chargen.
