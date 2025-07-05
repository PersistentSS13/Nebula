/obj/machinery/network/bank
	name = "banking mainframe"
	desc = "A mainframe used for managing network finances. It must be interfaced with remotely."
	icon = 'icons/obj/machines/bank_controller.dmi'
	icon_state = "hub"
	network_device_type =  /datum/extension/network_device/bank
	main_template = "banking_mainframe.tmpl"
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	base_type = /obj/machinery/network/bank

	var/preset_account_name
	var/preset_fractional_reserve

	var/auto_money_accounts = FALSE
	var/auto_interest_rate
	var/auto_withdrawal_limit
	var/auto_transaction_fee

/obj/machinery/network/bank/ui_data(mob/user, ui_key)
	. = ..()

	var/datum/extension/network_device/bank = get_extension(src, /datum/extension/network_device)
	if(!bank)
		return

	var/datum/computer_network/network = bank.get_network()
	if(!network)
		return

	.["money_cubes"] = list()
	for(var/datum/extension/network_device/money_cube/cube in network.money_cubes)
		var/z = get_z(cube.holder)
		var/obj/effect/overmap/visitable/cube_location = z ? global.overmap_sectors["[z]"] : null
		.["money_cubes"] += list(list(
			"tag" = cube.network_tag,
			"location" = cube_location ? cube_location.name : "Unknown"
		))