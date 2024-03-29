var/global/const/RECYCLER_WIRE_POWER           = 1
var/global/const/RECYCLER_WIRE_SAFETY_ON       = 2
var/global/const/RECYCLER_WIRE_SAFETY_DURATION = 3
var/global/const/RECYCLER_WIRE_MOTOR_LIMITER   = 4
var/global/const/RECYCLER_WIRE_POWER_SUPPLY    = 5

/datum/wires/recycler
	holder_type = /obj/machinery/recycler
	wire_count = 5
	descriptions = list(
		new /datum/wire_description(RECYCLER_WIRE_POWER,           "This wire is connected to the control panel and the power supply.", SKILL_ADEPT),
		new /datum/wire_description(RECYCLER_WIRE_SAFETY_ON,       "This wire seems to be connected to some sensors.",                  SKILL_ADEPT),
		new /datum/wire_description(RECYCLER_WIRE_SAFETY_DURATION, "This wire seems to be connected to some sensors.",                  SKILL_ADEPT),
		new /datum/wire_description(RECYCLER_WIRE_MOTOR_LIMITER,   "This wire connects to the electric motor.",                         SKILL_EXPERT),
		new /datum/wire_description(RECYCLER_WIRE_POWER_SUPPLY,    "This wire is connected all over the place.")
	)

/datum/wires/recycler/CanUse(var/mob/living/L)
	var/obj/machinery/M = holder
	return istype(M?.construct_state, /decl/machine_construction/default/panel_open)

/datum/wires/recycler/GetInteractWindow(mob/user)
	var/obj/machinery/recycler/R = holder
	. += ..()
	. += "<br>"
	. += "\The [src] is [(R.operable() && R.use_power)? "online" : "offline"].<br>"
	. += "\The [src] is [(R.recycler_state &  RECYCLER_FLAG_EMERGENCY)? "in emergency stop mode" : "in normal mode"].<br>"
	. += "\The [src] is waiting [R.emergency_stop_time/(1 SECOND)] second(s) on emergency stops.<br>"
	. += "\The [src]'s check engine light is [(R.recycler_state & RECYCLER_FLAG_OVERHEATING)? "blinking yellow" : "solid green"].<br>"
	if(R.is_running())
		if(R.recycler_state & RECYCLER_FLAG_OVERHEATING)
			. += "\The [src] seems to be spinning faster..<br>"
		if(R.recycler_state & RECYCLER_FLAG_SHORTED)
			. += "\The [src] seems to be making a weird low buzzing sound..<br>"

/datum/wires/recycler/UpdateCut(var/index, var/mended)
	var/obj/machinery/recycler/R = holder
	var/mob/living/user = usr
	switch(index)
		if(RECYCLER_WIRE_POWER)
			if(user && !user.skill_check(SKILL_ELECTRICAL, SKILL_PROF))
				R.shock(user, 50)
			if(mended)
				R.recycler_state &= ~RECYCLER_FLAG_POWER_CUT
				R.update_use_power(POWER_USE_IDLE)
			else
				R.recycler_state |= RECYCLER_FLAG_POWER_CUT
				R.update_use_power(POWER_USE_OFF)

		if(RECYCLER_WIRE_SAFETY_ON)
			R.recycler_state = !mended? (R.recycler_state | RECYCLER_FLAG_UNSAFE) : (R.recycler_state & (~RECYCLER_FLAG_UNSAFE))

		if (RECYCLER_WIRE_SAFETY_DURATION)
			R.emergency_stop_time = mended? initial(R.emergency_stop_time) : ((user.skill_check(SKILL_ELECTRICAL, SKILL_EXPERT))? 0 : (1 SECOND))

		if(RECYCLER_WIRE_MOTOR_LIMITER)
			R.recycler_state = !mended? (R.recycler_state | RECYCLER_FLAG_OVERHEATING) : (R.recycler_state & (~RECYCLER_FLAG_OVERHEATING))

		if(RECYCLER_WIRE_POWER_SUPPLY)
			if(user && !user.skill_check(SKILL_ELECTRICAL, SKILL_PROF))
				R.shock(user, 50)
			R.recycler_state = !mended? (R.recycler_state | RECYCLER_FLAG_SHORTED) : (R.recycler_state & (~RECYCLER_FLAG_SHORTED))
	R.update_icon()

/datum/wires/alarm/UpdatePulsed(var/index)
	var/obj/machinery/recycler/R = holder
	var/mob/living/user = usr
	switch(index)
		if(RECYCLER_WIRE_POWER)
			if(!(R.recycler_state & RECYCLER_FLAG_POWER_CUT))
				addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/wires/recycler, clear_power_cut), 10 SECONDS))
				R.update_use_power(POWER_USE_OFF)
				R.recycler_state |= RECYCLER_FLAG_POWER_CUT

		if(RECYCLER_WIRE_SAFETY_ON)
			if(!(R.recycler_state & RECYCLER_FLAG_UNSAFE))
				R.recycler_state |= RECYCLER_FLAG_UNSAFE
				addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/wires/recycler, clear_ignore_safety), 5 SECONDS))

		if (RECYCLER_WIRE_SAFETY_DURATION)
			if(R.emergency_stop_time == initial(R.emergency_stop_time))
				R.emergency_stop_time = ((user.skill_check(SKILL_ELECTRICAL, SKILL_EXPERT))? 0 : (1 SECOND))
				addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/wires/recycler, clear_emergency_stop_time), 5 SECONDS))

		if(RECYCLER_WIRE_MOTOR_LIMITER)
			if(!(R.recycler_state & RECYCLER_FLAG_OVERHEATING))
				R.recycler_state |= RECYCLER_FLAG_OVERHEATING
				addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/wires/recycler, clear_overheating), 5 SECONDS))

		if(RECYCLER_WIRE_POWER_SUPPLY)
			if(!(R.recycler_state & RECYCLER_FLAG_SHORTED))
				R.recycler_state |= RECYCLER_FLAG_SHORTED
				addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/wires/recycler, clear_shorted), 5 SECONDS))
	R.update_icon()

/datum/wires/recycler/proc/clear_ignore_safety()
	var/obj/machinery/recycler/R = holder
	if(QDELETED(R))
		return
	R.recycler_state &= ~RECYCLER_FLAG_UNSAFE
	R.update_icon()

/datum/wires/recycler/proc/clear_power_cut()
	var/obj/machinery/recycler/R = holder
	if(QDELETED(R))
		return
	R.recycler_state &= ~RECYCLER_FLAG_POWER_CUT
	if(R.use_power == POWER_USE_OFF)
		R.update_use_power(POWER_USE_IDLE)
	R.update_icon()

/datum/wires/recycler/proc/clear_emergency_stop_time()
	var/obj/machinery/recycler/R = holder
	if(QDELETED(R))
		return
	R.emergency_stop_time = initial(R.emergency_stop_time)
	R.update_icon()

/datum/wires/recycler/proc/clear_overheating()
	var/obj/machinery/recycler/R = holder
	if(QDELETED(R))
		return
	R.recycler_state &= ~RECYCLER_FLAG_OVERHEATING

/datum/wires/recycler/proc/clear_shorted()
	var/obj/machinery/recycler/R = holder
	if(QDELETED(R))
		return
	R.recycler_state &= ~RECYCLER_FLAG_SHORTED
