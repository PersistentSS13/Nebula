/obj/item/storage/pill_bottle
	var/obfuscated_meds_type = /datum/extension/obfuscated_medication/pill_bottle

/obj/item/storage/pill_bottle/Initialize()
	. = ..()
	if(obfuscated_meds_type)
		set_extension(src, obfuscated_meds_type)
	if(. != INITIALIZE_HINT_QDEL)
		. = INITIALIZE_HINT_LATELOAD

/obj/item/storage/pill_bottle/LateInitialize()
	. = ..()
	handle_med_obfuscation(src)

/obj/item/storage/pill_bottle/examine(mob/user)
	. = ..()
	var/datum/extension/obfuscated_medication/meds = get_extension(src, /datum/extension/obfuscated_medication)
	if(meds && user && (user.skill_check(SKILL_CHEMISTRY, meds.skill_threshold) || user.skill_check(SKILL_MEDICAL, meds.skill_threshold)))
		to_chat(user, SPAN_NOTICE("As far as you know, the active ingredient is <b>[meds.original_reagent]</b>."))

/obj/item/storage/pill_bottle/get_codex_value(var/mob/user)
	var/datum/extension/obfuscated_medication/meds = get_extension(src, /datum/extension/obfuscated_medication)
	if(meds && user && (user.skill_check(SKILL_CHEMISTRY, meds.skill_threshold) || user.skill_check(SKILL_MEDICAL, meds.skill_threshold)))
		return "[meds.original_reagent] (substance)"
	return ..()

/obj/item/storage/pill_bottle/on_update_icon()
	var/datum/extension/obfuscated_medication/meds = get_extension(src, /datum/extension/obfuscated_medication)
	if(meds)
		meds.update_appearance()
	. = ..()
