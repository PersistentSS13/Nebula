/datum/computer_file/program/rent_management
	filename = "rentmnrger"
	filedesc = "Sector Rent Management"
	extended_desc = "This program allows you to pay the rental fees for sectors."

	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "cart"

	available_on_network = 1

	size = 12
	nanomodule_path = /datum/nano_module/program/rent_management

	var/weakref/target_sector

/datum/computer_file/program/rent_management/on_startup(mob/living/user, datum/extension/interactive/os/new_host)
	. = ..()
	var/atom/holder = computer.holder
	if(!holder)
		return
	var/obj/effect/overmap/visitable/target = holder.get_owning_overmap_object()
	if(!target || istype(target, /obj/effect/overmap/visitable/sector/planetoid/exoplanet))
		return
	target_sector = weakref(target)

/datum/computer_file/program/rent_management/on_shutdown()
	. = ..()
	target_sector = null

/datum/nano_module/program/rent_management
	name = "Sector Rent Management"

/datum/nano_module/program/rent_management/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/rent_management/PRG = program
	var/weakref/target_sector = PRG.target_sector
	var/obj/effect/overmap/visitable/target = target_sector?.resolve()
	if(!target)
		data["error"] = TRUE
	else
		data["sector_name"] = target.name
		data["rent_paid"] = target.paid_rent
		data["rent_due"] = SSpersistence.rent_enabled ? target.rent_amount : 0
		data["rent_date"] = SSpersistence.rent_enabled ? time2text(target.last_due + target.rent_period, "MM-DD") : "Rent payment has been deferred by local authorities."

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "rent_management.tmpl", name, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.set_auto_update(1)
		ui.open()

/datum/computer_file/program/rent_management/Topic(href, href_list, state)
	. = ..()
	if(.)
		return

	if(href_list["pay"])
		var/obj/item/stock_parts/computer/charge_stick_slot/charge_slot = computer.get_component(PART_MSTICK)
		if(!charge_slot || !charge_slot.is_functional())
			to_chat(usr, SPAN_WARNING("No functional charge stick slot found!"))
			return TOPIC_HANDLED
		if(!charge_slot.stored_stick)
			to_chat(usr, SPAN_WARNING("No charge stick inserted!"))
			return TOPIC_HANDLED

		var/obj/item/charge_stick/stick = charge_slot.stored_stick
		var/paid_amount = input(usr, "How much of the rent would you like to pay?", "Rent Payment", 0) as num | null
		if(!paid_amount)
			return TOPIC_HANDLED
		if(!CanInteract(usr, state))
			return TOPIC_HANDLED
		if(paid_amount > stick.loaded_worth)
			to_chat(usr, SPAN_WARNING("The loaded charge stick does not have enough credits stored!"))
			return TOPIC_HANDLED

		var/obj/effect/overmap/visitable/target = target_sector.resolve()
		if(!target)
			to_chat(usr, SPAN_WARNING("Unable to locate sector!"))
			return TOPIC_HANDLED

		target.paid_rent += paid_amount
		stick.adjust_worth(-(paid_amount))
		return TOPIC_REFRESH