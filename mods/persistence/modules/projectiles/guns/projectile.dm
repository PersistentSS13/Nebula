/obj/item/gun/projectile/Initialize()
	if(persistent_id)
		starts_loaded = FALSE
	. = ..()

SAVED_VAR(/obj/item/gun/projectile, chambered)
SAVED_VAR(/obj/item/gun/projectile, ammo_magazine)

/obj/item/gun/projectile/update_base_icon()
	if(ammo_magazine)
		if(ammo_magazine.stored_ammo.len)
			icon_state = "[get_world_inventory_state()]-loaded"
		else
			icon_state = "[get_world_inventory_state()]-empty"
	else
		icon_state = get_world_inventory_state()