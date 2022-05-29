/obj/machinery/Initialize()
	// Initialize expects that construct_state will be a path.
	if(istype(construct_state))
		construct_state = construct_state.type
	. = ..()

/obj/machinery/populate_parts(full_populate)
	if(persistent_id) // Only objects that have been loaded with have this var set at creation, so we prevent recreating additional components.
		return
	. = ..()

/obj/machinery/before_save()
	. = ..()
	initial_access = list() // Remove initial_access so that access isn't wiped on load.



SAVED_VAR(/obj/machinery, stat)
SAVED_VAR(/obj/machinery, emagged)
SAVED_VAR(/obj/machinery, malf_upgraded)
SAVED_VAR(/obj/machinery, use_power)
SAVED_VAR(/obj/machinery, uid)
SAVED_VAR(/obj/machinery, panel_open)
SAVED_VAR(/obj/machinery, uncreated_component_parts)
SAVED_VAR(/obj/machinery, construct_state)
SAVED_VAR(/obj/machinery, id_tag)
SAVED_VAR(/obj/machinery, req_access)

SAVED_VAR(/obj/machinery/power/terminal,  master)

SAVED_VAR(/obj/item/stock_parts, status)
SAVED_VAR(/obj/item/stock_parts, req_access)

SAVED_VAR(/obj/item/stock_parts/radio/transmitter, range)
SAVED_VAR(/obj/item/stock_parts/radio/transmitter, latency)
SAVED_VAR(/obj/item/stock_parts/radio/transmitter, buffer)

SAVED_VAR(/obj/item/stock_parts/radio, id_tag)
SAVED_VAR(/obj/item/stock_parts/radio, frequency)
SAVED_VAR(/obj/item/stock_parts/radio, filter)
SAVED_VAR(/obj/item/stock_parts/radio, encryption)
SAVED_VAR(/obj/item/stock_parts/radio, multitool_extension)

SAVED_VAR(/obj/item/stock_parts/radio/receiver, receive_and_write)
SAVED_VAR(/obj/item/stock_parts/radio/receiver, receive_and_call)

SAVED_VAR(/obj/item/stock_parts/radio/transmitter/basic, transmit_on_tick)
SAVED_VAR(/obj/item/stock_parts/radio/transmitter/basic, transmit_on_change)

SAVED_VAR(/obj/item/stock_parts/radio/transmitter/on_event, event)
SAVED_VAR(/obj/item/stock_parts/radio/transmitter/on_event, transmit_on_event)

SAVED_VAR(/obj/item/stock_parts/capacitor, charge)

SAVED_VAR(/obj/item/stock_parts/computer/ai_slot, stored_card)

SAVED_VAR(/obj/item/stock_parts/computer/battery_module, battery)

SAVED_VAR(/obj/item/stock_parts/computer/hard_drive, stored_files)
SAVED_VAR(/obj/item/stock_parts/computer/hard_drive, used_capacity)

SAVED_VAR(/obj/item/stock_parts/computer/card_slot, stored_card)

SAVED_VAR(/obj/item/stock_parts/computer/nano_printer, stored_paper)

SAVED_VAR(/obj/item/stock_parts/computer/network_card,  long_range)
SAVED_VAR(/obj/item/stock_parts/computer/network_card, ethernet)

SAVED_VAR(/obj/item/stock_parts/building_material,  materials)

SAVED_VAR(/obj/item/stock_parts/power/terminal, terminal)
SAVED_VAR(/obj/item/stock_parts/power/terminal, terminal_dir)

SAVED_VAR(/obj/item/stock_parts/computer/charge_stick_slot,  stored_stick)

SAVED_VAR(/obj/item/stock_parts/network_receiver/network_lock, grants)
SAVED_VAR(/obj/item/stock_parts/network_receiver/network_lock, initial_network_id)
SAVED_VAR(/obj/item/stock_parts/network_receiver/network_lock, initial_network_key)
SAVED_VAR(/obj/item/stock_parts/network_receiver/network_lock, emagged)