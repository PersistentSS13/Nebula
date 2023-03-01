SUBSYSTEM_DEF(money_accounts)
	name = "Money Accounts"
	wait = 5 MINUTES
	priority = SS_PRIORITY_MONEY_ACCOUNTS
	var/list/datum/money_account/all_accounts = list()

	// Independent, globally accessible accounts not tied to a network
	var/list/datum/money_account/all_glob_accounts = list()

	var/list/datum/money_account/escrow/all_escrow_accounts = list()

	var/list/processing_accounts

	var/adjustment = 0

/datum/controller/subsystem/money_accounts/fire(resumed = FALSE)

	if(!resumed)
		processing_accounts = all_accounts.Copy()

	var/current_time = REALTIMEOFDAY + adjustment
	while(processing_accounts.len)
		var/datum/money_account/curr_account = processing_accounts[processing_accounts.len]
		processing_accounts.len--

		if(length(curr_account.pending_modifications))
			for(var/datum/account_modification/pending_mod in curr_account.pending_modifications)
				if(pending_mod.start_time + pending_mod.mod_delay <= current_time)
					pending_mod.modify_account()

		if(istype(curr_account, /datum/money_account/child))
			var/datum/money_account/child/curr_child = curr_account

			if(curr_child.withdrawal_limit && (curr_child.last_withdraw_period + config.withdraw_period <= current_time))
				curr_child.current_withdrawal = 0
				curr_child.last_withdraw_period = current_time

			if(curr_child.interest_rate && (curr_child.last_interest_period + config.interest_period <= current_time))
				curr_child.accrue_interest()
				curr_child.last_interest_period = current_time

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/money_accounts/proc/accel_day()
	adjustment += 1 DAY

/datum/controller/subsystem/money_accounts/proc/decel_day()
	adjustment -= 1 DAY

/datum/controller/subsystem/money_accounts/proc/get_or_add_escrow(account_id, account_pin, account_provider)
	var/datum/money_account/escrow/existing = get_escrow(account_id, account_pin, account_provider)
	if(existing)
		return existing

	existing = new()
	existing.account_id = account_id
	existing.remote_access_pin = account_pin
	existing.owner_name = account_provider

	all_escrow_accounts |= existing
	return existing

/datum/controller/subsystem/money_accounts/proc/get_escrow(account_id, account_pin, account_provider)
	for(var/datum/money_account/escrow/e_account in all_escrow_accounts)
		if((e_account.account_id == account_id) && e_account.remote_access_pin == account_pin)
			if(!account_provider || e_account.owner_name == account_provider)
				return e_account

/datum/controller/subsystem/money_accounts/proc/get_escrow_provider_ids()
	. = list()
	for(var/datum/money_account/escrow/e_account in all_escrow_accounts)
		. |= e_account.owner_name