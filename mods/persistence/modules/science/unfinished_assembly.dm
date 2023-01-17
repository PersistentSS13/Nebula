/obj/item/unfinished_assembly
	name = "unfinished assembly"
	desc = "An unfinished assembly for some sort of experimental device."
	icon = 'icons/obj/assemblies/electronic_setups.dmi'
	icon_state = "setup_medium-open"

	max_health = ITEM_HEALTH_NO_DAMAGE // Since these needs to be fired etc. don't let them take damage.

	var/created_path
	var/list/item_specifications // These specifications will be passed along to the finished device in an extension

	var/screwdrivered = FALSE    // Extreme snowflake check for manual assembly.
	var/fired					 // Ditto, temperature of fire at which assembly was fired.

/obj/item/unfinished_assembly/Initialize(ml, material_key, new_path, list/item_specs, list/assembly_specs)
	. = ..()
	if(new_path)
		created_path = new_path
	if(item_specs)
		item_specifications = item_specs.Copy()

/obj/item/unfinished_assembly/Destroy()
	. = ..()
	QDEL_NULL_LIST(item_specifications)

/obj/item/unfinished_assembly/attackby(obj/item/W, mob/user)
	if(IS_SCREWDRIVER(W))
		to_chat(user, SPAN_NOTICE("You begin attempting to manually finish the assembly with \the [W]."))
		if(do_after(user, 5 SECONDS))
			screwdrivered = TRUE
			check_specs()
	else
		. = ..()

/obj/item/unfinished_assembly/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(user.skill_check(SKILL_SCIENCE, SKILL_ADEPT))
		var/datum/extension/specification_holder/spec_holder = get_extension(src, /datum/extension/specification_holder)
		if(spec_holder)
			to_chat(user, SPAN_NOTICE("Analyzing \the [src], you get a good idea of how it must be assembled."))
			var/list/specification_descs = list()
			for(var/datum/specification/spec in spec_holder.specifications)
				specification_descs += spec.get_description()
			to_chat(user, jointext(specification_descs, ".<br>"))

/obj/item/unfinished_assembly/proc/check_specs()
	var/datum/extension/specification_holder/spec_holder = get_extension(src, /datum/extension/specification_holder)
	if(spec_holder)
		spec_holder.specifications_act()

/obj/item/unfinished_assembly/proc/finalize()
	var/atom/thing = new created_path(get_turf(src))
	visible_message(SPAN_NOTICE("\The [src] has been assembled into \a [thing.name]!"))
	qdel(src)

/obj/item/unfinished_assembly/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	. = ..()
	fired = max(fired, exposed_temperature)

// Saved vars
SAVED_VAR(/obj/item/unfinished_assembly, created_path)
SAVED_VAR(/obj/item/unfinished_assembly, item_specifications)
SAVED_VAR(/obj/item/unfinished_assembly, screwdrivered)
SAVED_VAR(/obj/item/unfinished_assembly, fired)
