/obj/machinery/telepad_cargo
	name = "cargo telepad"
	desc = "A telepad used to recieve imports and send exports."
	icon = 'icons/obj/machines/telepad.dmi'
	icon_state = "pad-idle"
	anchored = 1
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 500
	var/telepad_id = 0
/obj/machinery/telepad_cargo/New()
	telepad_id = random_id(type,10000,99999)

/obj/machinery/telepad_cargo/attackby(obj/item/O as obj, mob/user as mob, params)
	if(IS_WRENCH(O))
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		if(anchored)
			anchored = 0
			to_chat(user, "<span class = 'caution'> The [src] can now be moved.</span>")
		else if(!anchored)
			anchored = 1
			to_chat(user, "<span class = 'caution'> The [src] is now secured.</span>")
	if(IS_MULTITOOL(O))
		var/id = input(user, "Enter a new telepad ID", "Telepad ID") as text|null
		id = sanitize(id)
		if(CanInteract(user, DefaultTopicState()) && id) telepad_id = id

	return component_attackby(O, user)