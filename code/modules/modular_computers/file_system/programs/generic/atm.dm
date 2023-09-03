#define STATE_LOGIN 0
#define STATE_MAIN  1
#define STATE_TRANSFER  2
#define STATE_LOG 3

#define TRANSACTIONS_PER_PAGE 8
/datum/computer_file/program/atm
	filename = "atmprog"
	filedesc = "ATM Client"
	extended_desc = "This program may be used to manage finances attached to your network account."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "mail-closed"
	size = 3
	available_on_network = 1
	usage_flags = PROGRAM_ALL
	category = PROG_FINANCE

	nanomodule_path = /datum/nano_module/program/atm

/datum/computer_file/program/atm/Topic(href, href_list, state)
	if(..())
		return TOPIC_REFRESH
	var/mob/living/user = usr
	var/datum/computer_file/data/account/current_account = computer.get_account()
	var/datum/computer_network/network = computer.get_network()
	var/datum/nano_module/program/atm/module = NM

	if(href_list["access_escrow"])
		var/provider_id = input(user, "Enter the network ID for the account which was escrowed.")
		if(!provider_id || !CanInteract(user, state))
			return TOPIC_HANDLED

		var/escrow_login = input(user, "Enter the login for the account which was escrowed.")
		if(!escrow_login || !CanInteract(user, state))
			return TOPIC_HANDLED

		var/escrow_pass = input(user, "Enter the PIN for the account which was escrowed. If a PIN was not set, enter the account password.")
		if(!escrow_pass || !CanInteract(user, state))
			return TOPIC_HANDLED

		var/datum/money_account/escrow/escrowed_account = SSmoney_accounts.get_escrow(escrow_login, escrow_pass, provider_id)
		if(!escrowed_account)
			to_chat(user, SPAN_WARNING("An escrow account matching the input information could not be found."))
			return TOPIC_HANDLED

		var/confirm = alert(user, "An escrow account matching the input information was found. Would you like to withdraw the available balance and close the account?", "Close escrow account", "No", "Yes")
		if(confirm == "Yes" && CanInteract(user, state))
			var/obj/item/stock_parts/computer/money_printer/printer = computer.get_component(PART_MPRINTER)
			if(!printer)
				to_chat(user, SPAN_WARNING("There's no cryptographic printer installed!"))
				return TOPIC_HANDLED

			if(printer.can_print(escrowed_account.money, escrowed_account.currency))
				// This shouldn't occur barring admin intervention, but just in case.
				var/money_to_print = escrowed_account.money
				var/err = escrowed_account.withdraw(escrowed_account.money, "Cash withdrawal", computer.get_nid())
				if(err)
					to_chat(user, SPAN_WARNING("Cash withdrawal failed: [err]."))
				else
					printer.print_money(money_to_print, escrowed_account.currency, user)
					qdel(escrowed_account)
				return TOPIC_REFRESH
			else
				to_chat(user, "\The [printer] does not have enough stored plastic!")
				return TOPIC_HANDLED
		return TOPIC_HANDLED

	var/datum/money_account/child/network/current_money_account = current_account?.money_account
	if(!current_money_account)
		return TOPIC_REFRESH

	if(href_list["change_mode"])
		if(module.prog_mode == STATE_LOGIN)
			return TOPIC_REFRESH

		switch(href_list["change_mode"])
			if("main")
				module.prog_mode = STATE_MAIN
			if("transfer")
				module.prog_mode = STATE_TRANSFER
			if("log")
				module.prog_mode = STATE_LOG

		return TOPIC_REFRESH

	switch(module.prog_mode)
		if(STATE_LOGIN)
			if(href_list["pin_entry"])
				var/pin = input(user, "Enter the PIN for this account:", "PIN entry") as text|null
				pin = sanitize(pin)
				if(!pin || !CanInteract(user, state))
					return TOPIC_HANDLED
				if(pin == current_money_account.remote_access_pin)
					to_chat(user, SPAN_NOTICE("Login successful. Welcome [current_account.fullname]!"))
					module.current_pin = pin
					module.prog_mode = STATE_MAIN
					return TOPIC_REFRESH

		if(STATE_MAIN) // Withdrawals, activating modifications early, changing security level.
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

				if(printer.can_print(amount, current_money_account.currency))
					var/err = current_money_account.withdraw(amount, "Cash withdrawal", computer.get_nid())
					if(err)
						to_chat(user, SPAN_WARNING("Cash withdrawal failed: [err]."))
					else
						printer.print_money(amount, current_money_account.currency, user)

					return TOPIC_REFRESH
				else
					to_chat(user, "\The [printer] does not have enough stored plastic!")
				return TOPIC_HANDLED

			if(href_list["activate_modification"])
				var/index = text2num(href_list["activate_modification"])
				var/list/pending_mods = current_money_account.pending_modifications
				if(length(pending_mods) < index)
					return TOPIC_REFRESH

				var/datum/account_modification/pending_mod = pending_mods[index]
				if(!pending_mod.allow_early)
					return TOPIC_HANDLED

				var/confirm = alert(user, "Are you sure you would like to activate this client modification early?", "Early activation", "No", "Yes")
				if(confirm != "Yes" || !CanInteract(user, state))
					return TOPIC_HANDLED

				pending_mod.modify_account()
				return TOPIC_REFRESH

			if(href_list["change_sec_level"])
				if(current_money_account.security_level == 0)
					var/new_pin = input("Enter the PIN you'd like to add to the account:") as text|null
					new_pin = sanitize(new_pin)
					if(!new_pin)
						return TOPIC_HANDLED
					var/confirm = alert(user, "You are about to set the PIN for this account to '[new_pin]'. Are you sure?", "Add PIN", "No", "Yes")
					if(confirm == "Yes" && CanInteract(user, state))
						current_money_account.security_level = 1
						current_money_account.remote_access_pin = new_pin
						module.current_pin = new_pin
						return TOPIC_REFRESH
				else
					current_money_account.security_level = 0
					current_money_account.remote_access_pin = null
					module.current_pin = null
					return TOPIC_REFRESH

		if(STATE_TRANSFER)
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

				module.transfer_amount = round(abs(amount)) // No negative values.
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
					to_chat(user, SPAN_WARNING("Unable to perform transaction. [target_account]"))
					return TOPIC_HANDLED

				var/err = current_money_account.transfer(target_account, module.transfer_amount, module.transfer_purpose)
				if(err)
					to_chat(user, SPAN_WARNING("Funds transfer failed: [err]."))
					return TOPIC_HANDLED
				else
					to_chat(user, SPAN_NOTICE("Funds transfer successful!"))
					module.transfer_amount = 0
					module.transfer_purpose = null
					module.target_account = null
					module.target_account = null

					module.prog_mode = STATE_MAIN
					return TOPIC_REFRESH

		if(STATE_LOG)
			if(href_list["next_page"])
				module.log_page += 1
				return TOPIC_REFRESH
			if(href_list["prev_page"])
				module.log_page = max(module.log_page - 1, 0)
				return TOPIC_REFRESH

/datum/nano_module/program/atm
	var/transfer_amount
	var/transfer_purpose
	var/target_account
	var/target_network

	var/prog_mode = STATE_LOGIN
	var/current_pin

	var/log_page = 0

/datum/nano_module/program/atm/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/data/account/current_account = program.computer.get_account()
	var/datum/money_account/child/network/current_money_account = current_account?.money_account
	if(!istype(current_account))
		prog_mode = STATE_LOGIN
		data["login_prompt"] = "No account logged in. Please login through your system to proceed."
	else if(!current_money_account)
		prog_mode = STATE_LOGIN
		data["login_prompt"] = "No financial account is associated with this network account. Please contact your financial provider."
	else if(current_money_account.security_level > 0 && current_pin != current_money_account.remote_access_pin)
		current_pin = null
		prog_mode = STATE_LOGIN
		data["login_prompt"] = "Enter the remote access pin for this account:"
		data["prompt_pin"] = TRUE
	else
		if(prog_mode == STATE_LOGIN)
			prog_mode = STATE_MAIN

		switch(prog_mode)
			if(STATE_MAIN)
				data["account_name"] = current_money_account.account_name
				data["balance"] = current_money_account.format_value_by_currency(current_money_account.get_balance())
				data["interest_rate"] = current_money_account.interest_rate
				data["withdrawal_limit"] = current_money_account.format_value_by_currency(current_money_account.withdrawal_limit)
				data["current_withdrawal"] = current_money_account.format_value_by_currency(current_money_account.current_withdrawal)
				data["transaction_fee"] = current_money_account.format_value_by_currency(current_money_account.transaction_fee)

				if(length(current_money_account.pending_modifications))
					data["pending_mods"] = list()
					var/index = 0
					for(var/datum/account_modification/pending_mod in current_money_account.pending_modifications)
						index++
						data["pending_mods"] += list(pending_mod.get_ui_data() + list("index" = index))

				data["pin_secured"] = current_money_account.security_level >= 1

			if(STATE_TRANSFER)
				data["trans_amount"] = transfer_amount
				data["trans_purpose"] = transfer_purpose
				data["trans_account"] = target_account
				data["trans_network"] = target_network

			if(STATE_LOG)
				data["transactions"] = list()
				var/list/transaction_log = reverselist(current_money_account.transaction_log)
				var/log_length = length(transaction_log)
				log_page = clamp(log_page, 0, CEILING(log_length/TRANSACTIONS_PER_PAGE))

				data["next_page"] = log_length > (log_page + 1)*TRANSACTIONS_PER_PAGE
				data["prev_page"] = log_page != 0
				transaction_log = transaction_log.Copy(min(log_length, log_page*TRANSACTIONS_PER_PAGE + 1), min(log_length + 1, (log_page + 1)*TRANSACTIONS_PER_PAGE + 1))
				for(var/datum/transaction/logged in transaction_log)
					data["transactions"] += list(list(
						"date" = logged.date,
						"time" = logged.time,
						"purpose" = logged.purpose,
						"amount" = current_money_account.format_value_by_currency(logged.amount),
						"target" = logged.get_target_name(),
						"source" = logged.get_source_name()
					))

	if(prog_mode == STATE_LOGIN && length(SSmoney_accounts.all_escrow_accounts))
		data["escrow_providers"] = english_list(SSmoney_accounts.get_escrow_provider_ids())

	data["prog_mode"] = prog_mode
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "atm_program.tmpl", "Automated Teller Utility", 600, 450, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/computer_file/program/atm/process_cash(obj/item/cash/received, mob/user)
	var/datum/nano_module/program/atm/module = NM
	if(module.prog_mode == STATE_LOGIN) // Can only deposit while logged in.
		return

	var/datum/computer_file/data/account/current_account = computer.get_account()
	var/datum/money_account/child/network/current_money_account = current_account?.money_account

	if(!current_money_account)
		return

	var/err = current_money_account.deposit(received.absolute_worth, "Cash deposit", computer.get_nid())
	if(err)
		to_chat(user, SPAN_WARNING("Cash deposit failed: [err]."))
	else
		SSnano.update_uis(module)
		return received.absolute_worth

#undef TRANSACTIONS_PER_PAGE

#undef STATE_LOGIN
#undef STATE_MAIN
#undef STATE_TRANSFER
#undef STATE_LOG