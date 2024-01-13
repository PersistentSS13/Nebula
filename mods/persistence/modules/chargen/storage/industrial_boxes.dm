/obj/item/chargen_box/industrial/engineering
	name = "engineering toolkit"
	icon_state = "survival"
	startswith = list(
		/obj/item/storage/toolbox/mechanical = 1,
		/obj/item/clothing/head/welding = 1,
		/obj/item/clothing/gloves/insulated = 1
	)

/obj/item/chargen_box/industrial/firefighter
	name = "firefighter kit"
	startswith = list(
		/obj/item/clothing/suit/fire = 1,
		/obj/item/clothing/head/hardhat/damage_control = 1,
		/obj/item/tank/emergency/oxygen/double/red = 1,
		/obj/item/clothing/accessory/fire_overpants = 1,
		/obj/item/clothing/gloves/fire = 1,
		/obj/item/chems/spray/extinguisher = 1,
		/obj/item/clothing/mask/breath/scba = 1
	)

/obj/item/chargen_box/industrial/building
	name = "assorted building materials"
	startswith = list(
		/obj/item/stack/material/sheet/mapped/steel/fifty = 1,
		/obj/item/stack/material/pane/mapped/glass/ten = 1,
		/obj/item/stack/material/panel/mapped/plastic/ten = 1,
		/obj/item/stack/cable_coil/random = 1
	)

/obj/item/chargen_box/industrial/steel
	name = "steel resupply pack"
	startswith = list(
		/obj/item/stack/material/sheet/mapped/steel/fifty = 2
	)

/obj/item/chargen_box/industrial/glass
	name = "glass resupply pack"
	startswith = list(
		/obj/item/stack/material/pane/mapped/glass/fifty = 2
	)

/obj/item/chargen_box/industrial/plastic
	name = "plastic resupply pack"
	startswith = list(
		/obj/item/stack/material/panel/mapped/plastic/fifty = 2
	)

/obj/item/chargen_box/industrial/cable
	name = "cable resupply pack"
	startswith = list(
		/obj/item/stack/cable_coil/random = 4
	)

/obj/item/chargen_box/industrial/autolathe
	name = "DIY autolathe kit"
	startswith = list(
		/obj/item/stock_parts/circuitboard/autolathe = 1,
		/obj/item/stack/material/sheet/mapped/steel/ten = 1,
		/obj/item/stack/cable_coil/random = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/manipulator = 1
	)

/obj/item/chargen_box/industrial/mining
	name = "complete mining kit"
	startswith = list(
		/obj/item/pickaxe = 1,
		/obj/item/clothing/suit/chem_suit = 1,
		/obj/item/clothing/head/chem_hood = 1,
		/obj/item/flashlight = 1,
		/obj/item/tank/oxygen = 1,
		/obj/item/clothing/mask/breath/scba = 1,
		/obj/item/storage/ore = 1
	)

/obj/item/chargen_box/industrial/chem_suit
	name = "replacement chemical suit"
	startswith = list(
		/obj/item/clothing/suit/chem_suit = 1,
		/obj/item/clothing/head/chem_hood = 1,
		/obj/item/tank/oxygen = 1,
		/obj/item/clothing/mask/breath/scba = 1
	)

/obj/item/chargen_box/industrial/pick
	name = "replacement mining pick"
	startswith = list(
		/obj/item/pickaxe = 1,
		/obj/item/flashlight = 1,
	)

/obj/item/chargen_box/industrial/ore_processor
	name = "ore processing kit"
	startswith = list(
		/obj/item/stock_parts/circuitboard/mining_processor = 1,
		/obj/item/stock_parts/circuitboard/mining_compressor = 1,
		/obj/item/stock_parts/circuitboard/mining_unloader = 1,
		/obj/item/stock_parts/circuitboard/mining_stacker = 1
	)

/obj/item/chargen_box/industrial/stirling
	name = "DIY stirling generator kit"
	startswith = list(
		/obj/item/stock_parts/circuitboard/pacman = 1,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stack/cable_coil/random = 1
	)

/obj/item/chargen_box/ration/twinkies
	name = "emergency twinkie kit"
	icon_state = "donk_kit"
	startswith = list(
		/obj/item/chems/food/spacetwinkie = 8
	)

/obj/item/chargen_box/ration/mre
	name = "MRE shipment"
	startswith = list(
		/obj/item/storage/mre/random = 5
	)

/obj/item/chargen_box/industrial/cheap_mining
	name = "'Colonist's First' super-ultra-deluxe mining kit(TM)"
	startswith = list(
		/obj/item/pickaxe/cheap = 1,
		/obj/item/clothing/suit/chem_suit/cheap = 1,
		/obj/item/clothing/head/chem_hood/cheap = 1,
		/obj/item/flashlight/lantern/cheap = 1,
		/obj/item/tank/oxygen/cheap = 1,
		/obj/item/clothing/mask/breath/scba/cheap = 1,
		/obj/item/storage/ore/cheap = 1
	)