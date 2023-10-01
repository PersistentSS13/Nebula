#define STATE_ERROR -1
#define STATE_MENU  0
#define STATE_PARENT  1
#define STATE_CHILD 2

#define TRANSACTIONS_PER_PAGE 5
/datum/computer_file/program/finances
	filename = "financeman"
	filedesc = "Financial management program"
	nanomodule_path = /datum/nano_module/program/finances
	program_icon_state = "id"
	program_key_state = "id_key"
	program_menu_icon = "key"
	extended_desc = "Program for managing finances exchanged and stored on the network."
	size = 8
	category = PROG_FINANCE

	var/static/list/parent_mod_types = list(/datum/account_modification/modify_fractional_reserve)
	var/static/list/child_mod_types = list( /datum/account_modification/modify_interest,
											/datum/account_modification/modify_transaction,
											/datum/account_modification/modify_withdrawal,
											/datum/account_modification/suspend_limit)

/datum/nano_module/program/finances
	name = "Financial management program"
	var/prog_state = STATE_MENU
	var/datum/computer_file/data/account/selected_account

	var/log_page = 0

	// For parent account transfers.
	var/transfer_amount
	var/transfer_purpose
	var/target_account
	var/target_network

/datum/nano_module/program/finances/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	. = ..()

	var/list/data = host.initial_data()
	var/datum/computer_network/network = get_network()
	var/datum/extension/network_device/bank/banking_mainframe
	if(!network)
		data["error"] = "Unable to connect to the network.  Check network connectivity."
		prog_state = STATE_ERROR
	else
		var/list/accesses = get_access(user)
		banking_mainframe = network.banking_mainframe
		if(!banking_mainframe || !banking_mainframe.has_access(accesses))
			data["error"] = "A banking mainframe does not exist on the network, or you lack the required access."
			prog_state = STATE_ERROR

	if(prog_state == STATE_ERROR && !data["error"])
		prog_state = STATE_MENU

	switch(prog_state)
		if(STATE_PARENT)
			var/datum/money_account/parent/network/bank_account = banking_mainframe.get_parent_account()
			if(!bank_account)
				data["create_parent"] = TRUE
			else
				data["parent_name"] = bank_account.account_name
				data["parent_balance"] = bank_account.format_value_by_currency(bank_account.money)
				data["child_totals"] = bank_account.format_value_by_currency(bank_account.child_totals)
				data["fractional_reserve"] = "[bank_account.fractional_reserve*100] %"
				data["no_child_accounts"] = length(bank_account.children)

				data["pending_parent_mods"] = list()
				var/index = 0
				for(var/datum/account_modification/pending_mod in bank_account.pending_modifications)
					index++
					data["pending_parent_mods"] += list(pending_mod.get_ui_data() + list("index" = index))

				data["admin_accounts"] = banking_mainframe.admin_accounts

				// Transactions from parent
				data["trans_amount"] = transfer_amount
				data["trans_purpose"] = transfer_purpose
				data["trans_account"] = target_account
				data["trans_network"] = target_network

				// Parent transaction log
				data["parent_transactions"] = list()
				var/list/transaction_log = reverselist(bank_account.transaction_log)
				var/log_length = length(transaction_log)
				log_page = clamp(log_page, 0, CEILING(log_length/TRANSACTIONS_PER_PAGE))

				data["next_page"] = log_length > (log_page + 1)*TRANSACTIONS_PER_PAGE
				data["prev_page"] = log_page != 0
				transaction_log = transaction_log.Copy(min(log_length, log_page*TRANSACTIONS_PER_PAGE + 1), min(log_length+1, (log_page + 1)*TRANSACTIONS_PER_PAGE + 1))
				for(var/datum/transaction/logged in transaction_log)
					data["parent_transactions"] += list(list(
						"date" = logged.date,
						"time" = logged.time,
						"purpose" = logged.purpose,
						"amount" = bank_account.format_value_by_currency(logged.amount),
						"target" = logged.get_target_name(),
						"source" = logged.get_source_name()
					))

		if(STATE_CHILD)
			if(!istype(selected_account))
				var/list/accounts = network.get_accounts()
				data["accounts"] = list()
				for(var/datum/computer_file/data/account/A in accounts)
					data["accounts"] += list(list(
						"account" = A.login,
						"fullname" = A.fullname,
						"money" = A.money_account ? A.money_account.format_value_by_currency(A.money_account.get_balance()) : "No financial account"
					))
				var/datum/money_account/parent/network/bank_account = banking_mainframe.get_parent_account()
				if(!bank_account)
					data["auto_accounts"] = FALSE
				else
					data["auto_accounts"] = banking_mainframe.auto_money_accounts
					data["auto_interest_rate"] = banking_mainframe.auto_interest_rate
					data["auto_withdrawal_limit"] = bank_account.format_value_by_currency(banking_mainframe.auto_withdrawal_limit)
					data["auto_transaction_fee"] = bank_account.format_value_by_currency(banking_mainframe.auto_transaction_fee)

			else if(selected_account.money_account)
				var/datum/money_account/child/selected_m_account = selected_account.money_account
				data["child_name"] = selected_m_account.account_name
				data["child_balance"] = selected_m_account.format_value_by_currency(selected_m_account.get_balance())
				data["interest_rate"] = selected_m_account.interest_rate
				data["withdrawal_limit"] = selected_m_account.format_value_by_currency(selected_m_account.withdrawal_limit)
				data["current_withdrawal"] = selected_m_account.format_value_by_currency(selected_m_account.current_withdrawal)
				data["transaction_fee"] = selected_m_account.format_value_by_currency(selected_m_account.transaction_fee)

				data["pending_child_mods"] = list()
				var/index = 0
				for(var/datum/account_modification/pending_mod in selected_m_account.pending_modifications)
					index++
					data["pending_child_mods"] += list(pending_mod.get_ui_data() + list("index" = index))

				// Child Transactions
				data["transactions"] = list()
				var/list/transaction_log = reverselist(selected_m_account.transaction_log)
				var/log_length = length(transaction_log)
				log_page = clamp(log_page, 0, CEILING(log_length/TRANSACTIONS_PER_PAGE))

				data["next_page"] = log_length > (log_page + 1)*TRANSACTIONS_PER_PAGE
				data["prev_page"] = log_page != 0
				transaction_log = transaction_log.Copy(min(log_length, log_page*TRANSACTIONS_PER_PAGE + 1), min(log_length + 1, (log_page + 1)*TRANSACTIONS_PER_PAGE + 1))
				for(var/datum/transaction/logged in transaction_log)
					data["child_transactions"] += list(list(
						"date" = logged.date,
						"time" = logged.time,
						"purpose" = logged.purpose,
						"amount" = selected_m_account.format_value_by_currency(logged.amount),
						"target" = logged.get_target_name(),
						"source" = logged.get_source_name()
					))
	data["prog_state"] = prog_state
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "finance_management.tmpl", name, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/computer_file/program/finances/Topic(href, href_list, state)
	if(..())
		return TOPIC_REFRESH

	var/mob/user = usr

	var/datum/computer_network/network = computer.get_network()
	var/datum/nano_module/program/finances/module = NM
	if(!network)
		return TOPIC_REFRESH

	var/list/accesses = module.get_access(user)
	var/datum/extension/network_device/bank/banking_mainframe = network.banking_mainframe
	if(!banking_mainframe || !banking_mainframe.has_access(accesses))
		return TOPIC_REFRESH

	var/datum/money_account/parent/network/bank_account = banking_mainframe.get_parent_account()

	if(href_list["next_page"])
		module.log_page += 1
		return TOPIC_REFRESH
	if(href_list["prev_page"])
		module.log_page = max(module.log_page - 1, 0)
		return TOPIC_REFRESH

	switch(module.prog_state)
		if(STATE_ERROR)
			if(href_list["back"])
				module.prog_state = STATE_MENU
				return TOPIC_REFRESH

		if(STATE_MENU)
			if(href_list["parent_mode"])
				module.log_page = 0
				module.prog_state = STATE_PARENT
				return TOPIC_REFRESH
			if(href_list["child_mode"])
				module.prog_state = STATE_CHILD
				return TOPIC_REFRESH

		if(STATE_PARENT)
			if(href_list["back"])
				module.prog_state = STATE_MENU
				return TOPIC_REFRESH

			if(href_list["create_parent_account"])
				if(bank_account)
					return TOPIC_REFRESH
				var/name = input(user, "Enter the name for the parent financial account (this may be changed later):", "Account name") as text|null
				name = sanitize(name)
				if(!CanInteract(user,state))
					return TOPIC_HANDLED

				if(!name)
					to_chat(user, SPAN_WARNING("Invalid name!"))
					return TOPIC_HANDLED

				var/fractional_reserve = input(user, "Enter the fractional reserve for the parent financial account (between 0 and 1):", "Fractional Reserve") as num|null
				fractional_reserve = clamp(fractional_reserve, 0, 1)
				if(!CanInteract(user, state))
					return TOPIC_HANDLED

				var/confirmation = alert(user, "You are about to create a parent financial account with name '[name]' and a fractional reserve of '[fractional_reserve]'. Are you sure?", "Finalize account", "No", "Yes")
				if(confirmation != "Yes" || !CanInteract(user, state))
					return TOPIC_HANDLED

				var/success = banking_mainframe.create_parent_account(name, fractional_reserve)
				if(!success)
					to_chat(user, SPAN_WARNING("Unable to create parent financial account!"))
				return TOPIC_REFRESH

			if(!bank_account)
				return TOPIC_REFRESH

			if(href_list["withdrawal"])
				var/obj/item/stock_parts/computer/money_printer/printer = computer.get_component(PART_MPRINTER)
				if(!printer)
					to_chat(user, SPAN_WARNING("There's no cryptographic printer installed!"))
					return TOPIC_HANDLED

				var/amount = input(user, "Input the amount of cash to withdrawal:", "Cash withdrawal", 0) as num|null
				if(!amount || !CanInteract(user,state))
					return TOPIC_HANDLED

				if(amount < 0)
					to_chat(user, SPAN_WARNING("Invalid withdrawal amount."))
					return TOPIC_HANDLED

				if(printer.can_print(amount, banking_mainframe.get_currency()))
					var/err = banking_mainframe.withdraw(amount, "Cash withdrawal", computer.get_nid())
					if(err)
						to_chat(user, SPAN_WARNING("Cash withdrawal failed: [err]."))
					else
						printer.print_money(amount, banking_mainframe.get_currency(), user)

					return TOPIC_REFRESH
				else
					to_chat(user, "\The [printer] does not have enough stored plastic!")
					return TOPIC_HANDLED

			if(href_list["add_modification"])
				var/list/options = list()
				for(var/mod in parent_mod_types)
					var/datum/account_modification/mod_type = mod
					options[initial(mod_type.name)] = mod
				var/chosen_mod = input(user, "Select the type of policy modification you would like to perform:", "Policy modification") as anything in options|null
				if(!chosen_mod || !CanInteract(user, state))
					return TOPIC_HANDLED

				var/chosen_mod_type = options[chosen_mod]
				if(banking_mainframe.has_mod_type(chosen_mod_type))
					to_chat(user, "A modification of that type has already been queued!")
					return TOPIC_HANDLED
				var/datum/account_modification/new_mod = new chosen_mod_type(bank_account)
				new_mod.prompt_creation(user)
				var/withdrawal_warning = new_mod.suspends_withdrawal_limit ? " During this time, withdrawal limits will be suspended." : ""
				var/confirm = alert(user, "You are about to create a [lowertext(new_mod.name)]. It will activate in [new_mod.get_readable_countdown()].[withdrawal_warning] Are you sure?", "Confirm", "No", "Yes")

				if(confirm != "Yes" || !CanInteract(user, state))
					qdel(new_mod)
					return TOPIC_REFRESH
				bank_account.pending_modifications += new_mod

				var/datum/computer_file/data/email_message/notification = new()
				notification.title = "Notification of financial policy modification"
				notification.source = "financial-services@[network.network_id]"
				notification.stored_data = "A change to your financial provider's policies has been initiated. [new_mod.get_notification()] Please contact your financial provider for more information."

				network.email_child_accounts(notification)
				banking_mainframe.email_admin_accounts(notification)

				return TOPIC_REFRESH

			if(href_list["activate_modification"])
				var/index = text2num(href_list["activate_modification"])
				var/list/pending_mods = banking_mainframe.get_pending_modifications()
				if(length(pending_mods) < index)
					return TOPIC_REFRESH

				var/datum/account_modification/pending_mod = pending_mods[index]
				if(!pending_mod.allow_early)
					return TOPIC_HANDLED

				var/confirm = alert(user, "Are you sure you would like to activate this policy modification early?", "Early activation", "No", "Yes")
				if(confirm != "Yes" || !CanInteract(user, state))
					return TOPIC_HANDLED

				pending_mod.modify_account()
				return TOPIC_REFRESH

			if(href_list["cancel_modification"])
				var/index = text2num(href_list["cancel_modification"])
				var/list/pending_mods = banking_mainframe.get_pending_modifications()
				if(length(pending_mods) < index)
					return TOPIC_REFRESH
				var/datum/account_modification/pending_mod = pending_mods[index]
				var/confirm = alert(user, "Are you sure you would like to cancel this policy modification?", "Cancel modification", "No", "Yes")
				if(confirm != "Yes" || !CanInteract(user, state))
					return TOPIC_HANDLED

				var/datum/computer_file/data/email_message/notification = new()
				notification.title = "Cancellation of financial policy modification"
				notification.source = "financial-services@[network.network_id]"
				notification.stored_data = "Your financial provider has cancelled a pending change to financial policy: [lowertext(pending_mod.name)]. Please contact your financial provider for more information."

				network.email_child_accounts(notification)
				banking_mainframe.email_admin_accounts(notification)

				qdel(pending_mod)
				return TOPIC_REFRESH

			if(href_list["transfer_account"])
				var/account = input(user, "Enter the account login you wish to transfer funds to. Leave blank if you wish to transfer money to a network's parent account:") as text|null
				if(!account)
					return TOPIC_HANDLED

				module.target_account = sanitize_for_account(account)
				return TOPIC_REFRESH

			if(href_list["transfer_network"])
				var/target_network = input(user, "Enter the network you wish to transfer funds to. Leave blank if you wish to transfer money on the current network:") as text|null
				if(!target_network)
					return TOPIC_HANDLED

				module.target_network = sanitize(target_network)
				return TOPIC_REFRESH

			if(href_list["transfer_amount"])
				var/amount = input(user, "Enter the amount to transfer:") as num|null
				if(!amount)
					return TOPIC_HANDLED

				module.transfer_amount = round(abs(amount))
				return TOPIC_REFRESH

			if(href_list["transfer_purpose"])
				var/purpose = input(user, "Enter the purpose for this transaction:") as text|null
				if(!purpose)
					return
				module.transfer_purpose = sanitize(purpose)
				return TOPIC_REFRESH

			if(href_list["perform_transfer"])
				if(!module.transfer_amount)
					to_chat(user, SPAN_WARNING("You must enter an amount to transfer!"))
					return TOPIC_HANDLED

				var/datum/money_account/target_account = network.get_financial_account(module.target_account, module.target_network ? module.target_network : network.network_id)
				if(!istype(target_account))
					to_chat(user, SPAN_WARNING("Unable to perform transaction. [target_account]."))
					return TOPIC_HANDLED

				var/err = bank_account.transfer(target_account, module.transfer_amount, module.transfer_purpose)
				if(err)
					to_chat(user, SPAN_WARNING("Funds transfer failed: [err]."))
					return TOPIC_HANDLED
				else
					to_chat(user, SPAN_NOTICE("Funds transfer successful!"))
					module.transfer_amount = 0
					module.transfer_purpose = null
					module.target_account = null
					module.target_account = null
					return TOPIC_REFRESH

			if(href_list["add_admin"])
				var/admin_login = input(user, "Enter the login of the admin you would like to add.") as text
				if(!admin_login || !CanInteract(user, state))
					return TOPIC_HANDLED

				var/success = banking_mainframe.add_admin_account(admin_login)
				if(success)
					return TOPIC_REFRESH

				to_chat(user, SPAN_WARNING("An account with that login could not be found."))
				return TOPIC_HANDLED

			if(href_list["remove_admin"])
				banking_mainframe.remove_admin_account(href_list["remove_admin"])
				return TOPIC_REFRESH

		if(STATE_CHILD)
			if(!bank_account)
				return TOPIC_REFRESH
			if(href_list["back"])
				if(!module.selected_account)
					module.prog_state = STATE_MENU
				else
					module.log_page = 0
					module.selected_account = null
				return TOPIC_REFRESH

			if(module.selected_account)
				var/datum/money_account/child/network/selected_child = module.selected_account.money_account
				if(!selected_child)
					module.selected_account = null
					return TOPIC_REFRESH

				if(href_list["add_modification"])
					var/list/options = list()
					for(var/mod in child_mod_types)
						var/datum/account_modification/mod_type = mod
						options[initial(mod_type.name)] = mod
					var/chosen_mod = input(user, "Select the type of client modification you would like to perform:", "Client modification") as anything in options
					if(!chosen_mod || !CanInteract(user, state))
						return TOPIC_HANDLED

					var/chosen_mod_type = options[chosen_mod]
					if(selected_child.has_mod_type(chosen_mod_type))
						to_chat(user, "A modification of that type has already been queued!")

					var/datum/account_modification/new_mod = new chosen_mod_type(selected_child)
					new_mod.prompt_creation(user)
					var/withdrawal_warning = new_mod.suspends_withdrawal_limit ? " During this time, withdrawal limits will be suspended." : ""
					var/confirm = alert(user, "You are about to create a [lowertext(new_mod.name)]. It will activate in [new_mod.get_readable_countdown()].[withdrawal_warning] Are you sure?", "Confirm", "No", "Yes")

					if(confirm != "Yes" || !CanInteract(user, state))
						qdel(new_mod)
						return TOPIC_HANDLED
					selected_child.pending_modifications += new_mod

					var/datum/computer_file/data/email_message/notification = new()
					notification.title = "Notification of financial modification"
					notification.source = "financial-services@[network.network_id]"
					notification.stored_data = "A change to your client account has been initiated. [new_mod.get_notification()] Please contact your financial provider for more information."

					network.receive_email(module.selected_account, "financial-services@[network.network_id]", notification)
					return TOPIC_REFRESH

				if(href_list["cancel_modification"])
					var/index = text2num(href_list["cancel_modification"])
					var/list/pending_mods = selected_child.pending_modifications
					if(length(pending_mods) < index)
						return TOPIC_REFRESH

					var/datum/account_modification/pending_mod = pending_mods[index]
					if(!pending_mod.allow_cancel)
						return TOPIC_HANDLED
					var/confirm = alert(user, "Are you sure you would like to cancel this policy modification?", "Cancel modification", "No", "Yes")
					if(confirm != "Yes" || !CanInteract(user, state))
						return TOPIC_HANDLED

					var/datum/computer_file/data/email_message/notification = new()
					notification.title = "Cancellation of financial policy modification"
					notification.source = "financial-services@[network.network_id]"
					notification.stored_data = "Your financial provider has cancelled a pending change to your client account: [lowertext(pending_mod.name)]."

					network.receive_email(module.selected_account, "financial-services@[network.network_id]", notification)
					qdel(pending_mod)
					return TOPIC_REFRESH

				if(href_list["close_account"])
					var/confirm = alert(user, "Are you SURE you want to close this account? The owner will be notified by e-mail, and their outstanding balance moved to an escrow account.", "Confirm account closure", "No", "Yes")
					if(confirm != "Yes" || !CanInteract(user, state))
						return TOPIC_HANDLED

					var/datum/computer_file/data/email_message/notification = new()
					notification.title = "Notification of account closure"
					notification.source = "financial-services@[network.network_id]"
					if(selected_child.money)
						notification.stored_data = "Your financial provider has closed your financial account. An escrow account has been opened for you containing some or all of your outstanding balance of your account. \
													Escrow accounts are accessible from any financial terminal using your prior account information, and the financial provider ID '[bank_account.owner_name]'."
					else
						notification.stored_data = "Your financial provider has closed your financial account. Please contact your financial provider for more information."

					network.receive_email(module.selected_account, "financial-services@[network.network_id]", notification)

					// Don't send the normal escrow panic e-mails.
					selected_child.on_escrow(TRUE)
					module.selected_account = null
					qdel(selected_child)
					to_chat(user, SPAN_NOTICE("Account successfully closed!"))
					return TOPIC_REFRESH
			else
				if(href_list["toggle_auto_accounts"])
					banking_mainframe.auto_money_accounts = !banking_mainframe.auto_money_accounts
					return TOPIC_REFRESH

				if(href_list["change_auto_withdrawal"])
					var/n_withdrawal = input(user, "Enter the new preset withdrawal limit:", "Withdrawal limit") as num
					if(!CanInteract(user, state))
						return TOPIC_HANDLED
					banking_mainframe.auto_withdrawal_limit = max(0, FLOOR(n_withdrawal))
					return TOPIC_REFRESH

				if(href_list["change_auto_interest"])
					var/n_interest = input(user, "Enter the new preset interest rate (between -1 and 1):", "Interest Rate") as num
					if(!CanInteract(user, state))
						return TOPIC_HANDLED
					banking_mainframe.auto_interest_rate = clamp(n_interest, -1, 1)
					return TOPIC_REFRESH

				if(href_list["change_auto_transaction"])
					var/n_withdrawal = input(user, "Enter the new preset transaction fee:", "Transaction fee") as num
					if(!CanInteract(user, state))
						return TOPIC_HANDLED
					banking_mainframe.auto_transaction_fee = max(0, FLOOR(n_withdrawal))
					return TOPIC_REFRESH

				if(href_list["select_account"])
					var/datum/computer_file/data/account/selected = network.find_account_by_login(href_list["select_account"])
					if(selected)
						. = TOPIC_REFRESH
						if(!selected.money_account)
							var/confirm = alert(user, "This network account does not have an attached client account. Would you like to create one?", "Create client account", "No", "Yes")
							if(confirm == "Yes" && CanInteract(user, state))

								var/interest = input(user, "Enter the interest rate for this account (between -1 and 1):") as num
								interest = clamp(interest, -1, 1)
								if(!CanInteract(user, state))
									return
								var/withdrawal_limit = input(user, "Enter the withdrawal limit for this account:") as num
								withdrawal_limit = max(0, FLOOR(withdrawal_limit))
								if(!CanInteract(user, state))
									return
								var/transaction_fee = input(user, "Enter the transaction fee for this account:") as num
								transaction_fee = max(0, FLOOR(transaction_fee))
								if(!CanInteract(user, state))
									return

								if(!selected || selected.money_account || !bank_account)
									return

								var/confirm2 = alert(user, "Create a client account for '[selected.login]' with an interest rate of [interest], a withdrawal limit of [withdrawal_limit] and a transaction fee of [transaction_fee]?", "Create client account", "No", "Yes")
								if(confirm2 != "Yes")
									return

								selected.money_account = new(null, bank_account, interest, withdrawal_limit, transaction_fee, selected)
							else
								return TOPIC_HANDLED
						module.selected_account = selected

/datum/computer_file/program/finances/process_cash(obj/item/cash/received, mob/user)
	var/datum/computer_network/network = computer.get_network()
	if(!network)
		return
	var/datum/nano_module/program/accounts/module = NM
	if(module.prog_state != STATE_PARENT) // Can only deposit into the parent account.
		return

	var/list/accesses = module.get_access(user)
	var/datum/extension/network_device/bank/banking_mainframe = network.banking_mainframe
	if(!banking_mainframe || !banking_mainframe.has_access(accesses))
		return // Shouldn't be able to access this UI regardless.

	var/err = banking_mainframe.deposit(received.absolute_worth, "Cash deposit", computer.get_nid())
	if(err)
		to_chat(user, SPAN_WARNING("Cash deposit failed: [err]."))
	else
		SSnano.update_uis(module)
		return received.absolute_worth

#undef TRANSACTIONS_PER_PAGE

#undef STATE_ERROR
#undef STATE_MENU
#undef STATE_PARENT
#undef STATE_CHILD