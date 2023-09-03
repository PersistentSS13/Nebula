/datum/money_account
	var/account_name = ""
	var/owner_name = ""
	var/account_id = 0
	var/remote_access_pin = 0
	var/money = 0
	var/list/transaction_log = list()
	var/suspended = 0
	var/security_level = 0	//0 - auto-identify from worn ID, require only account number
							//1 - require manual login / account number and pin
							//2 - require card and manual login
	var/account_type = ACCOUNT_TYPE_PERSONAL
	var/currency

	var/list/pending_modifications = list() // Modifications pending for the account.
											// For non parent/child accounts this has no implementation.

/datum/money_account/New(var/account_type)
	account_type = account_type ? account_type : ACCOUNT_TYPE_PERSONAL
	if(!ispath(currency, /decl/currency))
		currency = global.using_map.default_currency
	SSmoney_accounts.all_accounts |= src

/datum/money_account/Destroy(force)
	SSmoney_accounts.all_accounts -= src
	for(var/datum/account_modification/pending_mod in pending_modifications)
		qdel(pending_mod)

	transaction_log.Cut() // Transactions are shared, but don't contain references to accounts after performance
	. = ..()

/datum/money_account/proc/format_value_by_currency(var/amt)
	var/decl/currency/cur = GET_DECL(currency)
	. = cur.format_value(amt)

// is_source inverts the amount.
/datum/money_account/proc/add_transaction(var/datum/transaction/T, is_source = FALSE)
	var/money_adjusted = is_source ? -T.amount : T.amount
	adjust_money(money_adjusted)
	transaction_log += T
	return money_adjusted

/datum/money_account/proc/get_balance()
	return money

// Returns null on success, or an error string otherwise
/datum/money_account/proc/can_afford(amount, /datum/money_account/receiver)
	if(money < amount)
		return "Insufficient funds"

/datum/money_account/proc/log_msg(msg, machine_id)
	var/datum/transaction/log/T = new(src, msg, machine_id)
	return T.perform()

/datum/money_account/proc/deposit(amount, purpose, machine_id)
	if(amount < 0)
		return "Invalid deposit amount"

	var/datum/transaction/singular/T = new(src, machine_id, amount, purpose)
	return T.perform()

/datum/money_account/proc/withdraw(amount, purpose, machine_id)
	if(amount < 0)
		return "Invalid withdrawal amount"

	var/datum/transaction/singular/T = new(src, machine_id, -amount, purpose)
	return T.perform()

/datum/money_account/proc/transfer(to_account, amount, purpose)
	var/datum/transaction/T = new(src, to_account, amount, purpose)
	return T.perform()

// Adjusts the money in the account by the given amount. Regardless of implementation, this can not fail.
/datum/money_account/proc/adjust_money(amount)
	money = max(money + amount, 0)

/datum/money_account/proc/has_mod_type(type)
	for(var/datum/account_modification/pending in pending_modifications)
		if(ispath(pending.type, type))
			return TRUE

/datum/money_account/proc/format_account_id()
	return isnum(account_id) ? "#[account_id]" : account_id