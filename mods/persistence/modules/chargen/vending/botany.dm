/obj/machinery/vending/infini/botany
	name = "PlantVend Essentials"
	desc = "Everything you need for a space garden."
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	icon_vend = "nutri-vend"
	vend_delay = 26
	base_type = /obj/machinery/vending/hydronutrients
	products = list(
		/obj/item/chargen_box/botany/starter = 999,
		/obj/item/chargen_box/botany/watertank = 999,
		/obj/item/chargen_box/botany/seeds = 999,
		/obj/item/chargen_box/botany/hydroponics = 999
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	
/obj/machinery/vending/infini/food
	name = "Brownstone Solutions Snack-o-Matic"
	desc = "Advanced packaged food synthesizer. Uses electricity and hyper-technology to create food almost instantly. Brought to you by Brownstone Solutions, Inc."
	markup = 0
	icon_state = "nutri"
	icon_vend = "nutri-vend"
	vend_delay = 26
	base_type = /obj/machinery/vending/infini/food
	products = list(
		/obj/item/chargen_box/ration/twinkies = 999,
		/obj/item/chargen_box/ration/mre = 999,
		/obj/item/chems/food/can/beef = 999,
		/obj/item/chems/food/can/beans = 999,
		/obj/item/chems/food/can/tomato = 999,
		/obj/item/chems/food/sosjerky = 999,
		/obj/item/chems/food/no_raisin = 999,
		/obj/item/chems/food/cheesiehonkers = 999,
		/obj/item/chems/food/syndicake = 999,
		/obj/item/chems/food/pistachios = 999,
		/obj/item/chems/food/lunacake = 999,
		/obj/item/chems/food/lunacake/mochicake = 999,
		/obj/item/chems/food/lunacake/mooncake = 999,
		/obj/item/chems/food/triton = 999,
		/obj/item/chems/food/saturn = 999,
		/obj/item/chems/food/pluto = 999,
		/obj/item/chems/food/venus = 999,
		/obj/item/chems/food/chips = 999,
		/obj/item/chems/food/candy = 999,
		/obj/item/chems/food/tastybread = 999,
		/obj/item/chems/food/liquidfood = 999,
		/obj/item/chems/drinks/cans/waterbottle = 999,
		/obj/item/chems/drinks/cans/iced_tea = 999,
		/obj/item/chems/drinks/cans/grape_juice = 999,
		/obj/item/chems/drinks/cans/cola = 999,
		/obj/item/chems/drinks/cans/space_up = 999,
		/obj/item/chems/drinks/cans/dr_gibb = 999,
		/obj/item/chems/drinks/cans/speer = 999,
		/obj/item/chems/drinks/cans/ale = 999
	)
