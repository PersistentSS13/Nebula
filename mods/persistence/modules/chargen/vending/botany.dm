/obj/machinery/vending/infini/botany
	name = "PlantVend Essentials"
	desc = "Everything you need for a space garden."
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	icon_vend = "nutri-vend"
	markup = 0
	vend_delay = 26
	base_type = /obj/machinery/vending/hydronutrients
	products = list(
		/obj/item/chargen_box/botany/starter = 999,
		/obj/item/chargen_box/botany/watertank = 999,
		/obj/item/chargen_box/botany/seeds = 999,
		/obj/item/chargen_box/botany/hydroponics = 999
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
