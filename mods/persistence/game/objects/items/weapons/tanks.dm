/obj/item/tank/Initialize()
	var/datum/gas_mixture/old_air = air_contents
	air_contents = null	
	. = ..()
	if(persistent_id)
		QDEL_NULL(air_contents)
		air_contents = old_air

SAVED_VAR(/obj/item/tank, air_contents)
SAVED_VAR(/obj/item/tank, distribute_pressure)
SAVED_VAR(/obj/item/tank, integrity)
SAVED_VAR(/obj/item/tank, valve_welded)
SAVED_VAR(/obj/item/tank, proxyassembly)
SAVED_VAR(/obj/item/tank, volume)
SAVED_VAR(/obj/item/tank, manipulated_by)
SAVED_VAR(/obj/item/tank, leaking)
SAVED_VAR(/obj/item/tank, wired)
SAVED_VAR(/obj/item/tank, master)