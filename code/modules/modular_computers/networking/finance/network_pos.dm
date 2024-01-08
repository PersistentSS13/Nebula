// Variation of the EFTPOS for network use
// TODO: Could possibly be turned into a modular program or similar.
/obj/item/network_pos
	name = "network point of sale system"
	desc = "A network enabled point of sale system, used to perform quick transactions."
	icon = 'icons/obj/items/device/eftpos.dmi'
	icon_state = "eftpos"
	material = /decl/material/solid/organic/plastic
	matter = list(/decl/material/solid/silicon = MATTER_AMOUNT_REINFORCEMENT, /decl/material/solid/metal/copper = MATTER_AMOUNT_REINFORCEMENT)

	var/account_id
	var/account_provider // Target network ID.

	var/transaction_amount
	var/transaction_purpose
	var/transaction_authorized

/obj/item/network_pos/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/network_device)

/obj/item/network_pos/attack_self(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/item/network_pos/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, /obj/item/card/id/network))
		if(!transaction_amount)
			to_chat(user, SPAN_NOTICE("No transaction in progress!"))
			return
		var/obj/item/card/id/network/payment_card = W
		var/payment_id  = payment_card.associated_network_account["login"]
		var/payment_network = payment_card.get_network_id()

		if(!payment_id)
			to_chat(user, SPAN_WARNING("\The [src] flashes an error: no user account detected!"))
			return
		var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
		var/datum/computer_network/net = device?.get_network()
		if(!net)
			to_chat(user, SPAN_WARNING("\The [src] flashes a network connection error."))
			return
		if(!account_id)
			to_chat(user, SPAN_WARNING("\The [src] flashes an error: no account connected!"))
			return
		if(!transaction_authorized)
			to_chat(user, SPAN_WARNING("\The [src] flashes an error: transaction is not authorized!"))
			return
		var/datum/money_account/target_account = get_money_account()
		if(!istype(target_account))
			to_chat(user, SPAN_WARNING("\The [src] flashes an error: unable to find connected account!"))
			return
		var/datum/money_account/payment_account = net.get_financial_account(payment_id, payment_network)
		if(!istype(payment_account))
			to_chat(user, SPAN_WARNING("\The [src] flashes an error: unable to find user account!"))
			return
		if(payment_account.currency != target_account.currency)
			to_chat(user, SPAN_WARNING("\The [src] flashes an error: accounts do not hold the same currency."))
			return

		// Hold this here so no one can pull a fast one by rapidly changing the amount.
		var/old_transaction = transaction_amount
		var/confirm = alert(user, "Confirm transaction: [payment_account.format_value_by_currency(old_transaction)]", "Confirm Transaction", "Cancel", "Confirm")
		if(confirm != "Confirm" || !CanInteract(usr, DefaultTopicState()))
			return

		if(payment_account.security_level > 0)
			var/pin = input("Enter the PIN for this account:", "PIN Entry") as text
			pin = sanitize(pin)
			if(pin != payment_account.remote_access_pin)
				to_chat(user, SPAN_WARNING("\The [src] flashes an error: incorrect PIN!"))
				return

		var/err = payment_account.transfer(target_account, old_transaction, transaction_purpose)
		if(!err)
			visible_message(SPAN_NOTICE("[html_icon(src)] \The [src] pings: transaction successful!"))
			playsound(src, 'sound/machines/chime.ogg', 50, 1)

			// Reset transaction info.
			transaction_amount = null
			transaction_purpose = null
			transaction_authorized = FALSE
		else
			to_chat(user, SPAN_WARNING("\The [src] flashes an error: [err]"))
			return

	if(IS_PEN(W) || IS_MULTITOOL(W))
		visible_message("\The [user] begins resetting \the [src] with \the [W].")
		if(do_after(user, 5 SECONDS, src))
			to_chat(user, SPAN_NOTICE("You reset \the [src]!"))
			account_id = null
			account_provider = null
			transaction_authorized = FALSE

/obj/item/network_pos/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null)
	var/data[0]
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	if(!device)
		data["error"] = "Error in device initialization: contact administrator."
	else
		var/datum/computer_network/net = device?.get_network()
		if(!net)
			data["error"] = "Unable to connect to network. Please check your network settings."
		else
			var/datum/money_account/target_account = get_money_account()

			data["authorized"] = transaction_authorized
			data["transaction_amount"] = transaction_amount ? transaction_amount : ""
			data["transaction_purpose"] = transaction_purpose ? transaction_purpose : ""

			if(target_account)
				data["account_id"] = account_id
				data["account_provider"] = account_provider ? account_provider : net.network_id

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		ui = new(user, src, ui_key, "network_pos.tmpl", "Network POS Settings", 540, 326)
		ui.set_initial_data(data)
		ui.open()

/obj/item/network_pos/OnTopic(mob/user, href_list, datum/topic_state/state)
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	if(href_list["network_settings"])
		device.ui_interact(user)
		return TOPIC_HANDLED

	var/datum/computer_network/net = device?.get_network()
	if(!net)
		return TOPIC_REFRESH

	if(href_list["connect_account"])
		if(!account_id)
			var/new_id = input(user, "Enter the ID of the account you would like to connect to \the [src]:", "ID Entry") as text
			new_id = sanitize(new_id)

			var/new_provider = input(user, "Enter the ID of the network the account is located on. Leave blank to use device network:", "Network Entry") as text
			var/datum/money_account/target_account = net.get_financial_account(new_id, new_provider ? new_provider : net.network_id)
			if(!istype(target_account))
				to_chat(user, SPAN_WARNING("An error occured: [target_account]"))
				return TOPIC_REFRESH

			if(target_account.security_level < 1)
				to_chat(user, SPAN_WARNING("For security reasons, all accounts connected to \the [src] must have a PIN."))
				return
			account_id = new_id
			account_provider = new_provider
			return TOPIC_REFRESH
		else
			to_chat(user, SPAN_WARNING("You must reset \the [src] first!"))
			return TOPIC_REFRESH

	if(href_list["authorize_transaction"])
		if(transaction_authorized)
			transaction_authorized = FALSE
			return TOPIC_REFRESH

		var/datum/money_account/target_account = get_money_account()
		if(!target_account)
			return TOPIC_REFRESH

		if(target_account.security_level < 1)
			to_chat(user, SPAN_WARNING("For security reasons, all accounts connected to \the [src] must have a PIN."))
			account_id = null
			account_provider = null
			return TOPIC_REFRESH

		var/pin_entry = input(user, "Please enter the PIN for the connected account [account_id]:", "PIN Entry") as text
		pin_entry = sanitize(pin_entry)
		if(!pin_entry || !CanInteract(usr, DefaultTopicState()))
			return TOPIC_HANDLED

		if(pin_entry != target_account.remote_access_pin)
			to_chat(user, SPAN_WARNING("Incorrect PIN! Please try again."))
			return TOPIC_HANDLED

		transaction_authorized = TRUE
		playsound(src, 'sound/machines/chime.ogg', 50, 1)
		return TOPIC_REFRESH

	if(href_list["transaction_amount"])
		var/amount = input(user, "Enter the amount to transfer:") as num|null

		transaction_amount = round(amount)
		transaction_authorized = FALSE
		return TOPIC_REFRESH

	if(href_list["transaction_purpose"])
		var/purpose = input(user, "Enter the purpose for this transaction:") as text|null
		if(!purpose)
			return
		transaction_purpose = sanitize(purpose)
		return TOPIC_REFRESH

	if(href_list["settings"])
		var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
		D.ui_interact(user)
		return TOPIC_HANDLED

/obj/item/network_pos/proc/get_money_account()
	if(!account_id)
		return
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/net = device?.get_network()
	if(!net) // If the net goes down, don't reset the authorization.
		return
	var/datum/money_account/target_account = net.get_financial_account(account_id, account_provider ? account_provider : net.network_id)

	// Reset the system.
	if(!istype(target_account))
		account_id = null
		account_provider = null
		return

	return target_account