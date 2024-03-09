//
// Computers
//

/obj/machinery/computer/modular/preset/outreach
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/hard_drive,
		/obj/item/stock_parts/computer/network_card,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/scanner/paper,
	)
	default_software = list(
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/chatclient,
		/datum/computer_file/program/scanner,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_receiver/outreach
	)

// Engineering

/obj/machinery/computer/modular/preset/outreach/engineering
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/hard_drive,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/scanner/paper,
	)
	default_software = list(
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/reports,
		/datum/computer_file/program/scanner,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmos_control,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/network_monitor,
		/datum/computer_file/program/power_monitor,
		/datum/computer_file/program/rcon_console,
		/datum/computer_file/program/shields_monitor,
		/datum/computer_file/program/shutoff_valve,
	)
	autorun_program = /datum/computer_file/program/alarm_monitor

// Supply

/obj/machinery/computer/modular/preset/outreach/supply
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/power/battery/buildable/stock,
		/obj/item/cell/super,
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/hard_drive/super,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/scanner/paper,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/charge_stick_slot,
	)
	default_software = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/scanner,
		/datum/computer_file/program/supply,
		/datum/computer_file/program/trade_management,
		/datum/computer_file/program/merchant,
		/datum/computer_file/program/reports,
	)
	autorun_program = /datum/computer_file/program/supply

/obj/machinery/computer/modular/preset/outreach/supply/public
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/hard_drive,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/charge_stick_slot,
	)
	default_software = list(
		/datum/computer_file/program/supply,
	)
	autorun_program = /datum/computer_file/program/supply

// Mining

/obj/machinery/computer/modular/preset/outreach/mining
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/hard_drive,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/scanner/paper,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/drive_slot,
		/obj/item/stock_parts/computer/data_disk_drive,
	)
	default_software = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/scanner,
		/datum/computer_file/program/chatclient,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/reports,
		/datum/computer_file/program/supply,
		/datum/computer_file/program/suit_sensors,
	)

// Security

/obj/machinery/computer/modular/preset/outreach/security
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/power/battery/buildable/stock,
		/obj/item/cell/super,
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/hard_drive/advanced,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/scanner/paper,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/drive_slot,
		/obj/item/stock_parts/computer/data_disk_drive,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/security,
		/decl/stock_part_preset/network_receiver/outreach,
	)
	default_software = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/scanner,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/forceauthorization,
		/datum/computer_file/program/records,
		/datum/computer_file/program/reports,
	)

/obj/machinery/computer/modular/preset/outreach/security/head
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/power/battery/buildable/stock,
		/obj/item/cell/super,
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/hard_drive/advanced,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/scanner/paper,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/drive_slot,
		/obj/item/stock_parts/computer/data_disk_drive,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/security/warden,
		/decl/stock_part_preset/network_receiver/outreach,
	)
	default_software = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/scanner,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/digitalwarrant,
		/datum/computer_file/program/forceauthorization,
		/datum/computer_file/program/records,
		/datum/computer_file/program/reports,
		/datum/computer_file/program/turret_control,
	)


// public

/obj/machinery/computer/modular/preset/outreach/public
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/hard_drive,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/scanner/paper,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/drive_slot,
		/obj/item/stock_parts/computer/data_disk_drive,
	)
	default_software = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/scanner,
		/datum/computer_file/program/chatclient,
	)

// Command

/obj/machinery/computer/modular/preset/outreach/command
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/power/battery/buildable/stock,
		/obj/item/cell/super,
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
		/obj/item/stock_parts/computer/processor_unit/photonic,
		/obj/item/stock_parts/computer/hard_drive/super,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/scanner/paper,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/drive_slot,
		/obj/item/stock_parts/computer/data_disk_drive,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command,
		/decl/stock_part_preset/network_receiver/outreach,
	)
	default_software = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/records,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/accounts,
		/datum/computer_file/program/card_mod,
		/datum/computer_file/program/scanner,
		/datum/computer_file/program/reports,
		/datum/computer_file/program/supply,
	)

/obj/machinery/computer/modular/preset/outreach/command/telecomm
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
		/obj/item/stock_parts/computer/processor_unit/photonic,
		/obj/item/stock_parts/computer/hard_drive/super,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/scanner/paper,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/drive_slot,
		/obj/item/stock_parts/computer/data_disk_drive,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/tcomm,
		/decl/stock_part_preset/network_receiver/outreach,
	)
	default_software = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/scanner,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/email_administration,
		/datum/computer_file/program/network_monitor,
		/datum/computer_file/program/trade_management,
		/datum/computer_file/program/turret_control,
	)

/obj/machinery/computer/modular/preset/outreach/command/head
	default_software = list(
		/datum/computer_file/program/comm,
		/datum/computer_file/program/camera_monitor,
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/records,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/accounts,
		/datum/computer_file/program/card_mod,
		/datum/computer_file/program/scanner,
		/datum/computer_file/program/reports,
		/datum/computer_file/program/supply,
		/datum/computer_file/program/email_administration,
	)

/obj/machinery/computer/modular/preset/outreach/command/id
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/records,
		/decl/stock_part_preset/network_receiver/outreach,
	)
	default_software = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/reports,
		/datum/computer_file/program/records,
		/datum/computer_file/program/accounts,
		/datum/computer_file/program/card_mod,
		/datum/computer_file/program/scanner,
	)

/obj/machinery/computer/modular/preset/outreach/command/finance
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/power/battery/buildable/stock,
		/obj/item/cell/super,
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
		/obj/item/stock_parts/computer/processor_unit/photonic,
		/obj/item/stock_parts/computer/hard_drive/super,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/scanner/paper,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/drive_slot,
		/obj/item/stock_parts/computer/data_disk_drive,
		/obj/item/stock_parts/computer/charge_stick_slot,
		/obj/item/stock_parts/computer/money_printer/filled,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/command/finances,
		/decl/stock_part_preset/network_receiver/outreach,
	)
	default_software = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/reports,
		/datum/computer_file/program/records,
		/datum/computer_file/program/finances,
		/datum/computer_file/program/atm,
		/datum/computer_file/program/scanner,
	)

// Medical

/obj/machinery/computer/modular/preset/outreach/medical
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/hard_drive/advanced,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/ai_slot,
		/obj/item/stock_parts/computer/data_disk_drive,
		/obj/item/stock_parts/computer/drive_slot,
		/obj/item/stock_parts/computer/scanner/paper,
		/obj/item/stock_parts/computer/scanner/medical,
		/obj/item/stock_parts/computer/scanner/reagent,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/medical,
		/decl/stock_part_preset/network_receiver/outreach,
	)
	default_software = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/reports,
		/datum/computer_file/program/records,
		/datum/computer_file/program/scanner,
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/camera_monitor,
	)

/obj/machinery/computer/modular/preset/outreach/medical/cmo
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/power/battery/buildable/stock,
		/obj/item/cell/super,
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
		/obj/item/stock_parts/computer/processor_unit/photonic,
		/obj/item/stock_parts/computer/hard_drive/advanced,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/data_disk_drive,
		/obj/item/stock_parts/computer/drive_slot,
		/obj/item/stock_parts/computer/scanner/paper,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/medical/head,
		/decl/stock_part_preset/network_receiver/outreach,
	)
	default_software = list(
		/datum/computer_file/program/email_client,
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/reports,
		/datum/computer_file/program/records,
		/datum/computer_file/program/accounts,
		/datum/computer_file/program/card_mod,
		/datum/computer_file/program/scanner,
		/datum/computer_file/program/suit_sensors,
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/camera_monitor,
	)

/obj/machinery/computer/modular/preset/outreach/medical/cloning
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/apc,
		/obj/item/stock_parts/power/battery/buildable/turbo,
		/obj/item/cell/super,
		/obj/item/stock_parts/network_receiver/network_lock/buildable,
		/obj/item/stock_parts/computer/processor_unit/photonic,
		/obj/item/stock_parts/computer/hard_drive/cluster,
		/obj/item/stock_parts/computer/network_card/advanced,
		/obj/item/stock_parts/computer/nano_printer,
		/obj/item/stock_parts/computer/card_slot,
		/obj/item/stock_parts/computer/ai_slot,
		/obj/item/stock_parts/computer/charge_stick_slot,
		/obj/item/stock_parts/computer/data_disk_drive,
		/obj/item/stock_parts/computer/drive_slot,
		/obj/item/stock_parts/computer/scanner/paper,
		/obj/item/stock_parts/computer/scanner/medical,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/network_lock/outreach/medical,
		/decl/stock_part_preset/network_receiver/outreach,
	)
	default_software = list(
		/datum/computer_file/program/crew_manifest,
		/datum/computer_file/program/records,
		/datum/computer_file/program/scanner,
		/datum/computer_file/program/cloning,
	)
