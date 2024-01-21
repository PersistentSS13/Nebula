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

/obj/item/ammo_casing/twelvegauge/slug/tierzero
	name = "makeshift 12g slug shell"
	desc = "12g slug shell of dubious origin. Sports decent armor penetration capabilities and high damage, but suffers from poor range."
	icon = 'mods/persistence/icons/obj/ammunition/12g/tier0_slug.dmi'
	projectile_type = /obj/item/projectile/bullet/twelvegauge/tierzero

/obj/item/projectile/bullet/twelvegauge/tierzero
	damage = 40
	distance_falloff = 5
	penetration_modifier = 1.1

/obj/item/ammo_casing/twelvegauge/buckshot/tierzero
	name = "makeshift 12g buckshot shell"
	desc = "12g buckshot shell of dubious origin. Sports high damage, but suffers from poor armor penetration and very poor range."
	icon = 'mods/persistence/icons/obj/ammunition/12g/tier0_buckshot.dmi'
	projectile_type = /obj/item/projectile/bullet/pellet/twelvegauge/tierzero

/obj/item/projectile/bullet/pellet/twelvegauge/tierzero
	damage = 10
	pellets = 6
	range_step = 1
	spread_step = 10
	penetration_modifier = 1.5

/obj/item/ammo_casing/twelvegauge/slug/tierone
	name = "standard 12g slug shell"
	desc = "12g slug shell of ancient design. Sports decent armor penetration capabilities and high damage, but suffers from poor range."
	icon = 'mods/persistence/icons/obj/ammunition/12g/tier1_slug.dmi'
	projectile_type = /obj/item/projectile/bullet/twelvegauge/tierone

/obj/item/projectile/bullet/twelvegauge/tierone
	damage = 60
	distance_falloff = 5
	penetration_modifier = 0.9

/obj/item/ammo_casing/twelvegauge/buckshot/tierone
	name = "standard 12g buckshot shell"
	desc = "12g buckshot shell of ancient design. Sports high damage, but suffers from poor armor penetration and very poor range."
	icon = 'mods/persistence/icons/obj/ammunition/12g/tier1_buckshot.dmi'
	projectile_type = /obj/item/projectile/bullet/pellet/twelvegauge/tierone

/obj/item/projectile/bullet/pellet/twelvegauge/tierone
	damage = 15
	pellets = 6
	range_step = 1
	spread_step = 10
	penetration_modifier = 1.3

/obj/item/ammo_casing/twelvegauge/slug/tiertwo
	name = "advanced 12g slug shell"
	desc = "12g slug shell of modern design. Sports good armor penetration capabilities and very high damage, but suffers from unimpressive range."
	icon = 'mods/persistence/icons/obj/ammunition/12g/tier2_slug.dmi'
	projectile_type = /obj/item/projectile/bullet/twelvegauge/tiertwo

/obj/item/projectile/bullet/twelvegauge/tiertwo
	damage = 70
	distance_falloff = 4
	penetration_modifier = 0.85

/obj/item/ammo_casing/twelvegauge/buckshot/tiertwo
	name = "advanced 12g buckshot shell"
	desc = "12g buckshot shell of modern design. Sports incredibly high damage, but suffers from poor armor penetration and poor range."
	icon = 'mods/persistence/icons/obj/ammunition/12g/tier2_buckshot.dmi'
	projectile_type = /obj/item/projectile/bullet/pellet/twelvegauge/tiertwo

/obj/item/projectile/bullet/pellet/twelvegauge/tiertwo
	damage = 20
	pellets = 6
	range_step = 1
	spread_step = 8
	penetration_modifier = 1.25