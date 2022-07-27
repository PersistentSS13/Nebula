
//EFPOS
//#TODO: will need additional handling once we can rewrite how this thing inits
SAVED_VAR(/obj/item/eftpos, machine_id)
SAVED_VAR(/obj/item/eftpos, eftpos_name)
SAVED_VAR(/obj/item/eftpos, transaction_locked)
SAVED_VAR(/obj/item/eftpos, transaction_paid)
SAVED_VAR(/obj/item/eftpos, transaction_amount)
SAVED_VAR(/obj/item/eftpos, transaction_purpose)
SAVED_VAR(/obj/item/eftpos, access_code)
SAVED_VAR(/obj/item/eftpos, currency)
SAVED_VAR(/obj/item/eftpos, linked_account) //Can probably just save the account id

//ATM
SAVED_VAR(/obj/machinery/atm, held_card)
SAVED_VAR(/obj/machinery/atm, machine_id)
SAVED_VAR(/obj/machinery/atm, view_screen)
SAVED_VAR(/obj/machinery/atm, authenticated_account) //Can probably just save the account id

//Cash
SAVED_VAR(/obj/item/cash, absolute_worth)
SAVED_VAR(/obj/item/cash, currency)

//C-Stick
SAVED_VAR(/obj/item/charge_stick, loaded_worth)
SAVED_VAR(/obj/item/charge_stick, creator)
SAVED_VAR(/obj/item/charge_stick, id)
SAVED_VAR(/obj/item/charge_stick, currency)
SAVED_VAR(/obj/item/charge_stick, grade)
