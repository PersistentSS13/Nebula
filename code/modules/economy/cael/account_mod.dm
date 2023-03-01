// Holder for a modification happening to an account, or some other temporary condition.
/datum/account_modification
	var/name = "Account modification"
	var/start_time
	var/mod_delay

	var/datum/money_account/affecting
	var/suspends_withdrawal_limit = FALSE // Whether or not the account modification puts a hold on withdrawal limits
	var/allow_early = TRUE // Whether or not the target account can choose to activate the modification earlier
	var/allow_cancel = TRUE // Whether or not a modification can be cancelled prior to activation.

/datum/account_modification/New(n_affecting)
	start_time = REALTIMEOFDAY
	affecting = n_affecting
	. = ..()

/datum/account_modification/Destroy(force)
	affecting.pending_modifications -= src
	affecting = null
	. = ..()

/datum/account_modification/proc/modify_account()
	SHOULD_CALL_PARENT(TRUE)
	affecting.pending_modifications -= src
	qdel(src)

// Obtains input from the user for creation, modifying variables as necessary. CanInteract() and access etc. must be checked elsewhere.
/datum/account_modification/proc/prompt_creation(mob/user)

// Returns a human readable notification describing the change.
/datum/account_modification/proc/get_notification()
	if(suspends_withdrawal_limit)
		return "As a result, withdrawal limits have been suspended."

// Returns a list of UI data for tabulated viewing
/datum/account_modification/proc/get_ui_data()
	return list("name" = name, "desc" = get_short_desc(), "allow_early" = allow_early, "allow_cancel" = allow_cancel, "suspends_wlimit" = suspends_withdrawal_limit, "countdown" = get_readable_countdown())

/datum/account_modification/proc/get_short_desc()

/datum/account_modification/proc/get_readable_countdown()
	return minutes_to_readable((start_time + mod_delay - REALTIMEOFDAY)/(1 MINUTES))

/datum/account_modification/modify_interest
	name = "Interest rate modification"
	var/new_interest

/datum/account_modification/modify_interest/prompt_creation(mob/user)
	var/n_interest = input(user, "Enter the new interest rate (between -1 and 1):", "Interest Rate") as num
	new_interest = clamp(n_interest, -1, 1)

	var/datum/money_account/child/affected_child = affecting
	if(istype(affected_child))
		if(new_interest < affected_child.interest_rate)
			suspends_withdrawal_limit = TRUE
	else
		log_error("An interest account modification was created for a non-child account!")

/datum/account_modification/modify_interest/New(n_affecting)
	mod_delay = config.interest_mod_delay
	. = ..()

/datum/account_modification/modify_interest/modify_account()
	var/datum/money_account/child/affected_child = affecting
	if(istype(affected_child))
		affected_child.interest_rate = new_interest
	else
		log_error("An interest account modification was queued for a non-child account!")

	..()

/datum/account_modification/modify_interest/get_notification()
	var/datum/money_account/child/affected_child = affecting
	if(!istype(affected_child))
		return
	. = "In [get_readable_countdown()], the interest rate on your account will be [affected_child.interest_rate > new_interest ? "lowered" : "raised"] to [new_interest]."
	var/parent_notif = ..()
	if(istext(parent_notif))
		return . + " " + parent_notif

/datum/account_modification/modify_interest/get_short_desc()
	var/datum/money_account/child/affected_child = affecting
	return "[affected_child.interest_rate > new_interest ? "Lowers" : "Raises"] interest rate to [new_interest]"

/datum/account_modification/modify_withdrawal
	name = "Withdrawal limit modification"
	var/new_withdrawal_limit

/datum/account_modification/modify_withdrawal/prompt_creation(mob/user)
	var/n_withdrawal = input(user, "Enter the new withdrawal limit:", "Withdrawal limit") as num
	new_withdrawal_limit = max(0, FLOOR(n_withdrawal))

	var/datum/money_account/child/affected_child = affecting
	if(istype(affected_child))
		if(new_withdrawal_limit < affected_child.withdrawal_limit)
			// Check to see if the user could get out all their money in time with the NEW withdrawal limit in the modification delay period.
			// We check against the new withdrawal limit so that suddenly changing the withdrawal limit extremely low isn't as effective.
			suspends_withdrawal_limit = (affected_child.money / affected_child.withdrawal_limit) > (affected_child.withdrawal_limit * new_withdrawal_limit/mod_delay)
	else
		log_error("A withdrawal limit account modification was created for a non-child account!")

/datum/account_modification/modify_withdrawal/New(n_affecting)
	mod_delay = config.withdraw_mod_delay
	. = ..()

/datum/account_modification/modify_withdrawal/modify_account()
	var/datum/money_account/child/affected_child = affecting
	if(istype(affected_child))
		affected_child.withdrawal_limit = new_withdrawal_limit
	else
		log_error("A withdrawal limit account modification was queued for an non-child account!")
	..()

/datum/account_modification/modify_withdrawal/get_notification()
	var/datum/money_account/child/affected_child = affecting
	if(!istype(affected_child))
		return
	. = "In [get_readable_countdown()], the withdrawal limit on your account will be [affected_child.withdrawal_limit > new_withdrawal_limit ? "lowered" : "raised"] to [new_withdrawal_limit]."
	var/parent_notif = ..()
	if(istext(parent_notif))
		return . + " " + parent_notif

/datum/account_modification/modify_withdrawal/get_short_desc()
	var/datum/money_account/child/affected_child = affecting
	return "[affected_child.withdrawal_limit > new_withdrawal_limit ? "Lowers" : "Raises"] withdrawal limit to [new_withdrawal_limit]"

/datum/account_modification/modify_transaction
	name = "Transaction fee modification"
	var/new_transaction_fee

/datum/account_modification/modify_transaction/prompt_creation(mob/user)
	new_transaction_fee = input(user, "Enter the new transaction fee:", "Transaction fee") as num
	new_transaction_fee = max(0, FLOOR(new_transaction_fee))


/datum/account_modification/modify_transaction/New(n_affecting)
	mod_delay = config.transaction_mod_delay
	. = ..()

/datum/account_modification/modify_transaction/modify_account()
	var/datum/money_account/child/affected_child = affecting
	if(istype(affected_child))
		affected_child.transaction_fee = new_transaction_fee
	else
		log_error("A transaction fee account modification was queued for an non-child account!")
	..()

/datum/account_modification/modify_transaction/get_notification()
	var/datum/money_account/child/affected_child = affecting
	if(!istype(affected_child))
		return
	. =  "In [get_readable_countdown()], the transaction fee on your account will be [affected_child.transaction_fee > new_transaction_fee ? "lowered" : "raised"] to [new_transaction_fee]."
	var/parent_notif = ..()
	if(istext(parent_notif))
		return . + " " + parent_notif

/datum/account_modification/modify_transaction/get_short_desc()
	var/datum/money_account/child/affected_child = affecting
	return "[affected_child.transaction_fee > new_transaction_fee ? "Lowers" : "Raises"] transaction fee to [new_transaction_fee]"

/datum/account_modification/suspend_limit
	name = "Suspend withdrawal limit"
	suspends_withdrawal_limit = TRUE
	mod_delay = 1 DAY

/datum/account_modification/suspend_limit/get_notification()
	return "The withdrawal limit on your account has been suspended for [get_readable_countdown()]"

/datum/account_modification/suspend_limit/get_short_desc()
	return "Suspends withdrawal limit on account for [get_readable_countdown()]"
/datum/account_modification/modify_fractional_reserve
	name = "Fractional reserve modification"
	var/new_fractional_reserve
	allow_early = FALSE

/datum/account_modification/modify_fractional_reserve/prompt_creation(mob/user)
	new_fractional_reserve = input(user, "Enter the new fractional reserve (between 0 and 1):", "Fractional reserve") as num
	new_fractional_reserve = clamp(new_fractional_reserve, 0, 1)

	var/datum/money_account/parent/affected_parent = affecting
	if(istype(affected_parent))
		if(new_fractional_reserve < affected_parent.fractional_reserve)
			suspends_withdrawal_limit = TRUE
	else
		log_error("A fractional reserve account modification was created for a non-parent account!")

/datum/account_modification/modify_fractional_reserve/New(n_affecting, n_frac_reserve)
	mod_delay = config.fractional_reserve_mod_delay
	. = ..()

/datum/account_modification/modify_fractional_reserve/modify_account()
	var/datum/money_account/parent/affected_parent = affecting
	if(istype(affected_parent))
		affected_parent.fractional_reserve = new_fractional_reserve
	else
		log_error("A fractional reserve account modification was queued for an non-parent account!")
	..()

/datum/account_modification/modify_fractional_reserve/get_notification()
	var/datum/money_account/parent/affected_parent = affecting
	if(!istype(affected_parent))
		return
	. = "In [get_readable_countdown()], the fractional reserve of [affected_parent.account_name] will be [affected_parent.fractional_reserve > new_fractional_reserve ? "lowered" : "raised"] to [new_fractional_reserve]."
	var/parent_notif = ..()
	if(istext(parent_notif))
		return . + " " + parent_notif

/datum/account_modification/modify_fractional_reserve/get_short_desc()
	var/datum/money_account/parent/affected_parent = affecting
	return "[affected_parent.fractional_reserve > new_fractional_reserve ? "Lowers" : "Raises"] fractional reserve to [new_fractional_reserve]"

/datum/account_modification/theft_prevention
	name = "Theft prevention measures"
	allow_early = FALSE
	allow_cancel = FALSE

/datum/account_modification/theft_prevention/New()
	mod_delay = config.anti_tamper_mod_delay
	. = ..()

/datum/account_modification/theft_prevention/get_notification()
	var/datum/money_account/parent/affected_parent = affecting
	if(!istype(affected_parent))
		return
	. = "Due to a recent theft, enhanced anti-theft measures are in place for [get_readable_countdown()]. Further tampering with money storage devices will trigger an escrow panic."
	var/parent_notif = ..()
	if(istext(parent_notif))
		return . + " " + parent_notif

/datum/account_modification/theft_prevention/get_short_desc()
	return "Enhanced anti-theft measures are in place."