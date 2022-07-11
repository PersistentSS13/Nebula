/obj/item/gun/projectile/Initialize()
	if(persistent_id)
		starts_loaded = FALSE
	. = ..()

SAVED_VAR(/obj/item/gun/projectile, chambered)
SAVED_VAR(/obj/item/gun/projectile, ammo_magazine)