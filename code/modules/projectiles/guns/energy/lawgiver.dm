/obj/item/gun/energy/lawgiver
	name = "advanced CTAC combi-pistol mk2"
	icon = 'icons/obj/guns/lawgiver.dmi'
	icon_state = ICON_STATE_WORLD
	item_state = "lawgiver"
	origin_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 5)
	sel_mode = 1
	var/mode_check = 1
	desc = "A highly advanced firearm that is capable of several different and highly lethal firing modes, the CTAC MK2 is a weapon to be feared."

	var/dna	= null//dna-locking the firearm
	var/emagged = 0 //if the gun is emagged or not
	var/owner_name = null //Name of the (initial) owner
	self_recharge = 1
	recharge_time = 20 SECONDS
	charge_cost = 15

	firemodes = list(
		list(mode_name="singleshot", projectile_type=/obj/item/projectile/bullet/pistol, charge_cost = 15, burst = 1),
		list(mode_name="rapidfire", projectile_type=/obj/item/projectile/bullet/pistol, burst = 3, charge_cost = 30),
		list(mode_name="highex", projectile_type=/obj/item/projectile/bullet/gyro/megabot, charge_cost = 600, burst = 1),
		list(mode_name="hotshot", projectile_type=/obj/item/projectile/beam/incendiary_laser, charge_cost = 200, burst = 1),
		list(mode_name="armorpiercing", projectile_type=/obj/item/projectile/bullet/hrifle, charge_cost = 150, burst = 1),
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, charge_cost = 15, burst = 1),
		list(mode_name="pellets", projectile_type=/obj/item/projectile/bullet/pellet/fragment, charge_cost = 10, burst = 1),
		)

/obj/item/gun/energy/lawgiver/Initialize()
	. = ..()
	power_supply = new /obj/item/cell/device/variable(src, 2000)
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)

/obj/item/gun/energy/lawgiver/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, pointblank=0, reflex = 0)
/*	if(src.dna != user.dna.unique_enzymes && !emagged)
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			to_chat(user, "<span class='danger'>You hear a soft beep from the gun and 'ID FAIL' flashes across the screen.</span>")
			to_chat(user, "<span class='danger'>You feel a tiny prick in your hand!</span>")
			user.drop_item() */
			//Blow up Unauthorized Users Hand//todo, delet this, as it's duplicate behaviour from Firing pins.
//			sleep(60)
//		return 0
//	..()
/*
/obj/item/gun/energy/lawgiver/proc/Emag(mob/user as mob)
	to_chat(usr, "<span class='warning'>You short out [src]'s id check</span>")
	emagged = 1
	return 1

/obj/item/gun/energy/lawgiver/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/card/emag) && !emagged)
		Emag(user)
	else
		..()

/obj/item/gun/energy/lawgiver/hear_talk(mob/living/M in range(0,src), msg)
	var/mob/living/carbon/human/H = M
	if (!H || !istype(H))
		return
	if( (src.dna==H.dna.unique_enzymes || emagged) && (src in H.contents))
		hear(msg)
	return*/

/////////////Needs a rework/////////////