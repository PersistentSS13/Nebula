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

/obj/item/ammo_casing/twentytwolr/tierzero
	name = "makeshift .22LR round"
	desc = ".22 Long Rifle round of dubious origin. Sports poor range and very poor armor penetration due to shoddy construction."
	icon = 'mods/persistence/icons/obj/ammunition/22lr/tier0.dmi'
	projectile_type = /obj/item/projectile/bullet/twentytwolr/tierzero

/obj/item/projectile/bullet/twentytwolr/tierzero
	damage = 15
	distance_falloff = 6
	penetration_modifier = 1.5

/obj/item/ammo_casing/twentytwolr/tierone
	name = "standard .22LR round"
	desc = ".22 Long Rifle round of ancient design. Sports unimpressive range and poor armor penetration due to low velocity."
	icon = 'mods/persistence/icons/obj/ammunition/22lr/tier1.dmi'
	projectile_type = /obj/item/projectile/bullet/twentytwolr/tierone

/obj/item/projectile/bullet/twentytwolr/tierone
	damage = 25
	distance_falloff = 4
	penetration_modifier = 1.2

/obj/item/ammo_casing/twentytwolr/tiertwo
	name = "advanced .22LR round"
	desc = ".22 Long Rifle round of modern design. Sports mediocre range and unimpressive armor penetration due to low velocity."
	icon = 'mods/persistence/icons/obj/ammunition/22lr/tier2.dmi'
	projectile_type = /obj/item/projectile/bullet/twentytwolr/tiertwo

/obj/item/projectile/bullet/twentytwolr/tiertwo
	damage = 30
	distance_falloff = 3