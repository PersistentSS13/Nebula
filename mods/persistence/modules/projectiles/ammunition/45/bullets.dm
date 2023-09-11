#define CALIBER_45 ".45"

/obj/item/ammo_casing/fortyfive
	name = "generic .45 round"
	desc = "An unsettlingly generic .45 round."
	icon = 'mods/persistence/icons/obj/ammunition/45/tier1.dmi'
	caliber = CALIBER_45
	projectile_type = /obj/item/projectile/bullet/fortyfive

/obj/item/projectile/bullet/fortyfive
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	damage = 20
	distance_falloff = 1

/obj/item/ammo_casing/fortyfive/handmade
	name = "makeshift .45 round"
	desc = ".45 round of dubious origin. Sports poor range and poor armor penetration due to shoddy construction."
	icon = 'mods/persistence/icons/obj/ammunition/45/tier0.dmi'
	projectile_type = /obj/item/projectile/bullet/fortyfive/handmade

/obj/item/projectile/bullet/fortyfive/handmade
	damage = 30
	distance_falloff = 5
	penetration_modifier = 1.2

/obj/item/ammo_casing/fortyfive/simple
	name = "standard .45 round"
	desc = ".45 round of ancient design. Sports mediocre range due to unimpressive velocity."
	icon = 'mods/persistence/icons/obj/ammunition/45/tier1.dmi'
	projectile_type = /obj/item/projectile/bullet/fortyfive/simple

/obj/item/projectile/bullet/fortyfive/simple
	damage = 40
	distance_falloff = 3