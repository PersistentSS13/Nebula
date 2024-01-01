#define CALIBER_357 ".357"

/obj/item/ammo_casing/threefiftyseven
	name = "generic .357 round"
	desc = "An unsettlingly generic .357 round."
	icon = 'mods/persistence/icons/obj/ammunition/357/tier1.dmi'
	caliber = CALIBER_357
	projectile_type = /obj/item/projectile/bullet/threefiftyseven

/obj/item/projectile/bullet/threefiftyseven
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	damage = 30
	distance_falloff = 1

/obj/item/ammo_casing/threefiftyseven/handmade
	name = "makeshift .357 round"
	desc = ".357 round of dubious origin. Sports poor range and poor armor penetration due to shoddy construction."
	icon = 'mods/persistence/icons/obj/ammunition/357/tier0.dmi'
	projectile_type = /obj/item/projectile/bullet/threefiftyseven/handmade

/obj/item/projectile/bullet/threefiftyseven/handmade
	damage = 40
	distance_falloff = 6

/obj/item/ammo_casing/threefiftyseven/simple
	name = "standard .357 round"
	desc = ".357 round of ancient design. Sports mediocre range due to unimpressive velocity."
	icon = 'mods/persistence/icons/obj/ammunition/357/tier1.dmi'
	projectile_type = /obj/item/projectile/bullet/threefiftyseven/simple

/obj/item/projectile/bullet/threefiftyseven/simple
	damage = 50
	distance_falloff = 4
	penetration_modifier = 0.9

/obj/item/ammo_casing/threefiftyseven/advanced
	name = "advanced .357 round"
	desc = ".357 round of modern design. Sports middling range and acceptable armor penetration due to modern construction techniques."
	icon = 'mods/persistence/icons/obj/ammunition/357/tier2.dmi'
	projectile_type = /obj/item/projectile/bullet/threefiftyseven/advanced

/obj/item/projectile/bullet/threefiftyseven/advanced
	damage = 60
	distance_falloff = 3
	penetration_modifier = 0.8