/*
	Regular transactions between accounts
*/

/datum/transaction
	var/purpose = ""
	var/amount = 0
	var/date = ""
	var/time = ""

	var/datum/money_account/target = null
	var/datum/money_account/source = null

	// After the transaction is performed these are created and target/source nulled for GC purposes.
	var/target_name
	var/source_name

// Can also do negative amounts to transfer from target to source
/datum/transaction/New(datum/money_account/_source, datum/money_account/_target, _amount, _purpose)
	..()

	date = stationdate2text()
	time = stationtime2text()

	purpose = _purpose
	amount = _amount

	source = _source
	target = _target

/datum/transaction/Destroy(force)
	target = null
	source = null
	. = ..()

// Whether or not the transaction is valid. Returns null on success, error message on failure.
/datum/transaction/proc/valid()
	// None of the involved accounts can be suspended
	if(target.suspended)
		return "Account [target.format_account_id()] ([target.account_name]) is suspended"
	if(source.suspended)
		return "Account [source.format_account_id()] ([source.account_name]) is suspended"
	// The payer must be able to afford the transaction
	var/afford_error = source.can_afford(amount, target)
	if(afford_error)
		return "Account [source.format_account_id()] ([source.account_name]) cannot afford the transaction. [afford_error]"

// Whether or not the source account can afford the transaction
/datum/transaction/proc/source_can_afford()
	return (source.money >= amount)

/datum/transaction/proc/get_target_name()
	return target ? target.account_name : target_name

/datum/transaction/proc/get_source_name()
	return source ? source.account_name : source_name

// Performs the transaction on both the source and target accounts.
// Returns null on success, error on failure.
/datum/transaction/proc/perform()
	var/error = valid()
	if(error)
		return error

	target.add_transaction(src)
	source.add_transaction(src, TRUE)

	target_name = get_target_name()
	source_name = get_source_name()

	target = null
	source = null

/*
	Transactions that only involve one account
	Transactions like this would be cash deposits/withdrawals, lottery winnings, filling your account at gamestart, etc.
	Note that this ALWAYS uses "source" as the account, even if it's actually the target. This is to ensure a consistent argument order (account, terminal/whatever name, amount, purpose)
*/

/datum/transaction/singular/proc/is_deposit()
	return (amount > 0)

/datum/transaction/singular/valid()
	if(source.suspended)
		return "Account [source.format_account_id()] is suspended"
	if(!is_deposit())
		var/afford_error = source.can_afford(-amount, target)
		if(afford_error)
			return "Account [source.format_account_id()] cannot afford the transaction. [afford_error]"

// For deposits: returns the name of the account the money was deposited to. For withdrawals: returns the machine ID of the machine the withdrawal was made at
/datum/transaction/singular/get_target_name()
	if(target && source)
		return (is_deposit() ? source.account_name : target)
	return target_name

// For deposits: returns the machine ID of the machine the deposit was made to. For withdrawals: returns the name of the account the money was withdrawn from
/datum/transaction/singular/get_source_name()
	if(target && source)
		return (is_deposit() ? target : source.account_name)
	return source_name

/datum/transaction/singular/perform()
	var/error = valid()
	if(error)
		return error

	source.add_transaction(src)

	target_name = get_target_name()
	source_name = get_source_name()

	target = null
	source = null
/*
	Log messages
	These should only be made through the logmsg proc of the account you want to create a log on!
*/

/datum/transaction/log
	var/machine_id = "ERRID#?"

/datum/transaction/log/New(datum/money_account/account, message, _machine_id)
	machine_id = _machine_id
	target_name = account.account_name
	..(null, account, 0, "LOG: [message]")

/datum/transaction/log/valid()
	return

/datum/transaction/log/get_source_name()
	return machine_id ? machine_id : "LOG"

/datum/transaction/log/perform()
	var/error = valid()
	if(error)
		return error

	target.add_transaction(src)

	target = null