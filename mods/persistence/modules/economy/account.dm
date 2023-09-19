// Money accounts should not be flattened. Child accounts do some work with references post save,
// and because both network accounts and transactions are flattened, could lead to absurdly large rows in the database.
SAVED_VAR(/datum/money_account, account_name)
SAVED_VAR(/datum/money_account, owner_name)
SAVED_VAR(/datum/money_account, account_id)
SAVED_VAR(/datum/money_account, remote_access_pin)
SAVED_VAR(/datum/money_account, money)
SAVED_VAR(/datum/money_account, transaction_log)
SAVED_VAR(/datum/money_account, suspended)
SAVED_VAR(/datum/money_account, security_level)
SAVED_VAR(/datum/money_account, account_type)
SAVED_VAR(/datum/money_account, currency)

// Related accounts
SAVED_VAR(/datum/money_account/parent, fractional_reserve)
SAVED_VAR(/datum/money_account/parent, open_escrow_on_destroy)
SAVED_VAR(/datum/money_account/parent, allow_cash_withdrawal)
SAVED_VAR(/datum/money_account/parent, children)

/datum/money_account/parent/after_deserialize()
	. = ..()
	for(var/datum/money_account/child/child in children)
		if(child.money > 0)
			child_totals += child.money

SAVED_VAR(/datum/money_account/child, withdrawal_limit)
SAVED_VAR(/datum/money_account/child, current_withdrawal)
SAVED_VAR(/datum/money_account/child, last_withdraw_period)
SAVED_VAR(/datum/money_account/child, transaction_fee)
SAVED_VAR(/datum/money_account/child, interest_rate)
SAVED_VAR(/datum/money_account/child, last_interest_period)
SAVED_VAR(/datum/money_account/child, parent_account)

// Account modifications
SAVED_FLATTEN(/datum/account_modification)
SAVED_VAR(/datum/account_modification, name)
SAVED_VAR(/datum/account_modification, start_time)
SAVED_VAR(/datum/account_modification, mod_delay)
SAVED_VAR(/datum/account_modification, affecting)
SAVED_VAR(/datum/account_modification, suspends_withdrawal_limit)
SAVED_VAR(/datum/account_modification, allow_early)
SAVED_VAR(/datum/account_modification, allow_cancel)

// Network accounts
/datum/money_account/parent/network/after_deserialize()
	. = ..()
	// Don't bother saving these since we can easily regenerate them.
	if(owner_name)
		generate_emails()

	for(var/datum/money_account/child/network/net_child in children)
		var/datum/computer_file/data/account/attached_account = net_child.network_account?.resolve()

		// The network account has gone missing - escrow the account and destroy it.
		if(!istype(attached_account))
			net_child.on_escrow(ignore_email = TRUE)
			qdel(net_child)

SAVED_VAR(/datum/money_account/parent/network, bank_ref)

SAVED_VAR(/datum/money_account/child/network, network_account)
// Transactions
// TODO: These should disappear after some time to save space, even if they're flattened.
SAVED_FLATTEN(/datum/transaction)
SAVED_VAR(/datum/transaction, purpose)
SAVED_VAR(/datum/transaction, amount)
SAVED_VAR(/datum/transaction, date)
SAVED_VAR(/datum/transaction, time)
SAVED_VAR(/datum/transaction, target)
SAVED_VAR(/datum/transaction, source)
SAVED_VAR(/datum/transaction, target_name)
SAVED_VAR(/datum/transaction, source_name)