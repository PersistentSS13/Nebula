// Interaction with the network's parent account should go through this device. Wraps many normal functions of accounts.
/datum/extension/network_device/bank
	var/datum/money_account/parent/network/backup // The bank and network both hold references to the account, so it only goes escrows if both go down completely.

	var/list/admin_accounts = list() // Currently these accounts don't have any additional access, but are alerted when something goes wrong.

	var/auto_money_accounts = FALSE // Whether creating a network account will auto-create a money account

	// Preset values for automatically generated money accounts
	var/auto_interest_rate
	var/auto_withdrawal_limit
	var/auto_transaction_fee

/datum/extension/network_device/bank/Destroy()
	if(backup)
		if(backup.bank_ref?.resolve() == holder)
			backup.bank_ref = null

			if(!backup.check_owners())
				backup.escrow_panic()
				qdel(backup)
		else
			log_warning("A banking network device had a backup account with an invalid reference!")
			backup = null
	. = ..()

/datum/extension/network_device/bank/connect()
	. = ..()
	if(.)
		// Setup for pre-mapped banking.
		var/datum/computer_network/net = SSnetworking.networks[network_id]
		if(!net)
			return
		var/obj/machinery/network/bank/bank_holder = holder
		if(!istype(bank_holder))
			return
		if(!net.parent_account && bank_holder.preset_account_name)
			create_parent_account(bank_holder.preset_account_name, bank_holder.preset_fractional_reserve)

			if(bank_holder.auto_money_accounts)
				auto_money_accounts = TRUE
				auto_interest_rate = bank_holder.auto_interest_rate
				auto_withdrawal_limit = bank_holder.auto_withdrawal_limit
				auto_transaction_fee = bank_holder.auto_transaction_fee


/datum/extension/network_device/bank/disconnect(net_down)
	var/datum/computer_network/net = SSnetworking.networks[network_id]
	if(!net || !net.parent_account) // At this point the network should still exist, something has gone wrong.
		return ..()

	// Send out a warning e-mail to admin accounts.
	var/datum/computer_file/data/email_message/warning = new()

	warning.title = "URGENT: Financial services have entered recovery mode"
	warning.source = "financial_services@[network_id]"
	warning.stored_data = "Due to unknown circumstances, the banking mainframe on the network has been disconnected. All non-physical\
						assets have been frozen awaiting the reactivation of the banking mainframe."
	email_admin_accounts(warning)

	// Store the money within money cubes on the network.
	var/num_cubes = length(net.money_cubes)
	var/money_per_cube = FLOOR(net.parent_account.money / num_cubes)
	for(var/i in 1 to net.money_cubes)
		var/datum/extension/network_device/money_cube/cube = net.money_cubes[i]
		cube.stored_money += money_per_cube

		if(i == num_cubes)
			cube.stored_money += net.parent_account.money % num_cubes

	net.parent_account.money = 0

	. = ..()

/datum/extension/network_device/bank/proc/theft_alert(datum/extension/network_device/money_cube/cube, lost_funds)
	var/datum/computer_file/data/email_message/theft_email = new()
	var/datum/computer_network/network = get_network()
	var/datum/money_account/parent/victim = get_parent_account()
	if(!victim)
		return

	theft_email.title = "URGENT: Theft of finances detected!"
	theft_email.source = "financial_services@[network_id]"
	theft_email.stored_data = "A theft has been detected by our automated loss prevention systems, leading to a loss of [victim.format_value_by_currency(lost_funds)]. \
							The compromised financial storage device had the ID tag '[cube.network_tag]'. Loss prevention measures have been activated, and will be triggered if further losses occur."

	email_admin_accounts(theft_email)

	if(network)
		var/datum/computer_file/data/email_message/child_theft_email = new()
		child_theft_email.title = "Notice of financial loss prevention"
		child_theft_email.source = "financial_services@[network_id]"
		child_theft_email.stored_data = "Automated loss prevention systems have been triggered on the network, and withdrawal limits on all accounts have been temporarily lifted. Please contact your financial provider for more information."

		network.email_child_accounts(child_theft_email)

	var/datum/account_modification/theft_prevention/mod = new(victim)
	victim.pending_modifications += mod

/datum/extension/network_device/bank/proc/get_parent_account()
	var/datum/computer_network/network = get_network()

	return network?.parent_account

/datum/extension/network_device/bank/proc/create_parent_account(account_name, fractional_reserve)
	var/datum/computer_network/network = get_network()

	if(!network || network.parent_account)
		return FALSE

	network.parent_account = new(null, network.network_id, network, holder)
	network.parent_account.account_name = account_name
	network.parent_account.account_id = account_name // Not used for actual access, but useful for display.
	network.parent_account.fractional_reserve = fractional_reserve

	backup = network.parent_account

	return TRUE

// For internal use only, does not check fractional reserve limits. Otherwise, use transactions.
/datum/extension/network_device/bank/proc/adjust_money(amount)
	var/datum/money_account/parent/parent_account = get_parent_account()
	parent_account?.adjust_money(amount)

/datum/extension/network_device/bank/proc/log_msg(msg, machine_id)
	var/datum/money_account/parent/parent_account = get_parent_account()

	if(!parent_account)
		return "Unable to access account. Contact your financial provider"

	return parent_account.log_msg(msg, machine_id)

/datum/extension/network_device/bank/proc/deposit(amount, purpose, machine_id)
	var/datum/money_account/parent/parent_account = get_parent_account()

	if(!parent_account)
		return "Unable to access account. Contact your financial provider"

	return parent_account.deposit(amount, purpose, machine_id)

/datum/extension/network_device/bank/proc/withdraw(amount, purpose, machine_id)
	var/datum/money_account/parent/parent_account = get_parent_account()

	if(!parent_account)
		return "Unable to access account. Contact your financial provider"

	return parent_account.withdraw(amount, purpose, machine_id)

/datum/extension/network_device/bank/proc/transfer(to_account, amount, purpose)
	var/datum/money_account/parent/parent_account = get_parent_account()

	if(!parent_account)
		return "Unable to access account. Contact your financial provider"

	return parent_account.transfer(to_account, amount, purpose)

/datum/extension/network_device/bank/proc/rename_account(new_name)
	var/datum/money_account/parent/parent_account = get_parent_account()

	if(parent_account)
		parent_account.account_name = sanitize(new_name)

// Getters follow
/datum/extension/network_device/bank/proc/get_balance()
	var/datum/money_account/parent/parent_account = get_parent_account()
	return parent_account?.money

/datum/extension/network_device/bank/proc/get_formatted_balance()
	var/datum/money_account/parent/parent_account = get_parent_account()
	if(!parent_account)
		return

	return parent_account.format_value_by_currency(parent_account.money)

/datum/extension/network_device/bank/proc/get_currency()
	var/datum/money_account/parent/parent_account = get_parent_account()
	return parent_account?.currency

/datum/extension/network_device/bank/proc/get_account_name()
	var/datum/money_account/parent/parent_account = get_parent_account()

	return parent_account?.account_name

/datum/extension/network_device/bank/proc/get_child_accounts()
	var/datum/money_account/parent/parent_account = get_parent_account()
	return parent_account?.children

/datum/extension/network_device/bank/proc/get_child_totals()
	var/datum/money_account/parent/parent_account = get_parent_account()
	return parent_account?.child_totals

/datum/extension/network_device/bank/proc/get_formatted_child_totals()
	var/datum/money_account/parent/parent_account = get_parent_account()
	if(!parent_account)
		return

	return parent_account.format_value_by_currency(parent_account.child_totals)

/datum/extension/network_device/bank/proc/get_fractional_reserve()
	var/datum/money_account/parent/parent_account = get_parent_account()
	return parent_account?.fractional_reserve

/datum/extension/network_device/bank/proc/get_pending_modifications()
	var/datum/money_account/parent/parent_account = get_parent_account()
	return parent_account?.pending_modifications

/datum/extension/network_device/bank/proc/get_transaction_log()
	var/datum/money_account/parent/parent_account = get_parent_account()
	return parent_account?.transaction_log

/datum/extension/network_device/bank/proc/has_mod_type(type)
	var/datum/money_account/parent/parent_account = get_parent_account()
	return parent_account?.has_mod_type(type)

/datum/extension/network_device/bank/proc/add_admin_account(var/account_login)
	var/datum/computer_network/net = get_network()
	if(!net)
		return FALSE
	var/datum/computer_file/data/account/admin = net.find_account_by_login(account_login)
	if(admin)
		admin_accounts |= account_login
		return TRUE

/datum/extension/network_device/bank/proc/remove_admin_account(account_login)
	admin_accounts -= account_login

/datum/extension/network_device/bank/proc/email_admin_accounts(datum/computer_file/data/email_message/to_send)
	var/datum/computer_network/net = get_network()
	if(!net)
		return

	for(var/admin_login in admin_accounts)
		var/datum/computer_file/data/account/admin = net.find_account_by_login(admin_login)
		if(!admin)
			admin_accounts -= admin_login
			continue

		net.receive_email(admin, "financial-services@[net.network_id]", to_send, FALSE)