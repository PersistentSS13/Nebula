#define CALIBER_556 "5.56x45mm"

/obj/item/ammo_casing/fivefiftysix
	name = "generic 5.56x45mm round"
	desc = "An unsettlingly generic 5.56x45mm round."
	icon = 'mods/persistence/icons/obj/ammunition/5.56/tier1.dmi'
	caliber = CALIBER_556
	projectile_type = /obj/item/projectile/bullet/fivefiftysix

/obj/item/projectile/bullet/fivefiftysix
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	damage = 25
	distance_falloff = 1

/obj/item/ammo_casing/fivefiftysix/handmade
	name = "makeshift 5.56x45mm round"
	desc = "5.56x45mm round of dubious origin. Sports poor range and poor armor penetration due to shoddy construction."
	icon = 'mods/persistence/icons/obj/ammunition/5.56/tier0.dmi'
	projectile_type = /obj/item/projectile/bullet/fivefiftysix/handmade

/obj/item/projectile/bullet/fivefiftysix/handmade
	damage = 35
	distance_falloff = 4
	penetration_modifier = 1

/obj/item/ammo_casing/fivefiftysix/simple
	name = "standard 5.56x45mm round"
	desc = "5.56x45mm round of ancient design. Sports good armor penetration capabilities, but most firearms which use it are bulky."
	icon = 'mods/persistence/icons/obj/ammunition/5.56/tier1.dmi'
	projectile_type = /obj/item/projectile/bullet/fivefiftysix/simple

/obj/item/projectile/bullet/fivefiftysix/simple
	damage = 45
	distance_falloff = 2
	penetration_modifier = 0.8