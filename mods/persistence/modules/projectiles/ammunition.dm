/obj/item/ammo_casing/before_save()
	. = ..()
	// Don't bother saving the individual bullets, rebuild on load.
	CUSTOM_SV("loaded", !!BB)

/obj/item/ammo_casing/after_deserialize()
	. = ..()
	var/loaded = LOAD_CUSTOM_SV("loaded")
	if(!loaded)
		projectile_type = null

// Prevent ammo magazines from repopulating on load
// TODO: Ammo should be flattened in some way
/obj/item/ammo_magazine/Initialize()
	if(persistent_id)
		initial_ammo = 0
	. = ..()

SAVED_VAR(/obj/item/ammo_magazine, stored_ammo)