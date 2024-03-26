/obj/item/money_cube
	name = "cryptographic currency storage device"
	desc = "A digital currency storage device."

	icon = 'icons/obj/items/money_cube.dmi'
	icon_state = ICON_STATE_WORLD

	w_class = ITEM_SIZE_LARGE // Not actually that large, but quite heavy.

	origin_tech = @'{"programming":2, "magnets":3, "materials":3}'

	material = /decl/material/solid/metal/titanium
	matter = list(
				/decl/material/solid/metal/platinum = MATTER_AMOUNT_PRIMARY,
				/decl/material/solid/metal/stainlesssteel = MATTER_AMOUNT_REINFORCEMENT,
				/decl/material/solid/silicon = MATTER_AMOUNT_REINFORCEMENT
				)

	// These cubes can't manually connect to a network. Either set these or require players to connect one to a financial database
	var/initial_network
	var/initial_network_key

/obj/item/money_cube/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/network_device/money_cube, initial_network, initial_network_key, RECEIVER_STRONG_WIRELESS, initial_network ? TRUE : FALSE)

/obj/item/money_cube/examine(mob/user, distance, infix, suffix)
	. = ..()
	var/datum/extension/network_device/money_cube/cube = get_extension(src, /datum/extension/network_device)
	if(cube.check_connection())
		to_chat(user, "It appears to be active.")
	else
		to_chat(user, "It must be activated by connection to a financial database prior to use.")

/obj/item/money_cube/attackby(obj/item/W, mob/user)
	. = ..()
	if(IS_MULTITOOL(W))
		if(user.skill_check(SKILL_FINANCE, SKILL_ADEPT) || user.skill_check(SKILL_DEVICES, SKILL_EXPERT))
			var/datum/extension/network_device/money_cube/cube = get_extension(src, /datum/extension/network_device)
			if(!cube || (!cube.check_connection() && !cube.stored_money))
				to_chat(user, SPAN_WARNING("\The [src] doesn't respond to your atttempts to interface with it."))
				return
			user.visible_message("[usr] begins fiddling with \the [src]!")
			if(do_after(user, 30 SECONDS, src)) // This takes quite awhile.
				remove_cash(user)
		else
			to_chat(user, SPAN_WARNING("You have no idea how to interface with \the [src]!"))
			return

/obj/item/money_cube/proc/remove_cash(mob/user)
	var/datum/extension/network_device/money_cube/cube = get_extension(src, /datum/extension/network_device)
	if(!cube)
		return

	var/amount_to_dump = 0
	var/currency_to_dump
	var/datum/computer_network/network = cube.get_network()
	if(!network)
		amount_to_dump = cube.stored_money
		cube.stored_money = 0
	else
		// Remove the money cube's imaginary share in the parent account's money.
		if(network.banking_mainframe)
			var/datum/extension/network_device/bank/parent_bank = network.banking_mainframe

			var/num_cubes = length(network.money_cubes)
			if(!num_cubes) // Cube is aware of the network but not vice versa. Something has gone wrong.
				return

			currency_to_dump = parent_bank.get_currency()
			// At most, only half the money stored can be stolen.
			amount_to_dump = round(parent_bank.get_balance() / max(num_cubes, 2)) + cube.stored_money
			parent_bank.adjust_money(-amount_to_dump)
			cube.stored_money = 0 // This should be 0 regardless, but just in case.

			if(num_cubes == 1 || parent_bank.has_mod_type(/datum/account_modification/theft_prevention))
				network.trigger_escrow_panic()
			else
				parent_bank.theft_alert(cube, amount_to_dump)

		else // There's no active bank device, tampering will the cube will drop some money but trigger a total escrow panic.
			amount_to_dump = FLOOR(cube.stored_money/2)
			cube.stored_money -= amount_to_dump
			network.trigger_escrow_panic()

	cube.disconnect()
	cube.network_id = null
	cube.key = null
	if(amount_to_dump)
		var/obj/item/cash/cash = new(get_turf(src))
		cash.set_currency(currency_to_dump ? currency_to_dump : global.using_map.default_currency)
		cash.adjust_worth(amount_to_dump)
		if(user)
			// This should dispense a single holographic banknote or something eventually
			user.visible_message("\The [src] emits a warning tone before rapidly dispensing cash from its internal printer!")
	update_icon()

/obj/item/money_cube/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(istype(target, /obj/machinery/network/bank))
		var/datum/extension/network_device/money_cube/cube = get_extension(src, /datum/extension/network_device)
		var/datum/extension/network_device/bank/attacked_bank = get_extension(target, /datum/extension/network_device)
		if(!attacked_bank || !attacked_bank.check_connection())
			to_chat(user, SPAN_WARNING("\The [target] appears to be non-functional!"))
			return

		cube.set_new_id(attacked_bank.network_id)
		cube.set_new_key(attacked_bank.key)

		if(cube.check_connection())
			playsound(user, 'sound/machines/chime.ogg', 30, 1)
			to_chat(user, SPAN_NOTICE("\The [src] pings as it successfully links to \the [target]!"))
			update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [src] fails to connect to \the [target]."))

/obj/item/money_cube/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	var/datum/extension/network_device/money_cube/cube = get_extension(src, /datum/extension/network_device)
	var/active = cube?.check_connection()
	if(active)
		icon_state = "[icon_state]-active"

/datum/extension/network_device/money_cube
	var/stored_money // Money temporarily stored in the case that the parent account on the network vanishes.
	internet_allowed = TRUE

/datum/extension/network_device/money_cube/connect()
	. = ..()
	if(.)
		var/obj/H = holder
		H.queue_icon_update()

/datum/extension/network_device/money_cube/disconnect(net_down)
	var/obj/H = holder
	H.queue_icon_update()
	if(!stored_money)
		return ..()

	var/datum/computer_network/net = SSnetworking.networks[network_id]
	if(!net_down)
		// Divide up the stored money among other cubes. If no other cubes exist, trigger a partial/full escrow panic.
		if(!net)
			return ..()
		var/list/other_cubes = net.money_cubes - src
		var/num_cubes = length(other_cubes)
		if(num_cubes)
			var/money_per_cube = FLOOR(stored_money / num_cubes)
			for(var/i in 1 to num_cubes)
				var/datum/extension/network_device/money_cube/other_cube = other_cubes[other_cubes.len]
				if(i != num_cubes)
					other_cube.stored_money += money_per_cube
					stored_money -= money_per_cube
				else
					other_cube.stored_money += stored_money
					stored_money = 0
		else
			net.trigger_escrow_panic()
	. = ..()