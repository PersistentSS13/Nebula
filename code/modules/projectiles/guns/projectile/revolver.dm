/obj/item/gun/projectile/revolver
	name = "revolver"
	desc = "The al-Maliki & Mosley Magnum Double Action is a choice revolver for when you absolutely, positively need to put a hole in the other guy."
	icon = 'icons/obj/guns/revolvers.dmi'
	icon_state = ICON_STATE_WORLD
	safety_icon = "safety"
	caliber = CALIBER_PISTOL_MAGNUM
	origin_tech = "{'combat':2,'materials':2}"
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	fire_delay = 12 //Revolvers are naturally slower-firing
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	var/chamber_offset = 0 //how many empty chambers in the cylinder until you hit a round
	mag_insert_sound = 'sound/weapons/guns/interaction/rev_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/rev_magout.ogg'
	accuracy = 2
	accuracy_power = 8
	one_hand_penalty = 2
	bulk = 3

/obj/item/gun/projectile/revolver/verb/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object"

	chamber_offset = 0
	visible_message("<span class='warning'>\The [usr] spins the cylinder of \the [src]!</span>", \
	"<span class='notice'>You hear something metallic spin and click.</span>")
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	loaded = shuffle(loaded)
	if(rand(1,max_shells) > loaded.len)
		chamber_offset = rand(0,max_shells - loaded.len)

/obj/item/gun/projectile/revolver/consume_next_projectile()
	if(chamber_offset)
		chamber_offset--
		return
	return ..()

/obj/item/gun/projectile/revolver/load_ammo(var/obj/item/A, mob/user)
	chamber_offset = 0
	return ..()

/obj/item/gun/projectile/revolver/stun
	ammo_type = /obj/item/ammo_casing/pistol/magnum/stun

/obj/item/gun/projectile/revolver/capgun
	name = "cap gun"
	desc = "Looks almost like the real thing! Ages 8 and up."
	caliber = CALIBER_CAPS
	origin_tech = "{'combat':1,'materials':1}"
	ammo_type = /obj/item/ammo_casing/cap
	var/cap = TRUE

/obj/item/gun/projectile/revolver/capgun/on_update_icon()
	. = ..()
	if(cap)
		overlays += image(icon, "[icon_state]-toy")

/obj/item/gun/projectile/revolver/capgun/attackby(obj/item/wirecutters/W, mob/user)
	if(!istype(W) || !cap)
		return ..()
	to_chat(user, "<span class='notice'>You snip off the toy markings off the [src].</span>")
	name = "revolver"
	desc += " Someone snipped off the barrel's toy mark. How dastardly."
	cap = FALSE
	update_icon()
	return 1

/obj/item/gun/projectile/revolver/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/revolver_spin_cylinder)

/decl/interaction_handler/revolver_spin_cylinder
	name = "Spin Cylinder"
	expected_target_type = /obj/item/gun/projectile/revolver

/decl/interaction_handler/revolver_spin_cylinder/invoked(var/atom/target, var/mob/user)
	var/obj/item/gun/projectile/revolver/R = target
	R.spin_cylinder()

/obj/item/gun/projectile/revolver/matax
	name = "Matax 12"
	desc = "A martian revolver of ancient design intended for use by ground police forces and for civilian self-defense. The Matax model is known as a reliable weapon galaxy-wide, though its use of pistol rounds leaves it lacking in stopping power. Chambered in .32 rounds."
	icon = 'mods/persistence/icons/obj/guns/tier1/matax.dmi'
	origin_tech = "{'combat':3,'engineering':2,'materials':2}"
	caliber = CALIBER_REVOLVER
	ammo_type = /obj/item/ammo_casing/revolver
	max_shells = 6
	fire_delay = 15
	accuracy = 0
	one_hand_penalty = 0
	force = 5

/obj/item/gun/projectile/revolver/k7
	name = "K-7 Revolver"
	desc = "The K-7 is a rare Martian Arms revolver mostly seen by outlaws and frontier worlds, it has a magnetic trigger system which allows it to fire faster. The cylinder also fit 8 rounds. Chambered in 10mm rounds."
	icon = 'mods/persistence/icons/obj/guns/tier1/k7.dmi'
	origin_tech = "{'combat':3,'engineering':2,'materials':2}"
	caliber = CALIBER_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	max_shells = 8
	fire_delay = 4
	accuracy = 1
	one_hand_penalty = 0
	force = 5

/obj/item/gun/projectile/revolver/mx2
	name = "MX-2 Revolver"
	desc = "The MX-2 is a heavy HexGuard revolver that has a smooth wooden grip with a stainless steel body. The cylinder also fit 6 rounds. Chambered in 15mm rounds."
	icon = 'mods/persistence/icons/obj/guns/tier1/k7.dmi'
	origin_tech = "{'combat':3,'engineering':2,'materials':2}"
	caliber = CALIBER_PISTOL_MAGNUM
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	max_shells = 8
	fire_delay = 4
	accuracy = 1
	one_hand_penalty = 0
	force = 5

/obj/item/gun/projectile/revolver/blade
	name = "BLADER Revolver"
	desc = "The Blader is a rare SmartInc revolver using extremely powerful bullets to penetrate most targets. The cylinder also fit 10 rounds. Chambered in 15mm rounds."
	icon = 'mods/persistence/icons/obj/guns/tier1/blade.dmi'
	origin_tech = "{'combat':3,'engineering':2,'materials':2}"
	caliber = CALIBER_PISTOL_MAGNUM
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	max_shells = 10
	fire_delay = 20
	accuracy = 1
	one_hand_penalty = 0
	force = 5
	ammo_indicator = TRUE

/obj/item/gun/projectile/revolver/bladeblack
	name = "BLADER Revolver (Chomie)"
	desc = "The Blader is a rare SmartInc revolver using extremely powerful bullets to penetrate most targets. This one seems to be made with a special metal alloy. Chambered in 15mm rounds."
	icon = 'mods/persistence/icons/obj/guns/tier1/bladec.dmi'
	origin_tech = "{'combat':3,'engineering':2,'materials':2}"
	caliber = CALIBER_PISTOL_MAGNUM
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	max_shells = 10
	fire_delay = 20
	accuracy = 1
	one_hand_penalty = 0
	force = 5
	ammo_indicator = TRUE