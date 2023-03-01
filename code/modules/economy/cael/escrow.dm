// An account which temporarily holds money ejected from elsewhere.
/datum/money_account/escrow


/datum/money_account/escrow/Destroy(force)
	SSmoney_accounts.all_escrow_accounts -= src
	. = ..()

/datum/money_account/escrow/deposit(amount, purpose, machine_id)
	return "Account [format_account_id()] ([account_name]) does not allow deposits"

/datum/money_account/escrow/withdraw(amount, purpose, machine_id)
	. = ..()
	if(money <= 0)
		qdel(src)

/datum/money_account/escrow/transfer(to_account, amount, purpose)
	. = ..()
	if(money <= 0)
		qdel(src)