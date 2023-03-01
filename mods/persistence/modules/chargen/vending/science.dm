/obj/machinery/vending/infini/science
	name = "FrontierTek Plus"
	desc = "An automated synthesizer machine that can print basic science and medical equipment, in addition to an assortment of medical supplies and drugs."
	icon_state = "med"
	icon_deny = "med-deny"
	icon_vend = "med-vend"
	vend_delay = 18
	base_type = /obj/machinery/vending/infini/science
	products = list(
		/obj/item/chargen_box/science/rnd = 999,
		/obj/item/chargen_box/science/chem = 999,
		/obj/item/chargen_box/science/emt = 999,
		/obj/item/chargen_box/science/doctor = 999,
		/obj/item/chargen_box/science/surgery = 999,
		/obj/item/chargen_box/science/refill = 999,
		/obj/item/chargen_box/science/brute = 999,
		/obj/item/chargen_box/science/burn = 999,
		/obj/item/chargen_box/science/toxin = 999,
		/obj/item/chargen_box/science/oxyloss = 999
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/infini/science/basic
	name = "FrontierTek Plus Minus"
	desc = "An automated synthesizer that can print basic science and medical equipment. This vendor in particular seems to lack the appropriate modules to synthesize medicine."
	base_type = /obj/machinery/vending/infini/science/basic
	products = list(
		/obj/item/chargen_box/science/rnd = 999,
		/obj/item/chargen_box/science/chem = 999,
		/obj/item/chargen_box/science/emt = 999,
		/obj/item/chargen_box/science/surgery = 999
	)
	
