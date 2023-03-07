/datum/extension/network_device/bank
	var/datum/money_account/parent/saved_backup

/datum/extension/network_device/bank/before_save()
	if(!backup)
		// TODO: Unsure on using get_network() for this, it may be safer to access the network directly.
		var/datum/computer_network/network = get_network()
		if(network)
			saved_backup = network.parent_account
	. = ..()

/datum/extension/network_device/bank/after_deserialize()
	. = ..()
	if(!backup)
		backup = saved_backup
		saved_backup = null

SAVED_VAR(/datum/extension/network_device/bank, backup)
SAVED_VAR(/datum/extension/network_device/bank, saved_backup)
SAVED_VAR(/datum/extension/network_device/bank, admin_accounts)
SAVED_VAR(/datum/extension/network_device/bank, auto_money_accounts)
SAVED_VAR(/datum/extension/network_device/bank, auto_interest_rate)
SAVED_VAR(/datum/extension/network_device/bank, auto_withdrawal_limit)
SAVED_VAR(/datum/extension/network_device/bank, auto_transaction_fee)