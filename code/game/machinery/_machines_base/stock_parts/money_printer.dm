/obj/item/stock_parts/computer/money_printer
	name = "cryptographic micro-printer"
	desc = "A micro-printer capable of scanning, recycling, and printing cryptographically secured bank notes on ultra thin plastic."
	icon_state = "printer"
	material   = /decl/material/solid/plastic
	matter     = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/silicon = MATTER_AMOUNT_REINFORCEMENT
	)
	max_health = ITEM_HEALTH_NO_DAMAGE
	external_slot = TRUE

	var/stored_plastic = 0 // This could be capped, but it'd place an annoying limit on the amount of money you can insert at a given time.

/obj/item/stock_parts/computer/money_printer/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		to_chat(user, "It has [round(stored_plastic) / SHEET_MATERIAL_AMOUNT] sheets of plastic in storage.")

/obj/item/stock_parts/computer/money_printer/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, /obj/item/stack/material) && W.get_material_type() == /decl/material/solid/plastic)
		var/obj/item/stack/material/stack = W

		stored_plastic += SHEET_MATERIAL_AMOUNT * stack.amount
		to_chat(user, "You insert the plastic into \the [src]'s storage.")
		user.drop_from_inventory(stack)
		qdel(stack)

	if(IS_SCREWDRIVER(W) && !istype(loc, /obj/machinery))
		to_chat(user, "You pry out the plastic reserves of \the [src].")
		SSmaterials.create_object(/decl/material/solid/plastic, get_turf(src), round(stored_plastic / SHEET_MATERIAL_AMOUNT))
		stored_plastic = 0

	if(istype(W, /obj/item/cash))
		if(!loc)
			return
		var/datum/extension/interactive/os/current_os = get_extension(loc, /datum/extension/interactive/os)
		if(!current_os)
			to_chat(user, SPAN_WARNING("\The [src] must be installed before it can be used!"))
			return
		var/obj/item/cash/receiving = W
		var/decl/currency/receiving_currency = GET_DECL(receiving.currency)
		if(receiving_currency.material != /decl/material/solid/plastic)
			to_chat(user, SPAN_WARNING("\The [src] cannot accept cash of this currency!"))
			return

		var/amount_taken = current_os.process_cash(receiving, usr)
		if(!amount_taken)
			return
		else
			playsound(get_turf(src), pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 50, 1)
			to_chat(usr, SPAN_NOTICE("You insert [FLOOR(amount_taken / receiving_currency.absolute_value)] [receiving_currency.name] into \the [src]."))
			receiving.adjust_worth(-amount_taken)

			stored_plastic += amount_taken*max(1, round(SHEET_MATERIAL_AMOUNT/10))

			return

/obj/item/stock_parts/computer/money_printer/proc/can_print(amount, currency_type)
	if(amount < 0)
		return FALSE
	// TODO: Support for non-plastic currencies
	var/decl/currency/printed_currency = GET_DECL(currency_type)
	if(printed_currency.material != /decl/material/solid/plastic)
		return FALSE
	return (stored_plastic >= amount*max(1, round(SHEET_MATERIAL_AMOUNT/10)))

// BRRRR
/obj/item/stock_parts/computer/money_printer/proc/print_money(amount, currency_type, mob/user)
	if(!can_print(amount, currency_type))
		return FALSE

	stored_plastic -= amount*max(1, round(SHEET_MATERIAL_AMOUNT/10))

	var/obj/item/cash/cash = new(get_turf(src))
	cash.set_currency(currency_type)
	cash.adjust_worth(amount)

	if(user)
		user.put_in_hands(cash)

	return TRUE

/obj/item/stock_parts/computer/money_printer/filled
	stored_plastic = 50*SHEET_MATERIAL_AMOUNT