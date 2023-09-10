#define CALIBER_12G "12g"

/obj/item/ammo_casing/twelvegauge
	name = "generic 12g shell"
	desc = "An unsettlingly generic 12g shell."
	icon = 'mods/persistence/icons/obj/ammunition/12g/tier1_slug.dmi'
	caliber = CALIBER_12G
	projectile_type = /obj/item/projectile/bullet/twelvegauge

/obj/item/ammo_casing/twelvegauge/slug
	name = "generic 12g slug shell"
	desc = "An unsettlingly generic 12g slug shell."
	icon = 'mods/persistence/icons/obj/ammunition/12g/tier1_slug.dmi'
	caliber = CALIBER_12G
	projectile_type = /obj/item/projectile/bullet/twelvegauge

/obj/item/projectile/bullet/twelvegauge
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	damage = 40
	distance_falloff = 3

/obj/item/ammo_casing/twelvegauge/buckshot
	name = "generic 12g buckshot shell"
	desc = "An unsettlingly generic 12g buckshot shell."
	icon = 'mods/persistence/icons/obj/ammunition/12g/tier1_buckshot.dmi'
	caliber = CALIBER_12G
	projectile_type = /obj/item/projectile/bullet/pellet/twelvegauge

/obj/item/projectile/bullet/pellet/twelvegauge
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	damage = 10
	pellets = 6
	range_step = 1
	spread_step = 10

/obj/item/ammo_casing/twelvegauge/slug/handmade
	name = "makeshift 12g slug shell"
	desc = "12g slug shell of dubious origin. Sports decent armor penetration capabilities and high damage, but suffers from poor range."
	icon = 'mods/persistence/icons/obj/ammunition/12g/tier0_slug.dmi'
	projectile_type = /obj/item/projectile/bullet/twelvegauge/handmade

/obj/item/projectile/bullet/twelvegauge/handmade
	damage = 40
	distance_falloff = 5
	penetration_modifier = 1.1

/obj/item/ammo_casing/twelvegauge/buckshot/handmade
	name = "makeshift 12g buckshot shell"
	desc = "12g buckshot shell of dubious origin. Sports high damage, but suffers from poor armor penetration and very poor range."
	icon = 'mods/persistence/icons/obj/ammunition/12g/tier0_buckshot.dmi'
	projectile_type = /obj/item/projectile/bullet/pellet/twelvegauge/handmade

/obj/item/projectile/bullet/pellet/twelvegauge/handmade
	damage = 10
	pellets = 6
	range_step = 1
	spread_step = 10
	penetration_modifier = 1.5

/obj/item/ammo_casing/twelvegauge/slug/simple
	name = "standard 12g slug shell"
	desc = "12g slug shell of ancient design. Sports decent armor penetration capabilities and high damage, but suffers from poor range."
	icon = 'mods/persistence/icons/obj/ammunition/12g/tier1_slug.dmi'
	projectile_type = /obj/item/projectile/bullet/twelvegauge/simple

/obj/item/projectile/bullet/twelvegauge/simple
	damage = 60
	distance_falloff = 5
	penetration_modifier = 0.9

/obj/item/ammo_casing/twelvegauge/buckshot/simple
	name = "standard 12g buckshot shell"
	desc = "12g buckshot shell of ancient design. Sports high damage, but suffers from poor armor penetration and very poor range."
	icon = 'mods/persistence/icons/obj/ammunition/12g/tier1_buckshot.dmi'
	projectile_type = /obj/item/projectile/bullet/pellet/twelvegauge/simple

/obj/item/projectile/bullet/pellet/twelvegauge/simple
	damage = 15
	pellets = 6
	range_step = 1
	spread_step = 10
	penetration_modifier = 1.3