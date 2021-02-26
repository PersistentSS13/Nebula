/obj/item/chargen_box
	name = "box"
	desc = "A large box that dissolves upon opening."
	icon = 'icons/obj/items/storage/box.dmi'
	icon_state = "box"
	item_state = "syringe_kit"

	var/startswith = list()

/obj/item/chargen_box/attack_self(mob/user)
	if(alert(user, "Would you like to open \the [src]? All items will drop onto the floor and the box will dissolve.", "[name]", "Yes", "No") == "Yes")
		for(var/item_path in startswith)
			var/list/data = startswith[item_path]
			if(islist(data))
				var/qty = data[1]
				var/list/argsl = data.Copy()
				argsl[1] = get_turf(src)
				for(var/i in 1 to qty)
					new item_path(arglist(argsl))
			else
				for(var/i in 1 to (isnull(data)? 1 : data))
					new item_path(get_turf(src))
		qdel_self()