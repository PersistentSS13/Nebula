/datum/computer_file/program/trade_management
	filename = "trademnrger"
	filedesc = "Import/Export Management"
	extended_desc = "This program allows you to process imports or exports from nearby trade beacons."

	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "cart"

	available_on_network = 1

	size = 12
	nanomodule_path = /datum/nano_module/program/trade_management
	category = PROG_SUPPLY

	var/obj/effect/overmap/trade_beacon/selected_beacon

	var/import_menu = 1
	var/export_menu = 0
	var/log_menu = 0
	var/datum/beacon_import/selected_import
	var/datum/beacon_export/selected_export
	var/payment_type = 1 // 1 == personal account 2 == chargestick 3 == network parent account

	var/list/detected_telepads = list()
	var/obj/selected_telepad

/datum/computer_file/program/trade_management/proc/detect_telepads()
	detected_telepads = list()
	for(var/obj/machinery/telepad_cargo/c in orange(3, get_turf(computer)))
		if(c.anchored)
			detected_telepads |= c
	return

/datum/computer_file/program/trade_management/on_startup(mob/living/user, datum/extension/interactive/os/new_host)
	. = ..()
	detect_telepads()


/datum/nano_module/program/trade_management
	name = "Import/Export Management"


/datum/computer_file/program/trade_management/proc/spawnImport()
	var/turf/T = get_turf(selected_telepad)
	flick("pad-beam", selected_telepad)
	. = selected_import.spawnImport(T)
	if(selected_import.remaining_stock < 1)
		selected_beacon.active_imports.Remove(selected_import)
		selected_import = null
/datum/computer_file/program/trade_management/proc/checkImport()
	var/turf/T = get_turf(selected_telepad)
	flick("pad-beam", selected_telepad)
	return selected_import.checkImport(T)

/datum/computer_file/program/trade_management/proc/takeExport()
	flick("pad-beam", selected_telepad)
	. = selected_export.takeExport()
	if(selected_export.remaining_stock < 1)
		selected_beacon.active_exports.Remove(selected_export)
		selected_export = null
/datum/computer_file/program/trade_management/proc/checkExport()
	var/turf/T = get_turf(selected_telepad)
	return selected_export.checkExport(T)

/datum/computer_file/program/trade_management/proc/resetExport()
	return selected_export.resetExport()

/datum/computer_file/program/trade_management/proc/buyImport()
	var/import_tax = 0
	if(!selected_import || !selected_beacon)
		return
	if(!(selected_import in selected_beacon.active_imports))
		selected_import = null
		return
	if(!selected_telepad)
		to_chat(usr, SPAN_WARNING("You must select a telepad to send the import to."))
		return TOPIC_REFRESH
	if(selected_beacon && selected_beacon.linked_controller)
		import_tax = selected_beacon.linked_controller.import_tax
	var/cost = selected_import.get_cost(import_tax)
	var/tax_portion = selected_import.get_tax(import_tax)
	switch(payment_type)
		if(1)
			var/datum/computer_file/data/account/A = computer.get_account()
			if(A)

				var/oerr = checkImport()
				if(oerr)
					to_chat(usr, SPAN_WARNING("Import purchase failed: [oerr]"))
					return TOPIC_HANDLED
				var/datum/money_account/child/network/money_account = A.money_account
				if(money_account)
					var/terr = money_account.can_afford(cost, selected_beacon.beacon_account)
					if(terr)
						to_chat(usr, SPAN_WARNING("Import purchase failed: [terr]"))
						return TOPIC_HANDLED
					var/final_cost = cost-tax_portion
					var/err = money_account.transfer(selected_beacon.beacon_account, final_cost, "Import Purchase ([selected_import.name] from [selected_beacon.name])")
					if(err)
						to_chat(usr, SPAN_WARNING("Import purchase failed: [err]."))
						return TOPIC_HANDLED
					else
						if(tax_portion)
							var/datum/computer_network/network = selected_beacon.linked_controller.get_network()
							if(network && network.banking_mainframe && network.banking_mainframe.get_parent_account())
								err = money_account.transfer(network.banking_mainframe.get_parent_account(), tax_portion, "Import Purchase Tax ([selected_import.name] from [selected_beacon.name])")
								if(err)
									selected_beacon.beacon_account.transfer(money_account, final_cost, "Refunded Import Purchase ([selected_import.name] from [selected_beacon.name])")
								else
									spawnImport()
						else
							spawnImport()
				else
					to_chat(usr, SPAN_WARNING("No banking account associated with this network. Contact your system administrator.."))
			else
				to_chat(usr, SPAN_WARNING("You must login to a valid account on your network to pay digitally."))
		if(2)
			var/obj/item/stock_parts/computer/charge_stick_slot/charge_slot = computer.get_component(PART_MSTICK)
			if(!charge_slot || !charge_slot.stored_stick)
				to_chat(usr, SPAN_WARNING("No charge stick is inserted into the computer."))
				return TOPIC_REFRESH
			var/obj/item/charge_stick/stick = charge_slot.stored_stick
			if(cost > stick.loaded_worth)
				to_chat(usr, SPAN_WARNING("The loaded charge stick does not have enough credits stored!"))
				return TOPIC_HANDLED
			var/oerr = checkImport()
			if(oerr)
				to_chat(usr, SPAN_WARNING("Import purchase failed: [oerr]"))
				return TOPIC_HANDLED
			stick.adjust_worth(-(cost))
			if(tax_portion)
				var/datum/computer_network/network = selected_beacon.linked_controller.get_network()
				if(network && network.banking_mainframe && network.banking_mainframe.get_parent_account())
					var/datum/money_account/child/network/money_account = network.banking_mainframe.get_parent_account()
					money_account.deposit(tax_portion, "Import Purchase Tax ([selected_import.name] from [selected_beacon.name])")
			spawnImport()
		if(3)
			var/datum/computer_network/net = computer.get_network()
			var/list/accesses = computer.get_access(usr)
			if(net && net.banking_mainframe)
				if(!net.banking_mainframe.has_access(accesses))
					to_chat(usr, SPAN_WARNING("You do not have access to the parent account on your current network."))
					return TOPIC_REFRESH
				else
					var/datum/money_account/parent/network/money_account = net.banking_mainframe.get_parent_account()
					if(money_account)
						var/terr = money_account.can_afford(cost, selected_beacon.beacon_account)
						if(terr)
							to_chat(usr, SPAN_WARNING("Import purchase failed: [terr]"))
							return TOPIC_HANDLED
						var/oerr = checkImport()
						if(oerr)
							to_chat(usr, SPAN_WARNING("Import purchase failed: [oerr]"))
							return TOPIC_HANDLED
						if(tax_portion)
							var/datum/computer_network/network = selected_beacon.linked_controller.get_network()
							if(network && network.banking_mainframe && network.banking_mainframe.get_parent_account())
								if(network.banking_mainframe.get_parent_account() == money_account) // dont pay tax from the account into the same account
									tax_portion = 0
									cost = selected_import.get_cost(0)
							else // remove tax if we cant find a parent account to pay it to.
								tax_portion = 0
								cost = selected_import.get_cost(0)
						if(money_account.money < cost)
							to_chat(usr, SPAN_WARNING("Import purchase failed: Insufficent funds."))
							return TOPIC_HANDLED
						var/final_cost = cost-tax_portion
						var/err = money_account.transfer(selected_beacon.beacon_account, final_cost, "Import Purchase ([selected_import.name] from [selected_beacon.name])")
						if(err)
							to_chat(usr, SPAN_WARNING("Import purchase failed: [err]."))
							return TOPIC_HANDLED
						else
							if(tax_portion)
								var/datum/computer_network/network = selected_beacon.linked_controller.get_network()
								if(network && network.banking_mainframe && network.banking_mainframe.get_parent_account())
									err = money_account.transfer(network.banking_mainframe.get_parent_account(), tax_portion, "Import Purchase Tax ([selected_import.name] from [selected_beacon.name])")
									if(err)
										selected_beacon.beacon_account.transfer(money_account, final_cost, "Refunded Import Purchase ([selected_import.name] from [selected_beacon.name])")
									else
										spawnImport()
							else
								spawnImport()
			else
				to_chat(usr, SPAN_WARNING("The network does not have a central account."))
				return TOPIC_REFRESH
	return TOPIC_REFRESH

/datum/computer_file/program/trade_management/proc/buyExport()
	var/export_tax = 0
	if(!selected_export || !selected_beacon)
		return TOPIC_REFRESH
	if(!(selected_export in selected_beacon.active_exports))
		selected_export = null
		return
	if(!selected_telepad)
		to_chat(usr, SPAN_WARNING("You must select a telepad to send the export to."))
		return TOPIC_REFRESH
	if(selected_beacon && selected_beacon.linked_controller)
		export_tax = selected_beacon.linked_controller.export_tax
	var/cost = selected_export.get_cost(export_tax)
	var/tax_portion = selected_export.get_tax(export_tax)
	switch(payment_type)
		if(1)
			var/datum/computer_file/data/account/A = computer.get_account()
			if(A)
				var/datum/money_account/child/network/money_account = A.money_account
				if(money_account)
					var/e_err = checkExport()
					if(e_err)
						to_chat(usr, SPAN_WARNING("Export failed: [e_err]."))
						resetExport()
						return TOPIC_HANDLED
					var/err = money_account.deposit(cost, "Export ([selected_export.name] from [selected_beacon.name])")
					if(err)
						to_chat(usr, SPAN_WARNING("Export failed: [err]."))
						resetExport()
						return TOPIC_HANDLED
					else

						if(tax_portion)  // SUCCESS
							var/datum/computer_network/network = selected_beacon.linked_controller.get_network()
							if(network && network.banking_mainframe && network.banking_mainframe.get_parent_account())
								var/datum/money_account/acc = network.banking_mainframe.get_parent_account()
								err = acc.deposit(tax_portion, "Export Tax ([selected_export.name] from [selected_beacon.name])")
						var/result = takeExport()
						if(result)
							to_chat(usr, SPAN_WARNING("Export failed: [e_err]."))
				else
					to_chat(usr, SPAN_WARNING("No banking account associated with this network. Contact your system administrator."))
					return TOPIC_REFRESH
			else
				to_chat(usr, SPAN_WARNING("You must login to a valid account on your network to pay digitally."))
				return TOPIC_REFRESH
		if(2)
			var/obj/item/stock_parts/computer/charge_stick_slot/charge_slot = computer.get_component(PART_MSTICK)
			if(!charge_slot || !charge_slot.stored_stick)
				to_chat(usr, SPAN_WARNING("No charge stick is inserted into the computer."))
				return TOPIC_REFRESH
			var/obj/item/charge_stick/stick = charge_slot.stored_stick
			var/e_err = checkExport()
			if(e_err)
				to_chat(usr, SPAN_WARNING("Export failed: [e_err]."))
				resetExport()
				return TOPIC_HANDLED
			stick.adjust_worth(cost)
			if(tax_portion)
				var/datum/computer_network/network = selected_beacon.linked_controller.get_network()
				if(network && network.banking_mainframe && network.banking_mainframe.get_parent_account())
					var/datum/money_account/acc = network.banking_mainframe.get_parent_account()
					acc.deposit(tax_portion, "Export Tax ([selected_export.name] from [selected_beacon.name])")
			var/result = takeExport()
			if(result)
				to_chat(usr, SPAN_WARNING("Export failed: [e_err]."))
		if(3)
			var/datum/computer_network/net = computer.get_network()
			var/list/accesses = computer.get_access(usr)
			if(net && net.banking_mainframe)
				if(!net.banking_mainframe.has_access(accesses))
					to_chat(usr, SPAN_WARNING("You do not have access to the parent account on your current network."))
					return TOPIC_REFRESH
				else
					var/datum/money_account/parent/network/money_account = net.banking_mainframe.get_parent_account()
					if(money_account)
						if(tax_portion)
							var/datum/computer_network/network = selected_beacon.linked_controller.get_network()
							if(network && network.banking_mainframe && network.banking_mainframe.get_parent_account())
								if(network.banking_mainframe.get_parent_account() == money_account) // dont pay tax from the account into the same account
									tax_portion = 0
									cost = selected_export.get_cost(0)
							else // remove tax if we cant find a parent account to pay it to.
								tax_portion = 0
								cost = selected_export.get_cost(0)
						var/e_err = checkExport()
						if(e_err)
							to_chat(usr, SPAN_WARNING("Export failed: [e_err]."))
							resetExport()
							return TOPIC_HANDLED
						var/err = money_account.deposit(cost, "Export ([selected_export.name] to [selected_beacon.name])")
						if(err)
							to_chat(usr, SPAN_WARNING("Export failed: [err]."))
							resetExport()
							return TOPIC_HANDLED

						else // SUCCESS
							if(tax_portion)
								var/datum/computer_network/network = selected_beacon.linked_controller.get_network()
								if(network && network.banking_mainframe && network.banking_mainframe.get_parent_account())
									var/datum/money_account/acc = network.banking_mainframe.get_parent_account()
									err = acc.deposit(tax_portion, "Export Tax ([selected_export.name] from [selected_beacon.name])")
							var/result = takeExport()
							if(result)
								to_chat(usr, SPAN_WARNING("Export failed: [e_err]."))

			else
				to_chat(usr, SPAN_WARNING("The network does not have a central account."))
				return TOPIC_REFRESH
	return TOPIC_REFRESH


/datum/nano_module/program/trade_management/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/trade_management/PRG = program
	var/datum/extension/interactive/os/computer = PRG.computer
	var/list/telepads[0]
	var/update_time = time2text((SStrade_beacons.last_cycle+2 HOURS),"hh:mm")
	for(var/obj/machinery/telepad_cargo/x in PRG.detected_telepads)
		var/selected = 0
		if(x == PRG.selected_telepad) selected = 1
		telepads.Add(list(list(
			"telepad_name" = "[x.name] ([x.telepad_id])",
			"selected" = selected,
			"telepad_ref" = any2ref(x),
		)))
	if(!telepads.len)
		telepads.Add(list(list(
			"telepad_name" = "No telepads detected!",
			"selected" = 1,
		)))
	data["telepads"] = telepads
	data["update_time"] = update_time
	var/obj/effect/overmap/trade_beacon/selected_beacon = PRG.selected_beacon
	if(selected_beacon)
		data["selected_beacon"] = TRUE
		data["beacon_name"] = selected_beacon.name
		var/access = 1
		if(selected_beacon && selected_beacon.linked_controller && selected_beacon.linked_controller.get_network())
			var/datum/computer_network/network = selected_beacon.linked_controller.get_network()
			data["controlling_network"] = network.network_id
			if(selected_beacon.linked_controller.beacon_restrict)
				if(selected_beacon.linked_controller.get_network() == PRG.computer.get_network())
					var/list/accesses = computer.get_access(user)
					if(selected_beacon.linked_controller.access && !(selected_beacon.linked_controller.access in accesses))
						access = 0
				else
					access = 0

		if(access)
			data["beacon_access"] = 1
			if(PRG.import_menu)
				data["import"] = 1
				var/import_tax = 0
				if(selected_beacon && selected_beacon.linked_controller)
					import_tax = selected_beacon.linked_controller.import_tax

				data["import_tax"] = import_tax
				var/list/imports[0]
				for(var/datum/beacon_import/x in selected_beacon.active_imports)
					imports.Add(list(list(
						"import_name" = x.name,
						"import_cost" = x.get_cost(import_tax),
						"import_remaining" = x.remaining_stock,
						"import_ref" = any2ref(x),
					)))
				data["imports"] = imports

			else if(PRG.export_menu)
				data["export"] = 1
				var/export_tax = 0
				if(selected_beacon && selected_beacon.linked_controller)
					export_tax = selected_beacon.linked_controller.export_tax
				data["export_tax"] = export_tax
				var/list/exports[0]
				for(var/datum/beacon_export/x in selected_beacon.active_exports)
					exports.Add(list(list(
						"export_name" = x.name,
						"export_cost" = x.get_cost(export_tax),
						"export_remaining" = x.remaining_stock,
						"export_ref" = any2ref(x),
					)))
				data["exports"] = exports
			else if(PRG.log_menu)
				data["log"] = 1
			else if(PRG.selected_import)
				switch(PRG.payment_type)
					if(1)
						data["personal_account_sel"] = 1
					if(2)
						data["charge_stick_sel"] = 1
					if(3)
						data["network_account_sel"] = 1

				var/import_tax = 0
				if(selected_beacon && selected_beacon.linked_controller)
					import_tax = selected_beacon.linked_controller.import_tax

				data["selected_import"] = PRG.selected_import.name
				data["import_cost"] = PRG.selected_import.get_cost(import_tax)
				data["import_desc"] = PRG.selected_import.desc

				var/datum/computer_file/data/account/A = PRG.computer.get_account()
				if(A)
					var/datum/money_account/child/network/money_account = A.money_account
					if(money_account)
						data["personal_account"] = money_account.account_name
						data["personal_account_balance"] = money_account.money
					else
						data["personal_account_error"] = "This account has no valid bank account associated with it on this network. Check your login details or contact a system administrator."

				else
					data["personal_account_error"] = "This account has no valid bank account associated with it on this network. Check your login details or contact a system administrator."

				var/obj/item/stock_parts/computer/charge_stick_slot/charge_slot = computer.get_component(PART_MSTICK)
				if(!charge_slot || !charge_slot.is_functional())
					data["charge_stick_error"] = "No functional charge stick slot found!"
				else if(!charge_slot.stored_stick)
					data["charge_stick_error"] = "No charge stick inserted!"
				else
					data["charge_stick"] = "Charge Stick"
					data["charge_stick_balance"] = charge_slot.stored_stick.loaded_worth
				var/datum/computer_network/net = PRG.computer.get_network()
				var/list/accesses = computer.get_access(user)
				if(net && net.banking_mainframe)
					if(!net.banking_mainframe.has_access(accesses))
						data["network_account_error"] = "You do not have access to the parent account on your current network."
					else
						var/datum/money_account/parent/network/bank_account = net.banking_mainframe.get_parent_account()
						if(!bank_account)
							data["network_account_error"] = "The network does not have a parent account created."
						else
							data["network_account"] = bank_account.account_name
							data["network_account_balance"] = bank_account.money
				else
					data["network_account_error"] = "The network does not have a banking mainframe."


			else if(PRG.selected_export)
				switch(PRG.payment_type)
					if(1)
						data["personal_account_sel"] = 1
					if(2)
						data["charge_stick_sel"] = 1
					if(3)
						data["network_account_sel"] = 1

				var/export_tax = 0
				if(selected_beacon && selected_beacon.linked_controller)
					export_tax = selected_beacon.linked_controller.export_tax

				data["selected_export"] = PRG.selected_export.name
				data["export_cost"] = PRG.selected_export.get_cost(export_tax)
				data["export_desc"] = PRG.selected_export.desc

				var/datum/computer_file/data/account/A = PRG.computer.get_account()
				if(A)
					var/datum/money_account/child/network/money_account = A.money_account
					if(money_account)
						data["personal_account"] = money_account.account_name
						data["personal_account_balance"] = money_account.money
					else
						data["personal_account_error"] = "No bank account."

				else
					data["personal_account_error"] = "Not logged in."

				var/obj/item/stock_parts/computer/charge_stick_slot/charge_slot = computer.get_component(PART_MSTICK)
				if(!charge_slot || !charge_slot.is_functional())
					data["personal_account_error"] = "Noslot found!"
				else if(!charge_slot.stored_stick)
					data["personal_account_error"] = "No charge stick!"
				else
					data["charge_stick"] = "Charge Stick"
					data["charge_stick_balance"] = charge_slot.stored_stick.loaded_worth
				var/datum/computer_network/net = PRG.computer.get_network()
				var/list/accesses = computer.get_access(user)
				if(net && net.banking_mainframe)
					if(!net.banking_mainframe.has_access(accesses))
						data["network_account_error"] = "No access."
					else
						var/datum/money_account/parent/network/bank_account = net.banking_mainframe.get_parent_account()
						if(!bank_account)
							data["network_account_error"] = "No Network Account"
						else
							data["network_account"] = bank_account.account_name
							data["network_account_balance"] = bank_account.money
				else
					data["network_account_error"] = "No Network Bank."


	else
		data["beacon_name"] = "*DISCONNECTED*"


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "trade_management.tmpl", name, 600, 750, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.set_auto_update(1)
		ui.open()

/datum/computer_file/program/trade_management/Topic(href, href_list, state)
	. = ..()
	if(.)
		return

	if(href_list["select_beacon"])
		var/obj/hold = computer.get_physical_host()
		var/list/possible_trade_beacons = hold.get_adjacent_trade_beacons()
		possible_trade_beacons += "*DISCONNECT*"
		var/beacon = input(usr, "Select a nearby trade beacon.", "Pick a beacon") as null|anything in possible_trade_beacons
		if(!CanInteract(usr, global.default_topic_state))
			return TOPIC_REFRESH
		if(beacon == "*DISCONNECT*")
			selected_beacon = null
		else if(beacon)
			selected_beacon = beacon

		return TOPIC_REFRESH
	if(href_list["import"])
		import_menu = 1
		export_menu = 0
		log_menu = 0
		selected_import = null
		selected_export = null
		return TOPIC_REFRESH
	if(href_list["export"])
		import_menu = 0
		export_menu = 1
		log_menu = 0
		selected_import = null
		selected_export = null
		return TOPIC_REFRESH
	if(href_list["log"])
		import_menu = 0
		export_menu = 0
		log_menu = 1
		selected_import = null
		selected_export = null
		return TOPIC_REFRESH
	if(href_list["select_import"])
		import_menu = 0
		export_menu = 0
		log_menu = 0
		selected_import = locate(href_list["select_import"])
		selected_export = null
		return TOPIC_REFRESH
	if(href_list["select_export"])
		import_menu = 0
		export_menu = 0
		log_menu = 0
		selected_import = null
		selected_export = locate(href_list["select_export"])
		return TOPIC_REFRESH
	if(href_list["select_personal_account"])
		payment_type = 1
		return TOPIC_REFRESH
	if(href_list["select_charge_stick"])
		payment_type = 2
		return TOPIC_REFRESH
	if(href_list["select_network_account"])
		payment_type = 3
		return TOPIC_REFRESH
	if(href_list["select_telepad"])
		detect_telepads()
		var/obj/T = locate(href_list["select_telepad"])
		if(T && (T in detected_telepads))
			selected_telepad = T
		return TOPIC_REFRESH
	if(href_list["refresh_telepad"])
		detect_telepads()
		return TOPIC_REFRESH
	if(href_list["buy_import"])
		return buyImport()
	if(href_list["buy_export"])
		return buyExport()
