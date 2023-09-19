// Since deserialization of network devices occurs late, we have to do this check to make sure the network gets the parent account back.
/datum/extension/network_device/bank/after_deserialize()
	. = ..()
	var/datum/computer_network/network = get_network()
	if(network && !network.parent_account && backup)
		network.parent_account = backup
		backup.network_ref = weakref(network)

SAVED_VAR(/datum/extension/network_device/bank, backup)
SAVED_VAR(/datum/extension/network_device/bank, admin_accounts)
SAVED_VAR(/datum/extension/network_device/bank, auto_money_accounts)
SAVED_VAR(/datum/extension/network_device/bank, auto_interest_rate)
SAVED_VAR(/datum/extension/network_device/bank, auto_withdrawal_limit)
SAVED_VAR(/datum/extension/network_device/bank, auto_transaction_fee)