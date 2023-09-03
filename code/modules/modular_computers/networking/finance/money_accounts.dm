// Money accounts specifically for use with networks. Child accounts are attached to user accounts.
/datum/money_account/parent/network
	var/datum/computer_file/data/email_message/bankrupt_email
	var/datum/computer_file/data/email_message/escrow_email

	// If both of these no longer exist, the accounts are auto-escrowed.
	var/weakref/network_ref
	var/weakref/bank_ref

/datum/money_account/parent/network/New(account_type, network_id, datum/computer_network/net, atom/bank_holder)
	if(istype(net))
		network_ref = weakref(net)

	if(istype(bank_holder))
		bank_ref = weakref(bank_holder)

	owner_name = network_id
	if(owner_name)
		generate_emails()
	. = ..()

/datum/money_account/parent/network/deposit(amount, purpose, machine_id)
	var/err = get_network_error()
	if(err)
		return err
	. = ..()

/datum/money_account/parent/network/withdraw(amount, purpose, machine_id)
	var/err = get_network_error()
	if(err)
		return err
	. = ..()

/datum/money_account/parent/network/transfer(to_account, amount, purpose)
	var/err = get_network_error()
	if(err)
		return err
	. = ..()

/datum/money_account/parent/network/proc/check_owners()
	var/datum/computer_network/net = network_ref?.resolve()
	if(istype(net) && net.parent_account == src)
		return TRUE

	var/datum/bank_holder = bank_ref?.resolve()
	if(istype(bank_holder))
		return TRUE

 // Network accounts need at least one money storage device and a banking mainframe to function.
/datum/money_account/parent/network/proc/get_network_error()
	var/datum/computer_network/net = network_ref?.resolve()
	if(!net || !net.banking_mainframe)
		return "The financial system is currently in recovery mode. Please contact your financial provider for further information"
	if(!length(net.money_cubes))
		return "Finances are currently frozen due to a lack of financial storage devices. Please contact your financial provider for further information"

// Generates e-mails to send in the case escrow accounts are generated.
/datum/money_account/parent/network/proc/generate_emails()
	qdel(bankrupt_email)
	qdel(escrow_email)

	bankrupt_email = new()
	bankrupt_email.title = "URGENT: Notification of financial insolvency"
	bankrupt_email.source = "financial_services@[owner_name]"
	bankrupt_email.stored_data = "Due to unforseen circumstances, an escrow panic was triggered for your financial provider. \
							Unfortunately, due to acute insolvency, an escrow account for your outstanding balance was \
							unable to be created. Please contact your financial provider or legal services for further information."
	escrow_email = new()
	escrow_email.title = "URGENT: Notification of financial issue"
	escrow_email.source = "financial_services@[owner_name]"
	escrow_email.stored_data = "Due to unforseen circumstances, an escrow panic was triggered for your financial provider. \
						An escrow account has been opened for you containing some or all of your outstanding balance of your account. \
						Escrow accounts are accessible from any financial terminal using your prior account information, \
						and the financial provider ID '[owner_name]'. Please contact your financial provider for further information."

/datum/money_account/child/network
	var/weakref/network_account

/datum/money_account/child/network/New(account_type, datum/money_account/parent/p_account, n_interest, n_withdrawal_limit, n_transaction_fee, datum/computer_file/data/account/attached_account)
	if(attached_account)
		account_name = "[attached_account.fullname]'s account"
		account_id = attached_account.login
		remote_access_pin = attached_account.password // Temporary 'pin', not actually referenced until security level is changed.
		network_account = weakref(attached_account)
	. = ..()

/datum/money_account/child/network/Destroy(force)
	var/datum/computer_file/data/account/attached_account = network_account.resolve()
	if(attached_account)
		attached_account.money_account = null
	. = ..()

/datum/money_account/child/network/on_escrow(ignore_email = FALSE)
	if(!money || ignore_email) // We didn't have any money to escrow, so leave it be.
		return ..()
	. = ..() // The amount escrowed.
	// On escrow, send e-mails explaining the situation to players. These are magic e-mails that don't check normal network requirements.
	var/datum/money_account/parent/network/net_parent = parent_account
	if(!istype(net_parent) || !net_parent.escrow_email || !net_parent.bankrupt_email)
		return

	var/datum/computer_file/data/account/attached_account = network_account.resolve()
	if(!istype(attached_account))
		return

	var/datum/computer_file/data/email_message/to_send = . > 0 ? net_parent.escrow_email.Clone() : net_parent.bankrupt_email.Clone()
	to_send.set_timestamp()
	attached_account.receive_mail(to_send)

/datum/money_account/child/network/deposit(amount, purpose, machine_id)
	var/datum/money_account/parent/network/net_parent = parent_account
	var/err = net_parent.get_network_error()
	if(err)
		return err
	. = ..()

/datum/money_account/child/network/withdraw(amount, purpose, machine_id)
	var/datum/money_account/parent/network/net_parent = parent_account
	if(!net_parent.allow_cash_withdrawal)
		return "Cash withdrawal is not permitted by your financial provider"
	var/err = net_parent.get_network_error()
	if(err)
		return err
	. = ..()

/datum/money_account/child/network/transfer(to_account, amount, purpose)
	var/datum/money_account/parent/network/net_parent = parent_account
	var/err = net_parent.get_network_error()
	if(err)
		return err
	. = ..()
