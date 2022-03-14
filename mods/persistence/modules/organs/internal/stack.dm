var/global/list/cortical_stacks = list()
/proc/switchToStack(var/obj/stack_holder, var/datum/mind/mind)
	// See if we can find the stack in whatever the holder was, usually a person.
	var/obj/item/organ/internal/stack/target = locate() in stack_holder
	if(!target)
		for(var/obj/item/organ/internal/stack/S in global.cortical_stacks)
			if(S.mind_id == mind.unique_id)
				target = S
				break
	if(!target)
		return null
	target.stackmob = new(target)
	mind.transfer_to(target.stackmob)
	to_chat(target.stackmob, SPAN_NOTICE("You feel slightly disoriented. That's normal when you're just \a [target.name]."))
	return target

/obj/item/organ/internal/stack
	name = "cortical stack"
	parent_organ = BP_HEAD
	icon_state = "cortical-stack"
	organ_tag = BP_STACK
	vital = 1
	origin_tech = "{'biotech':4,'materials':4,'magnets':2,'programming':3}"
	relative_size = 10
	
	var/mind_id
	var/datum/computer_file/data/cloning/backup
	var/mob/living/limbo/stackmob = null

	var/cortical_alias
	var/last_alias_change

/obj/item/organ/internal/stack/Initialize()
	. = ..()
	global.cortical_stacks |= src
	robotize()
	if(owner && istype(owner))
		cortical_alias = Gibberish(owner.name, 100)
		verbs |= /obj/item/organ/internal/stack/proc/change_cortical_alias

/obj/item/organ/internal/stack/Destroy()
	global.cortical_stacks -= src
	QDEL_NULL(backup)
	if(stackmob)
		stackmob.forceMove(null) // Move the stackmob to null space to allow it to otherwise resleeve.
		stackmob = null
	. = ..()

/obj/item/organ/internal/stack/examine(var/mob/user)
	. = ..(user)
	if(istype(backup)) // Do we have a backup?
		if(user.skill_check(SKILL_DEVICES, SKILL_EXPERT)) // Can we even tell what the blinking means?
			if(owner && owner.mind && find_dead_player(owner.mind.key, 1)) // Is the player still around and dead?
				to_chat(user, SPAN_NOTICE("The light on [src] is blinking rapidly. Someone might have a second chance."))
			else
				to_chat(user, "The light on [src] is blinking slowly. Maybe wait a while...")
		else
			to_chat(user, "The light on [src] is blinking, but you don't know what it means.")
	else
		to_chat(user, "The light on [src] is off. " + (user.skill_check(SKILL_DEVICES, SKILL_EXPERT) ? "It doesn't have a backup." : "Wonder what that means."))

/obj/item/organ/internal/stack/emp_act()
	return FALSE

/obj/item/organ/internal/stack/getToxLoss()
	return 0

/obj/item/organ/internal/stack/replaced()
	. = ..()
	QDEL_NULL(backup)
	update_mind_id()
	if(owner)
		owner.add_language(/decl/language/cortical)

/obj/item/organ/internal/stack/proc/update_mind_id()
	if(owner.mind)
		for(var/stack in global.cortical_stacks)
			var/obj/item/organ/internal/stack/S = stack
			if(S.mind_id == owner.mind.unique_id) // Make sure only one stack has a given mind ID.
				S.mind_id = null
		mind_id = owner.mind.unique_id

/obj/item/organ/internal/stack/removed(var/mob/living/user, var/drop_organ=1)
	if(!istype(owner))
		return

	// Language will be readded upon placement into a mob with a stack.
	owner.remove_language(/decl/language/cortical)

	QDEL_NULL(backup)
	backup = new()
	backup.initialize_backup(owner)
	return ..()

/obj/item/organ/internal/stack/proc/change_cortical_alias()
	set name = "Change Cortical Chat alias"
	set desc = "Changes your alias displayed on Cortical Chat."
	set category = "IC"
	set src in usr
	if(!owner || owner.incapacitated())
		return
	if(world.time < last_alias_change + 1 MINUTE)
		to_chat(owner, SPAN_WARNING("You can't adjust your Cortical Chat alias again so soon!"))
		return
	var/new_alias = sanitizeName(input("Please enter your new Cortical Chat alias.", "Alias Select", cortical_alias) as text|null)
	if(new_alias)
		cortical_alias = new_alias
		to_chat(owner, SPAN_NOTICE("You change your Cortical Chat alias to [cortical_alias]"))
		last_alias_change = world.time