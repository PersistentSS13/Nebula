
/obj/machinery/vending/infini/industrial
	name = "Brownstone Solutions Toolfab Deluxe"
	desc = "An engineering vendor that synthesizes both basic engineering equipment and materials for use in building."
	markup = 0
	icon_state = "tool"
	icon_deny = "tool-deny"
	icon_vend = "tool-vend"
	vend_delay = 11
	base_type = /obj/machinery/vending/infini/industrial
	products = list(
		/obj/item/chargen_box/industrial/engineering = 999,
		/obj/item/chargen_box/industrial/firefighter = 999,
		/obj/item/chargen_box/industrial/building = 999,
		/obj/item/chargen_box/industrial/steel = 999,
		/obj/item/chargen_box/industrial/glass = 999,
		/obj/item/chargen_box/industrial/plastic = 999,
		/obj/item/chargen_box/industrial/cable = 999,
		/obj/item/chargen_box/industrial/autolathe = 999,
		/obj/item/chargen_box/industrial/mining = 999,
		/obj/item/chargen_box/industrial/chem_suit = 999,
		/obj/item/chargen_box/industrial/pick = 999,
		/obj/item/chargen_box/industrial/ore_processor = 999,
		/obj/item/chargen_box/industrial/stirling = 999
	)

/obj/machinery/vending/infini/industrial/basic
	name = "Brownstone Solutions Toolfab Standard"
	desc = "An engineering vendor that synthesizes basic engineering equipment. Unfortunately, this one lacks the correct modules to print building materials."
	markup = 0
	icon_state = "tool"
	icon_deny = "tool-deny"
	icon_vend = "tool-vend"
	vend_delay = 11
	base_type = /obj/machinery/vending/infini/industrial/basic
	products = list(
		/obj/item/chargen_box/industrial/engineering = 999,
		/obj/item/chargen_box/industrial/firefighter = 999,
		/obj/item/chargen_box/industrial/autolathe = 999,
		/obj/item/chargen_box/industrial/mining = 999,
		/obj/item/chargen_box/industrial/pick = 999,
		/obj/item/chargen_box/industrial/ore_processor = 999,
		/obj/item/chargen_box/industrial/stirling = 999
	)

/obj/machinery/vending/infini/industrial/crap_mining
	name = "Brownstone Solutions Minefab Basic"
	desc = "An engineering vendor that synthesizes exceptionally poor-quality mining equipment. On the bright side, the cash input is shorted out; everything is free!"
	markup = 0
	icon_state = "tool"
	icon_deny = "tool-deny"
	icon_vend = "tool-vend"
	vend_delay = 11
	base_type = /obj/machinery/vending/infini/industrial/crap_mining
	products = list(
		/obj/item/chargen_box/industrial/cheap_mining = 999,
		/obj/item/pickaxe/cheap = 999,
		/obj/item/clothing/suit/chem_suit/cheap = 999,
		/obj/item/clothing/head/chem_hood/cheap = 999,
		/obj/item/flashlight/lantern/cheap = 999,
		/obj/item/tank/oxygen/cheap = 999,
		/obj/item/clothing/mask/breath/scba/cheap = 999,
		/obj/item/storage/ore/cheap = 999
	)
