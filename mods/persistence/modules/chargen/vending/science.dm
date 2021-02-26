/obj/machinery/vending/infini/science
	name = "NanoSci Plus"
	desc = "Medical drug & science dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	icon_vend = "med-vend"
	vend_delay = 18
	base_type = /obj/machinery/vending/infini/science
	products = list(
		/obj/item/chargen_box/science/rnd = 999,
		/obj/item/chargen_box/science/emt = 999,
		/obj/item/chargen_box/science/doctor = 999,
		/obj/item/chargen_box/science/surgery = 999,
		/obj/item/chargen_box/science/burn_toxin = 999,
		/obj/item/chargen_box/science/refill = 999
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.