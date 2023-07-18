#define CALIBER_22LR ".22LR"

/obj/item/ammo_casing/twentytwolr
	name = "generic .22LR round"
	desc = "An unsettlingly generic .22LR round."
	icon = 'mods/persistence/icons/obj/ammunition/22lr/tier1.dmi'
	caliber = CALIBER_22LR
	projectile_type = /obj/item/projectile/bullet/twentytwolr

/obj/item/projectile/bullet/twentytwolr
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	damage = 10
	distance_falloff = 1

/obj/item/ammo_casing/twentytwolr/handmade
	name = "makeshift .22LR round"
	desc = ".22 Long Rifle round of dubious origin. Struggles at medium-long range and against armor due to shoddy construction."
	icon = 'mods/persistence/icons/obj/ammunition/22lr/tier0.dmi'
	projectile_type = /obj/item/projectile/bullet/twentytwolr/handmade

/obj/item/projectile/bullet/twentytwolr/handmade
	damage = 15
	distance_falloff = 6
	penetration_modifier = 1.5

/obj/item/ammo_casing/twentytwolr/simple
	name = "standard .22LR round"
	desc = ".22 Long Rifle round of ancient design. Servicable, but struggles against armored targets due to unimpressive stopping power."
	icon = 'mods/persistence/icons/obj/ammunition/22lr/tier1.dmi'
	projectile_type = /obj/item/projectile/bullet/twentytwolr/simple

/obj/item/projectile/bullet/twentytwolr/simple
	damage = 25
	distance_falloff = 4
	penetration_modifier = 1.2