
//EFTPOS
SAVED_VAR(/obj/item/eftpos, machine_id)
SAVED_VAR(/obj/item/eftpos, eftpos_name)
SAVED_VAR(/obj/item/eftpos, transaction_locked)
SAVED_VAR(/obj/item/eftpos, transaction_paid)
SAVED_VAR(/obj/item/eftpos, transaction_amount)
SAVED_VAR(/obj/item/eftpos, transaction_purpose)
SAVED_VAR(/obj/item/eftpos, access_code)
SAVED_VAR(/obj/item/eftpos, currency)
SAVED_VAR(/obj/item/eftpos, linked_account) //Can probably just save the account id

// Network EFTPOS. For Persistence purposes, these deprecate the normal EFTPOS devices.
SAVED_VAR(/obj/item/network_pos, account_id)
SAVED_VAR(/obj/item/network_pos, account_provider)

//ATM
SAVED_VAR(/obj/machinery/atm, held_card)
SAVED_VAR(/obj/machinery/atm, machine_id)
SAVED_VAR(/obj/machinery/atm, view_screen)
SAVED_VAR(/obj/machinery/atm, authenticated_account) //Can probably just save the account id

// These don't currently serve a purpose for us, so remove them from availability.
/datum/fabricator_recipe/engineering/atm_board
	fabricator_types = list()
	path = /obj/item/stock_parts/circuitboard/requests_console/atm

/datum/fabricator_recipe/engineering/atm_frame
	fabricator_types = list()
	path = /obj/item/frame/stock_offset/atm

/datum/fabricator_recipe/engineering/atm_kit
	fabricator_types = list()
	path = /obj/item/frame/stock_offset/atm/kit

//Cash
SAVED_VAR(/obj/item/cash, absolute_worth)
SAVED_VAR(/obj/item/cash, currency)

//C-Stick
SAVED_VAR(/obj/item/charge_stick, loaded_worth)
SAVED_VAR(/obj/item/charge_stick, creator)
SAVED_VAR(/obj/item/charge_stick, id)
SAVED_VAR(/obj/item/charge_stick, currency)
SAVED_VAR(/obj/item/charge_stick, grade)

// Money printer
SAVED_VAR(/obj/item/stock_parts/computer/money_printer, stored_plastic)