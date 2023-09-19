// Parent accounts hold the true money distributed among its child accounts. Child accounts check against
// and add/subtract to the parent accounts during transactions. Parent accounts may only be required to
// keep a certain amount of the total money in its child accounts (fractional reserve) as actual funds.
/datum/money_account/parent
	var/fractional_reserve = 1
	var/child_totals

	var/open_escrow_on_destroy = TRUE // Whether or not escrow accounts will be opened for child accounts in Destroy().
	var/allow_cash_withdrawal = TRUE // Whether or not child accounts can withdrawal cash.

	var/list/datum/money_account/child/children = list()

/datum/money_account/parent/Destroy(force)
	QDEL_NULL_LIST(children)
	. = ..()

/datum/money_account/parent/can_afford(amount, datum/money_account/receiver)
	. = ..()
	if(.)
		return
	// If the receiver is a child account, then the money itself isn't moving, but we need to be able
	// to afford the new fractional reserve requirement.
	if(receiver in children)
		if(fractional_reserve*(child_totals + amount) > money)
			return "Transaction violates fractional reserve requirements"
	else if(fractional_reserve*child_totals > money - amount)
		return "Transaction violates fractional reserve requirements"

// Dumps as much money as possible into globally available, withdraw only escrow accounts.
/datum/money_account/parent/proc/escrow_panic()
	if(!child_totals)
		return

	for(var/datum/money_account/child/to_escrow in children)
		to_escrow.on_escrow()

// Returns the maximum amount that can be withdrawn from the account with current fractional reserve requirement.
/datum/money_account/parent/proc/get_max_withdraw()
	return max(0, money - fractional_reserve*child_totals)

// Child accounts hold a 'fake' amount of money which actually reflects a share in the parent account.
// Child accounts can receive interest from the parent account at fixed intervals, and may be subject to a withdrawal limit.
// If the parent account only requires a fractional reserve, then the sum of all the money in the children accounts
// may not equal the money in the parent account.
/datum/money_account/child

	var/withdrawal_limit = 0	// Maximum amount of money which can be withdrawn in a period. Defaults to no limit.
	var/current_withdrawal = 0	// Amount of money withdrawn within the last period.
	var/last_withdraw_period

	var/transaction_fee = 0 // Fee paid per transaction/withdraw out of the account. Transaction fees do not apply
							// between parent/child and children with the same parent account.

	var/interest_rate = 0
	var/last_interest_period

	var/datum/money_account/parent/parent_account

/datum/money_account/child/New(account_type, datum/money_account/parent/p_account, n_interest, n_withdrawal_limit, n_transaction_fee)
	if(istype(p_account))
		parent_account = p_account
		parent_account.children |= src
	interest_rate = n_interest
	withdrawal_limit = n_withdrawal_limit
	transaction_fee = n_transaction_fee
	last_withdraw_period = REALTIMEOFDAY
	last_interest_period = REALTIMEOFDAY
	. = ..()

/datum/money_account/child/Destroy(force)
	parent_account.children -= src
	parent_account.child_totals -= money
	parent_account = null
	. = ..()

/datum/money_account/child/can_afford(amount, datum/money_account/receiver)
	if(!parent_account)
		// CASH GONE.
		return "Transaction failed. Contact your financial provider"
	. = ..()
	if(.)
		return

	if(withdrawal_limit && !withdrawal_limit_suspended())
		if(current_withdrawal + amount > withdrawal_limit)
			return "Transaction goes over withdrawal limit"

	// Accounts with the same parent can continue passing around Monopoly money even if the parent is insolvent.
	if(receiver in parent_account.children)
		return

	// Similarly, transaction fees do not occur between accounts with the same parent.
	if(amount + transaction_fee > money)
		return "Transaction fee cannot be afforded"

	// Likely due to theft of some sort.
	if(parent_account.money < amount)
		return "Transaction failed. Financial provider may be insolvent"

/datum/money_account/child/add_transaction(datum/transaction/T, is_source)
	var/amount_adjusted = ..()
	// Parent accounts are technically allowed to run negative as a measure of 'debt' to child accounts.
	// This should not occur from normal transactions
	if(parent_account)
		if(amount_adjusted < 0)
			// Transaction fee doesn't apply to accounts with the same parent.
			var/adj_transaction_fee = T.target && (T.target in (parent_account.children | parent_account)) ? 0 : transaction_fee
			// Remove the transaction fee, if it exists.
			adjust_money(-adj_transaction_fee)

			current_withdrawal += abs(amount_adjusted)

			parent_account.adjust_money(amount_adjusted)
			parent_account.child_totals += (amount_adjusted - adj_transaction_fee)
		else
			parent_account.adjust_money(amount_adjusted)
			parent_account.child_totals += amount_adjusted

/datum/money_account/child/proc/accrue_interest()
	if(!interest_rate || !parent_account)
		return

	var/interest_amount = round(interest_rate*money)
	if(interest_amount == 0)
		return

	// This just reduces the amount of money in the child account and the total, but we process it as a normal
	// transaction for logging purposes.
	if(interest_amount < 0)
		var/err = transfer(parent_account, -interest_amount, "Interest payment")
		if(err)
			parent_account.log_msg("Interest did not accrue for account [format_account_id()]: [err].")
		return

	// This checks if accruing interest would violate reserve limits etc.
	var/err = parent_account.transfer(src, interest_amount, "Interest payment")
	if(err)
		log_msg("Interest did not accrue for this period: [err]. Contact your financial provider.")
		return

/datum/money_account/child/proc/withdrawal_limit_suspended()
	for(var/datum/account_modification/pending_mod in pending_modifications)
		if(pending_mod.suspends_withdrawal_limit)
			return TRUE

	if(parent_account)
		for(var/datum/account_modification/pending_mod in parent_account.pending_modifications)
			if(pending_mod.suspends_withdrawal_limit)
				return TRUE

// Returns the amount actually escrowed
/datum/money_account/child/proc/on_escrow()
	if(!parent_account || !money) // Nothing to escrow!
		return

	var/solvency = min(1, parent_account.money / parent_account.child_totals)

	var/escrowed_money = FLOOR(min(solvency*money, parent_account.money))
	var/datum/money_account/escrow/child_escrow = SSmoney_accounts.get_or_add_escrow(account_id, remote_access_pin, parent_account.owner_name)
	child_escrow.money += escrowed_money

	money -= escrowed_money

	parent_account.money -= escrowed_money
	parent_account.child_totals -= escrowed_money

	return escrowed_money