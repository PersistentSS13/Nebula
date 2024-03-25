/obj/structure/closet/malf/suits
	desc = "It's a storage unit for operational gear."
	closet_appearance = /decl/closet_appearance/tactical
	//mapper preview
	color = COLOR_RED_GRAY

/obj/structure/closet/malf/suits/WillContain()
	return list(
		/obj/item/tank/jetpack/void,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/head/helmet/space/void,
		/obj/item/clothing/suit/space/void,
		/obj/item/crowbar,
		/obj/item/cell,
		/obj/item/multitool)
