/obj/structure/closet/secure_closet/network
	name = "network secured locker"
	desc = "A storage locker capable of storing access codes from a functioning network lock."

	reinf_material = /decl/material/solid/organic/plastic
	closet_appearance = /decl/closet_appearance/secure_closet/network
	locked = FALSE

/obj/structure/closet/secure_closet/Initialize()
	. = ..()
	set_extension(src, /datum/extension/network_lockable)

/obj/structure/closet/secure_closet/network/attackby(obj/item/W, mob/user)
	if(!opened)
		var/datum/extension/network_lockable/lockable = get_extension(src, /datum/extension/network_lockable)
		if(lockable.process_interact(W, user))
			return TRUE

	. = ..()

/obj/structure/closet/secure_closet/network/get_mechanics_info()
	return "[..()]<BR>Can have its access set when closed with a functioning network lock.<BR>Can have its access reset with a multitool."