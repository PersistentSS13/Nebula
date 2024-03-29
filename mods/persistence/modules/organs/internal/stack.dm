var/global/list/cortical_stacks = list()
/proc/switchToStack(var/obj/stack_holder, var/datum/mind/mind)
	// See if we can find the stack in whatever the holder was, usually a person.
	var/obj/item/organ/internal/stack/target = locate() in stack_holder
	if(!target || target.mind_id != mind.unique_id)
		for(var/obj/item/organ/internal/stack/S in global.cortical_stacks)
			if(S.mind_id == mind.unique_id)
				target = S
				break
	if(!target)
		return null
	target.stackmob = new(target, target)
	target.stackmob.SetName(mind.current.real_name)
	target.stackmob.real_name = mind.current.real_name
	mind.transfer_to(target.stackmob)
	to_chat(target.stackmob, SPAN_NOTICE("You feel slightly disoriented. That's normal when you're just \a [target.name]."))
	return target

/obj/item/organ/internal/stack
	name = "cortical stack"
	parent_organ = BP_HEAD
	icon_state = "cortical-stack"
	organ_tag = BP_STACK
	origin_tech = @'{"biotech":4,"materials":4,"magnets":2,"programming":3}'
	relative_size = 10
	organ_properties = ORGAN_PROP_PROSTHETIC

	var/mind_id
	var/datum/computer_file/data/cloning/backup
	var/mob/living/limbo/stackmob = null

	var/cortical_alias
	var/last_alias_change

/obj/item/organ/internal/stack/Initialize()
	. = ..()
	global.cortical_stacks |= src

/obj/item/organ/internal/stack/Destroy()
	global.cortical_stacks -= src
	QDEL_NULL(backup)
	if(stackmob)
		stackmob.forceMove(SSchargen.limbo_holder) // Move the stackmob to the limbo holder to allow it to otherwise resleeve.
		stackmob.cortical_stack = null
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

/obj/item/organ/internal/stack/do_install(mob/living/carbon/human/target, obj/item/organ/external/affected, in_place, update_icon, detached)
	. = ..()
	//Since language list gets reset all the time, its better to do this here!
	if(owner && !(status & ORGAN_CUT_AWAY))
		owner.add_language(/decl/language/cortical)
		verbs |= /obj/item/organ/internal/stack/proc/change_cortical_alias
		if(!cortical_alias)
			cortical_alias = Gibberish(owner.name, 100)

/obj/item/organ/internal/stack/do_uninstall(in_place, detach, ignore_children, update_icon)
	//Since language list gets reset all the time, its better to do this here!
	if(owner)
		owner.remove_language(/decl/language/cortical)
		verbs -= /obj/item/organ/internal/stack/proc/change_cortical_alias
	. = ..()

/obj/item/organ/internal/stack/on_add_effects()
	. = ..()
	QDEL_NULL(backup)
	update_mind_id()

/obj/item/organ/internal/stack/on_remove_effects(mob/living/last_owner)
	if(istype(last_owner))
		QDEL_NULL(backup)
		backup = new()
		backup.initialize_backup(last_owner)
	return ..()

/obj/item/organ/internal/stack/proc/update_mind_id()
	if(owner.mind)
		for(var/obj/item/organ/internal/stack/S in global.cortical_stacks)
			if(S.mind_id == owner.mind.unique_id) // Make sure only one stack has a given mind ID.
				S.mind_id = null
		mind_id = owner.mind.unique_id

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
	var/new_alias = sanitize_name(input("Please enter your new Cortical Chat alias.", "Alias Select", cortical_alias) as text|null)
	if(new_alias)
		cortical_alias = new_alias
		to_chat(owner, SPAN_NOTICE("You change your Cortical Chat alias to [cortical_alias]"))
		last_alias_change = world.time

/**Override to handle cortical chat. Ideally should be a section in base update language to check for language given from organs. */
/mob/living/carbon/human/update_languages()
	. = ..()
	//Now check if we should install cortical chat language
	var/obj/item/organ/internal/stack/stack = get_organ(BP_STACK, /obj/item/organ/internal/stack)
	if(stack)
		//Since all languages are removed by default, make sure to remove the verb too, if it exists
		stack.verbs -= /obj/item/organ/internal/stack/proc/change_cortical_alias
		if(!(stack.status & ORGAN_CUT_AWAY))
			add_language(/decl/language/cortical)
			stack.verbs |= /obj/item/organ/internal/stack/proc/change_cortical_alias
			if(!stack.cortical_alias)
				stack.cortical_alias = Gibberish(name, 100)

SAVED_VAR(/obj/item/organ/internal/stack, stackmob)
SAVED_VAR(/obj/item/organ/internal/stack, backup)
SAVED_VAR(/obj/item/organ/internal/stack, cortical_alias)
SAVED_VAR(/obj/item/organ/internal/stack, mind_id)
