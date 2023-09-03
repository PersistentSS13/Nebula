// Some additional safety for parent accounts, recover the parent account if the banking mainframe wasn't saved
// as long as a reference to the account was held elsewhere (normally, on a child account).
/datum/computer_network/New(new_id)
	. = ..()
	recover_parent_account()

/datum/computer_network/change_id(new_id)
	. = ..()
	recover_parent_account()

/datum/computer_network/proc/recover_parent_account()
	if(parent_account)
		return

	for(var/datum/money_account/parent/network/net_account in SSmoney_accounts.all_accounts)
		if(net_account.owner_name == network_id)
			parent_account = net_account
			parent_account.network_ref = weakref(src)
			return
