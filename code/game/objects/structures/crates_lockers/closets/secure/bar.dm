/obj/structure/closet/secure_closet/bar
	name = "booze closet"
	req_access = list(access_bar)
	closet_appearance = /decl/closet_appearance/cabinet/secure
	//mapper preview
	icon  =  'icons/obj/closets/bases/cabinet.dmi'
	icon_state = "base"
	color      = WOOD_COLOR_RICH

/obj/structure/closet/secure_closet/bar/WillContain()
	return list(/obj/item/chems/drinks/bottle/small/beer = 10)
