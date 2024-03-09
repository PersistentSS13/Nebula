/obj/machinery/conveyor/outreach


///////////////////////////////////////////////////////
// Transport Return Belt
///////////////////////////////////////////////////////

/obj/machinery/conveyor_switch/oneway/outreach/mining/transport_return
	name   = "outgoing belt control"
	id_tag = "oh_b1_mining_transport_return"

/obj/machinery/conveyor_switch/oneway/outreach/mining/transport_return/cabled
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup,
	)

/obj/machinery/conveyor/outreach/mining/transport_return
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup,
	)
	id_tag = "oh_b1_mining_transport_return"

///////////////////////////////////////////////////////
// Transport Ore Belts
///////////////////////////////////////////////////////

/obj/machinery/conveyor_switch/oneway/outreach/mining/transport
	name   = "incoming ores belt control"
	id_tag = "oh_b1_mining_transport"

/obj/machinery/conveyor_switch/oneway/outreach/mining/transport/cabled
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup,
	)

/obj/machinery/conveyor/outreach/mining/transport
	uncreated_component_parts = list(
		/obj/item/stock_parts/power/terminal/buildable,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/terminal_setup,
	)
	id_tag = "oh_b1_mining_transport"


///////////////////////////////////////////////////////
// Ore To Processing Belts
///////////////////////////////////////////////////////

/obj/machinery/conveyor_switch/outreach/mining/raw_proc
	name   = "raw ore to processing belt control"
	id_tag = "oh_b1_mining_raw_to_proc"

/obj/machinery/conveyor/outreach/mining/raw_proc
	id_tag = "oh_b1_mining_raw_to_proc"


///////////////////////////////////////////////////////
// Incoming Ore Unloading Belts
///////////////////////////////////////////////////////

/obj/machinery/conveyor_switch/outreach/mining/unloader_out
	name   = "unloader belt to outgoing belt control"
	id_tag = "oh_b1_mining_unloader_to_out"

/obj/machinery/conveyor/outreach/mining/unloader_out
	id_tag = "oh_b1_mining_unloader_to_out"

///////////////////////////////////////////////////////
// Smelter Processing Belt
///////////////////////////////////////////////////////

/obj/machinery/conveyor_switch/outreach/mining/smelter
	id_tag = "oh_b1_mining_smelter"

/obj/machinery/conveyor/outreach/mining/smelter
	id_tag = "oh_b1_mining_smelter"


///////////////////////////////////////////////////////
// Compressor Processing Belt
///////////////////////////////////////////////////////

/obj/machinery/conveyor_switch/outreach/mining/compressor
	id_tag = "oh_b1_mining_compressor"

/obj/machinery/conveyor/outreach/mining/compressor
	id_tag = "oh_b1_mining_compressor"

///////////////////////////////////////////////////////
// Material Processor Belt
///////////////////////////////////////////////////////

/obj/machinery/conveyor_switch/outreach/mining/processor
	id_tag = "oh_b1_mining_processor"

/obj/machinery/conveyor/outreach/mining/processor
	id_tag = "oh_b1_mining_processor"

///////////////////////////////////////////////////////
// Stacker Feed Belt
///////////////////////////////////////////////////////

/obj/machinery/conveyor_switch/oneway/outreach/mining/stacker
	name   = "stacker belt control"
	id_tag = "oh_b1_mining_stacker"

/obj/machinery/conveyor/outreach/mining/stacker
	id_tag = "oh_b1_mining_stacker"

///////////////////////////////////////////////////////
// Mining To Cargo Belt
///////////////////////////////////////////////////////

/obj/machinery/conveyor_switch/outreach/mining/cargo_delivery
	name   = "delivery belt control"
	id_tag = "oh_b1_mining_to_cargo_belt"

/obj/machinery/conveyor/outreach/mining/cargo_delivery
	id_tag = "oh_b1_mining_to_cargo_belt"


///////////////////////////////////////////////////////
// Cargo Teleporter Belt
///////////////////////////////////////////////////////

/obj/machinery/conveyor_switch/outreach/cargo/teleporter
	id_tag = "oh_gf_cargo_teleporter"
/obj/machinery/conveyor/outreach/cargo/teleporter
	id_tag = "oh_gf_cargo_teleporter"

///////////////////////////////////////////////////////
// Cargo Mail Belt
///////////////////////////////////////////////////////

/obj/machinery/conveyor_switch/outreach/cargo/mail
	id_tag = "oh_gf_cargo_mail"
/obj/machinery/conveyor/outreach/cargo/mail
	id_tag = "oh_gf_cargo_mail"

///////////////////////////////////////////////////////
// Cargo Mail Belt
///////////////////////////////////////////////////////

/obj/machinery/conveyor_switch/outreach/cargo/distribution
	id_tag = "oh_gf_cargo_mail_out"
/obj/machinery/conveyor/outreach/cargo/distribution
	id_tag = "oh_gf_cargo_mail_out"


///////////////////////////////////////////////////////
// Cargo Desk Belt
///////////////////////////////////////////////////////

/obj/machinery/conveyor_switch/outreach/cargo/desk
	id_tag = "oh_gf_cargo_desk"
/obj/machinery/conveyor/outreach/cargo/desk
	id_tag = "oh_gf_cargo_desk"

///////////////////////////////////////////////////////
// Disposal Belt
///////////////////////////////////////////////////////

/obj/machinery/conveyor_switch/outreach/disposal
	id_tag = "oh_gf_disposal"
/obj/machinery/conveyor/outreach/disposal
	id_tag = "oh_gf_disposal"