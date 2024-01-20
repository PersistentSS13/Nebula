// Generic method to copy network lock access onto an atom without requiring a network connection
/datum/extension/network_lockable
	base_type = /datum/extension/network_lockable
	expected_type = /obj
	flags = EXTENSION_FLAG_IMMEDIATE

// Returns TRUE on interaction, even on failure.
/datum/extension/network_lockable/proc/process_interact(obj/item/I, mob/user)
	var/obj/o_holder = holder
	if(!istype(o_holder))
		return FALSE

	if(!length(o_holder.req_access))
		if(istype(I, /obj/item/stock_parts/network_receiver/network_lock))
			. = TRUE
			var/obj/item/stock_parts/network_receiver/network_lock/lock = I
			var/list/copy_access = lock.get_req_access()
			if(!length(copy_access))
				to_chat(user, SPAN_WARNING("You must set up the access on \the [lock] first!"))
				return

			to_chat(user, SPAN_NOTICE("You begin copying the access codes from \the [lock] into \the [o_holder]..."))
			if(do_after(user, 2 SECONDS, o_holder))
				playsound(o_holder, 'sound/machines/ping.ogg', 10, 0)
				to_chat(user, SPAN_NOTICE("\The [o_holder] pings as it successfully copies its access codes from \the [lock]."))
				o_holder.req_access = copy_access.Copy()
				return
	else if(IS_MULTITOOL(I)) // Resetting access.
		. = TRUE
		if(!o_holder.allowed(user))
			to_chat(user, SPAN_WARNING("You lack access to reset the access codes on \the [o_holder]!"))
			return
		to_chat(user, SPAN_NOTICE("You begin resetting the access codes on \the [o_holder]..."))
		if(do_after(user, 8 SECONDS, o_holder))
			playsound(o_holder, 'sound/machines/ping.ogg', 10, 0)
			to_chat(user, SPAN_NOTICE("\The [o_holder] pings as it resets its access codes."))
			o_holder.req_access = null
			return

