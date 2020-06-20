/obj/machinery/vending/infini/botany
	name = "PlantVend Essentials"
	desc = "Everything you need for a space garden."
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	icon_vend = "nutri-vend"

	base_type = /obj/machinery/vending/hydronutrients
	products = list(
		/obj/item/storage/box/chargen/botany/starter = 999,
		/obj/item/storage/box/chargen/botany/watertank = 999,
		/obj/item/storage/box/chargen/botany/seeds = 999,
		/obj/item/storage/box/chargen/botany/hydroponics = 999
	)