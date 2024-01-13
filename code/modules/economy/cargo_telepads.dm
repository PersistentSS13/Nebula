/obj/machinery/telepad_cargo
	name = "cargo telepad"
	desc = "A telepad used to recieve imports and send exports."
	icon = 'icons/obj/machines/telepad.dmi'
	icon_state = "pad-idle"
	anchored = TRUE
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 500
	var/telepad_id = 0
	obj_flags = OBJ_FLAG_ANCHORABLE

/obj/machinery/telepad_cargo/Initialize()
	telepad_id = random_id(type,10000,99999)
	. = ..()

/obj/machinery/telepad_cargo/attackby(obj/item/O as obj, mob/user as mob, params)
	if(IS_MULTITOOL(O))
		var/id = input(user, "Enter a new telepad ID", "Telepad ID") as text|null
		id = sanitize(id)
		if(CanInteract(user, DefaultTopicState()) && id) telepad_id = id
		return TRUE

	. = ..()

/obj/machinery/telepad_cargo/examine(mob/user)
	. = ..()
	to_chat(user, "It has a telepad ID of [telepad_id].")