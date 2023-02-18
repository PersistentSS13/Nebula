// Rather than keeping track of all the money stored in each money cube, we assume that money is distributed evenly among them,
// and only call this when the banking mainframe or network goes down.
/datum/computer_network/proc/money_to_storage(var/additional_money)
	if(!parent_account)
		return

	var/total_money = parent_account.money + additional_money
	if(!total_money)
		return

	var/num_cubes = length(money_cubes)

	if(!num_cubes) // No money cubes on the network
		return

	var/money_per_cube = FLOOR(total_money / num_cubes)

	for(var/i in 1 to num_cubes)
		var/datum/extension/network_device/money_cube/cube = money_cubes[i]
		cube.stored_money += money_per_cube
		if(i == num_cubes)
			cube.stored_money += total_money % num_cubes

	parent_account.money = 0

// Re-collect all money from money cubes and trigger an escrow panic.
/datum/computer_network/proc/trigger_escrow_panic()
	if(!parent_account)
		return

	var/cube_money = 0
	for(var/datum/extension/network_device/money_cube/cube in money_cubes)
		cube_money += cube.stored_money
		cube.stored_money = 0

	parent_account.money += cube_money
	parent_account.escrow_panic()

	if(banking_mainframe && length(banking_mainframe.admin_accounts))
		var/datum/computer_file/data/email_message/escrow_email = new()
		escrow_email.title = "URGENT: Escrow panic triggered"
		escrow_email.source = "financial_services@[network_id]"
		escrow_email.stored_data = "Due to the potential for extreme financial loss, an escrow panic has been automatically triggered for the parent financial account on the network.\
									Escrow accounts have been opened for all client accounts on the network."

		var/debt = parent_account.child_totals // Money still remains in children accounts.
		if(debt)
			escrow_email.stored_data += " Due to acute insolvency, a debt of [parent_account.format_value_by_currency(debt)] has been incurred for client accounts."

		banking_mainframe.email_admin_accounts(escrow_email)

/datum/computer_network/proc/email_child_accounts(datum/computer_file/data/email_message/to_send)
	for(var/datum/computer_file/data/account/child in get_accounts_unsorted())
		if(child.money_account)
			receive_email(child, "financial-services@[network_id]", to_send, FALSE)

// Returns money account datum on success. Returns error text on failure.
/datum/computer_network/proc/get_financial_account(target_login, target_network_id)
	. = "Unable to locate financial account over the network. Please try again later"
	var/datum/computer_network/target_network = get_internet_connection(target_network_id, NET_FEATURE_FINANCE)
	if(!target_network || !target_network.parent_account)
		return

	if(!target_login)
		return target_network.parent_account

	var/datum/computer_file/data/account/target_account = target_network.find_account_by_login(target_login)

	if(!target_account)
		return

	if(!target_account.money_account)
		return

	return target_account.money_account